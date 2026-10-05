param([string]$BaseUrl = 'http://localhost:8085/KT_QT')
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
$settings = ConvertFrom-StringData (Get-Content (Join-Path $projectRoot 'db.local.properties') -Raw)
$builder = [System.Data.SqlClient.SqlConnectionStringBuilder]::new()
$builder['Data Source'] = "tcp:$($settings.server),$($settings.port)"
$builder['Initial Catalog'] = $settings.database
$builder['User ID'] = $settings.username
$builder['Password'] = $settings.password
$builder['TrustServerCertificate'] = $true
$db = [System.Data.SqlClient.SqlConnection]::new($builder.ConnectionString)
$handler = [System.Net.Http.HttpClientHandler]::new()
$handler.AllowAutoRedirect = $false
$client = [System.Net.Http.HttpClient]::new($handler)
$client.Timeout = [TimeSpan]::FromSeconds(20)
$testId = '0_QA_' + [Guid]::NewGuid().ToString('N').Substring(0, 12)
$testUsername = 'qa_' + [Guid]::NewGuid().ToString('N').Substring(0, 12)
$uploadedFiles = [System.Collections.Generic.HashSet[string]]::new()
$checks = 0

function Assert-Check($Condition, [string]$Message) {
    if (-not $Condition) { throw "FAIL: $Message" }
    $script:checks++
    Write-Output "PASS: $Message"
}
function Query([string]$Sql, [hashtable]$Parameters = @{}) {
    $command = $db.CreateCommand()
    $command.CommandText = $Sql
    [void]$command.Parameters.AddWithValue('@id', $testId)
    [void]$command.Parameters.AddWithValue('@username', $testUsername)
    foreach ($key in $Parameters.Keys) { [void]$command.Parameters.AddWithValue("@$key", $Parameters[$key]) }
    try { $command.ExecuteScalar() } finally { $command.Dispose() }
}
function Request([string]$Path, [hashtable]$Body, [byte[]]$UploadBytes) {
    if ($Body) {
        if ($UploadBytes) {
            $content = [System.Net.Http.MultipartFormDataContent]::new()
            foreach ($key in $Body.Keys) {
                $content.Add([System.Net.Http.StringContent]::new([string]$Body[$key]), $key)
            }
            $content.Add([System.Net.Http.ByteArrayContent]::new($UploadBytes), 'posterFile', 'poster.png')
        } else {
            $values = [System.Collections.Generic.Dictionary[string,string]]::new()
            foreach ($key in $Body.Keys) { $values.Add($key, [string]$Body[$key]) }
            $content = [System.Net.Http.FormUrlEncodedContent]::new($values)
        }
        try { $response = $client.PostAsync("$BaseUrl$Path", $content).GetAwaiter().GetResult() }
        finally { $content.Dispose() }
    } else { $response = $client.GetAsync("$BaseUrl$Path").GetAwaiter().GetResult() }
    try {
        [pscustomobject]@{
            Status = [int]$response.StatusCode
            Location = [string]$response.Headers.Location
            ContentType = [string]$response.Content.Headers.ContentType
            Content = $response.Content.ReadAsStringAsync().GetAwaiter().GetResult()
        }
    } finally { $response.Dispose() }
}
try {
    $db.Open()
    $categoryId = Query 'SELECT TOP 1 CategoryId FROM dbo.Category ORDER BY CategoryId'
    $body = @{videoId=$testId; title='Video thử nghiệm "A" & B <script>alert(1)</script>'; categoryId=$categoryId; price='69000'; description='Mô tả thử nghiệm <b>video</b>'; active='true'; poster=''}
    foreach ($path in @('/admin/videos','/admin/video/add',"/admin/video/edit?id=$testId")) {
        $result = Request $path
        Assert-Check ($result.Status -eq 302 -and $result.Location.EndsWith('/login')) "Anonymous $path requires login"
    }
    $result = Request '/admin/video/add' $body
    Assert-Check ($result.Status -eq 302 -and (Query 'SELECT COUNT(*) FROM dbo.Videos WHERE VideoId=@id') -eq 0) 'Anonymous cannot create a video'
    $result = Request '/login' @{username='user01'; password='123456'}
    foreach ($path in @('/admin/videos','/admin/video/add',"/admin/video/edit?id=$testId")) {
        $result = Request $path
        Assert-Check ($result.Status -eq 403) "Non-admin $path is forbidden"
    }
    $result = Request '/admin/video/add' $body
    Assert-Check ($result.Status -eq 403 -and (Query 'SELECT COUNT(*) FROM dbo.Videos WHERE VideoId=@id') -eq 0) 'Non-admin cannot create a video'
    $result = Request '/admin/video/edit' $body
    Assert-Check ($result.Status -eq 403) 'Non-admin cannot edit a video'
    $result = Request '/login' @{username='admin'; password='123456'}
    $result = Request '/admin/videos'
    Assert-Check ($result.Status -eq 200 -and $result.Content.Contains('/admin/video/add')) 'Admin list and navigation render'
    $result = Request '/admin/video/add'
    Assert-Check ($result.Status -eq 200 -and $result.Content.Contains('multipart/form-data') -and $result.Content.Contains('name="categoryId"')) 'Create form supports category and poster upload'
    $result = Request "/admin/video/edit?id=$testId"
    Assert-Check ($result.Status -eq 404) 'Missing edit target returns 404'

    foreach ($case in @(
        @{field='videoId'; value='../invalid'; name='Invalid primary key'},
        @{field='title'; value=''; name='Missing title'},
        @{field='title'; value=('x' * 201); name='Overlong title'},
        @{field='description'; value=('x' * 501); name='Overlong description'},
        @{field='categoryId'; value=2147483647; name='Missing category'},
        @{field='price'; value='-1'; name='Negative price'},
        @{field='price'; value='1.5'; name='Fractional VND price'},
        @{field='price'; value='invalid'; name='Non-numeric price'},
        @{field='price'; value='1000000000000000000'; name='Price exceeds database precision'},
        @{field='poster'; value='../secret.png'; name='Poster path traversal'},
        @{field='poster'; value='missing_qa_file.png'; name='Missing existing poster'}
    )) {
        $invalid = $body.Clone(); $invalid[$case.field] = $case.value
        $result = Request '/admin/video/add' $invalid
        Assert-Check ($result.Status -eq 400 -and (Query 'SELECT COUNT(*) FROM dbo.Videos WHERE VideoId=@id') -eq 0) "$($case.name) is rejected without insert"
    }
    $result = Request '/admin/video/add' $body ([System.Text.Encoding]::UTF8.GetBytes('not an image'))
    Assert-Check ($result.Status -eq 400 -and (Query 'SELECT COUNT(*) FROM dbo.Videos WHERE VideoId=@id') -eq 0) 'Fake image upload is rejected'
    $result = Request '/admin/video/add' $body ([byte[]]::new(5 * 1024 * 1024 + 1))
    Assert-Check ($result.Status -eq 400 -and (Query 'SELECT COUNT(*) FROM dbo.Videos WHERE VideoId=@id') -eq 0) 'Oversized poster upload is rejected'
    $imageBytes = [System.IO.File]::ReadAllBytes((Join-Path $projectRoot 'uploads/01.png'))
    $result = Request '/admin/video/add' $body $imageBytes
    Assert-Check ($result.Status -eq 302 -and $result.Location.Contains('create_success')) 'Create with multipart image succeeds'
    Assert-Check ((Query 'SELECT Title FROM dbo.Videos WHERE VideoId=@id') -ceq $body.title) 'Unicode and special-character title persist exactly'
    Assert-Check ((Query 'SELECT Price FROM dbo.Videos WHERE VideoId=@id') -eq 69000) 'Created price persists'
    $poster = Query 'SELECT Poster FROM dbo.Videos WHERE VideoId=@id'
    [void]$uploadedFiles.Add($poster)
    Assert-Check ($poster -match '^[a-f0-9]{32}\.png$' -and (Test-Path (Join-Path $projectRoot "uploads/$poster"))) 'Uploaded poster receives unique safe filename'
    $result = Request "/image?fname=$poster"
    Assert-Check ($result.Status -eq 200 -and $result.ContentType.StartsWith('image/png')) 'Uploaded poster is served as PNG'
    $result = Request '/admin/video/add' $body
    Assert-Check ($result.Status -eq 400 -and (Query 'SELECT COUNT(*) FROM dbo.Videos WHERE VideoId=@id') -eq 1) 'Duplicate primary key is rejected'
    $result = Request "/admin/video/edit?id=$testId"
    Assert-Check ($result.Status -eq 200 -and $result.Content.Contains('readonly') -and $result.Content.Contains('&lt;script&gt;')) 'Edit form loads immutable ID and escaped stored fields'
    $result = Request "/video/detail?id=$testId"
    Assert-Check ($result.Status -eq 200 -and $result.Content.Contains('&lt;script&gt;') -and -not $result.Content.Contains('<script>alert(1)</script>')) 'Created active video renders safely for users'

    $null = Query "INSERT INTO dbo.Users (Username,Password,Fullname,Phone,Admin,Active) VALUES (@username,'Qa!123456789','QA test','0901234567',0,1)"
    $result = Request '/login' @{username=$testUsername; password='Qa!123456789'}
    $result = Request '/cart/add' @{videoId=$testId; quantity=2}
    $result = Request '/checkout' @{receiverName='QA test'; receiverPhone='0901234567'; receiverAddress='QA address'}
    Assert-Check ($result.Status -eq 302 -and $result.Location.Contains('checkout_success')) 'Newly created video can be purchased by COD'
    $result = Request '/login' @{username='admin'; password='123456'}
    $viewsBefore = Query 'SELECT Views FROM dbo.Videos WHERE VideoId=@id'
    $edit = $body.Clone(); $edit.title = 'Video đã sửa'; $edit.price = '125000'; $edit.description = 'Updated description'; $edit.Remove('active'); $edit.poster = ''
    $result = Request '/admin/video/edit' $edit
    Assert-Check ($result.Status -eq 302 -and $result.Location.Contains('update_success')) 'Edit existing video succeeds'
    Assert-Check ((Query 'SELECT Title FROM dbo.Videos WHERE VideoId=@id') -ceq $edit.title -and (Query 'SELECT Price FROM dbo.Videos WHERE VideoId=@id') -eq 125000) 'Edited title and price persist'
    Assert-Check ((Query 'SELECT Views FROM dbo.Videos WHERE VideoId=@id') -eq $viewsBefore) 'Edit preserves view count'
    Assert-Check ((Query 'SELECT Poster FROM dbo.Videos WHERE VideoId=@id') -eq $poster) 'Edit without new poster preserves old image'
    Assert-Check ((Query 'SELECT Active FROM dbo.Videos WHERE VideoId=@id') -eq $false) 'Unchecked display switch persists inactive status'
    $result = Request '/admin/videos'
    Assert-Check ($result.Status -eq 200 -and $result.Content.Contains($testId)) 'Admin list includes inactive video'
    $result = Request "/category/videos?categoryId=$categoryId"
    Assert-Check ($result.Status -eq 200 -and -not $result.Content.Contains($testId)) 'Inactive video is excluded from user category'
    $result = Request "/video/detail?id=$testId"
    Assert-Check ($result.Status -eq 404) 'Inactive detail cannot be opened directly'
    Assert-Check ((Query 'SELECT Price FROM dbo.OrderItems WHERE VideoId=@id') -eq 69000 -and (Query 'SELECT TotalAmount FROM dbo.Orders WHERE Username=@username') -eq 138000) 'Changing video price preserves existing order prices'
    $edit.active = 'true'
    $edit.categoryId = Query 'SELECT TOP 1 CategoryId FROM dbo.Category WHERE CategoryId<>@categoryId ORDER BY CategoryId' @{categoryId=$categoryId}
    if (-not $edit.categoryId) { $edit.categoryId = $categoryId }
    $result = Request '/admin/video/edit' $edit $imageBytes
    Assert-Check ($result.Status -eq 302) 'Edit supports replacement image and reactivation'
    $replacement = Query 'SELECT Poster FROM dbo.Videos WHERE VideoId=@id'
    [void]$uploadedFiles.Add($replacement)
    Assert-Check ($replacement -ne $poster -and (Query 'SELECT CategoryId FROM dbo.Videos WHERE VideoId=@id') -eq $edit.categoryId) 'Replacement image and edited category persist'
    $result = Request "/category/videos?categoryId=$($edit.categoryId)"
    Assert-Check ($result.Status -eq 200 -and $result.Content.Contains($testId)) 'Reactivated video appears in edited user category'
    $badEdit = $edit.Clone(); $badEdit.price = '-1'
    $result = Request '/admin/video/edit' $badEdit
    Assert-Check ($result.Status -eq 400 -and (Query 'SELECT Price FROM dbo.Videos WHERE VideoId=@id') -eq 125000) 'Invalid edit does not change stored data'
    $result = Request '/admin/videos?page=999999'
    Assert-Check ($result.Status -eq 200) 'Out-of-range admin page is clamped'
    Write-Output "Verified $checks admin-video checks. Temporary data and uploaded images will be removed."
} finally {
    if ($db.State -eq 'Open') {
        $null = Query 'DELETE FROM dbo.Users WHERE Username=@username; DELETE FROM dbo.Videos WHERE VideoId=@id'
    }
    foreach ($filename in $uploadedFiles) {
        if ($filename -match '^[a-f0-9]{32}\.(png|jpg|gif)$') {
            Remove-Item -LiteralPath (Join-Path $projectRoot "uploads/$filename") -Force -ErrorAction SilentlyContinue
        }
    }
    $db.Dispose(); $client.Dispose(); $handler.Dispose()
}
