param([string]$BaseUrl = 'http://localhost:8085/KT_QT')
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
$settings = ConvertFrom-StringData (Get-Content (Join-Path $projectRoot 'db.local.properties') -Raw)
$builder = [System.Data.SqlClient.SqlConnectionStringBuilder]::new()
$builder['Data Source'] = "tcp:$($settings.server),$($settings.port)"
$builder['Initial Catalog'] = $settings.database
$builder['User ID'] = $settings.username
$builder['Password'] = $settings.password
$builder['Connect Timeout'] = 5
$builder['TrustServerCertificate'] = $true
$db = [System.Data.SqlClient.SqlConnection]::new($builder.ConnectionString)
$handler = [System.Net.Http.HttpClientHandler]::new()
$handler.AllowAutoRedirect = $false
$client = [System.Net.Http.HttpClient]::new($handler)
$client.Timeout = [TimeSpan]::FromSeconds(15)
$testUsername = 'qa_' + [Guid]::NewGuid().ToString('N').Substring(0, 12)
$checks = 0

function Assert-Check($Condition, [string]$Message) {
    if (-not $Condition) { throw "FAIL: $Message" }
    $script:checks++
    Write-Output "PASS: $Message"
}

function Query([string]$Sql, [hashtable]$Parameters = @{}) {
    $command = $db.CreateCommand()
    $command.CommandText = $Sql
    [void]$command.Parameters.AddWithValue('@testUsername', $testUsername)
    foreach ($key in $Parameters.Keys) {
        [void]$command.Parameters.AddWithValue("@$key", $Parameters[$key])
    }
    try { $command.ExecuteScalar() } finally { $command.Dispose() }
}

function Request([string]$Path, [hashtable]$Body) {
    if ($Body) {
        $values = [System.Collections.Generic.Dictionary[string,string]]::new()
        foreach ($key in $Body.Keys) { $values.Add($key, [string]$Body[$key]) }
        $content = [System.Net.Http.FormUrlEncodedContent]::new($values)
        try { $response = $client.PostAsync("$BaseUrl$Path", $content).GetAwaiter().GetResult() }
        finally { $content.Dispose() }
    } else {
        $response = $client.GetAsync("$BaseUrl$Path").GetAwaiter().GetResult()
    }
    try {
        [pscustomobject]@{
            Status = [int]$response.StatusCode
            Location = [string]$response.Headers.Location
            Content = $response.Content.ReadAsStringAsync().GetAwaiter().GetResult()
        }
    } finally { $response.Dispose() }
}

try {
    $db.Open()
    foreach ($path in @('/cart', '/checkout', '/orders')) {
        $result = Request $path
        Assert-Check ($result.Status -eq 302 -and $result.Location.EndsWith('/login')) "Anonymous $path requires login"
    }
    $result = Request '/login' @{username='admin'; password='incorrect'}
    Assert-Check ($result.Status -eq 200 -and -not $result.Location) 'Incorrect password is rejected'
    $result = Request '/login' @{username='admin'; password='123456'}
    Assert-Check ($result.Status -eq 302 -and $result.Location.EndsWith('/admin/home')) 'Sample admin login succeeds'
    $result = Request '/admin/home'
    Assert-Check ($result.Status -eq 200) 'Admin dashboard renders'
    $result = Request '/login' @{username='user01'; password='123456'}
    Assert-Check ($result.Status -eq 302 -and $result.Location.EndsWith('/home')) 'Sample user login succeeds'

    $null = Query "INSERT INTO dbo.Users (Username,Password,Fullname,Phone,Admin,Active) VALUES (@testUsername,'Qa!123456789','QA test','0901234567',0,1)"
    $result = Request '/login' @{username=$testUsername; password='Qa!123456789'}
    Assert-Check ($result.Status -eq 302 -and $result.Location.EndsWith('/home')) 'Isolated test user login succeeds'
    $videoId = Query 'SELECT TOP 1 VideoId FROM dbo.Videos WHERE Active=1 ORDER BY VideoId'
    Assert-Check ([bool]$videoId) 'Active product exists'
    $categoryId = Query 'SELECT CategoryId FROM dbo.Videos WHERE VideoId=@videoId' @{videoId=$videoId}
    $result = Request "/category/videos?categoryId=$categoryId"
    Assert-Check ($result.Status -eq 200 -and $result.Content.Contains('/cart/add') -and $result.Content.Contains('name="quantity" value="1" min="1" max="10"')) 'Video list supports bounded quantity and add-to-cart form'
    $result = Request "/video/detail?id=$videoId"
    Assert-Check ($result.Status -eq 200 -and $result.Content.Contains('/cart/add') -and $result.Content.Contains('name="quantity" value="1" min="1" max="10"')) 'Video detail supports bounded quantity and add-to-cart form'
    $result = Request '/home'
    Assert-Check ($result.Status -eq 200 -and $result.Content.Contains($videoId)) 'Home renders database products'

    $result = Request '/cart/add' @{videoId=$videoId; quantity=2}
    Assert-Check ($result.Status -eq 302 -and (Query 'SELECT Quantity FROM dbo.Carts WHERE Username=@testUsername') -eq 2) 'Add to cart persists quantity'
    $result = Request '/cart/add' @{videoId=$videoId; quantity=3}
    Assert-Check ((Query 'SELECT Quantity FROM dbo.Carts WHERE Username=@testUsername') -eq 5) 'Duplicate product accumulates quantity'
    $result = Request '/cart/update' @{videoId=$videoId; quantity=999}
    Assert-Check ((Query 'SELECT Quantity FROM dbo.Carts WHERE Username=@testUsername') -eq 10) 'Quantity cannot exceed 10'
    $result = Request '/cart/update' @{videoId=$videoId; quantity=0}
    Assert-Check ((Query 'SELECT Quantity FROM dbo.Carts WHERE Username=@testUsername') -eq 1) 'Quantity cannot fall below 1'
    $result = Request '/cart/update' @{videoId=$videoId; quantity='invalid'}
    Assert-Check ((Query 'SELECT Quantity FROM dbo.Carts WHERE Username=@testUsername') -eq 1) 'Invalid numeric input is handled'
    $result = Request '/cart'
    Assert-Check ($result.Status -eq 200 -and $result.Content.Contains($videoId)) 'Cart page renders its product'
    $result = Request "/cart/remove?videoId=$videoId"
    Assert-Check ((Query 'SELECT COUNT(*) FROM dbo.Carts WHERE Username=@testUsername') -eq 0) 'Remove product clears its cart row'
    $result = Request '/cart/add' @{videoId=$videoId; quantity=2}
    $result = Request '/cart/clear'
    Assert-Check ((Query 'SELECT COUNT(*) FROM dbo.Carts WHERE Username=@testUsername') -eq 0) 'Clear cart removes all user items'
    $result = Request '/checkout'
    Assert-Check ($result.Status -eq 302 -and $result.Location.Contains('/cart')) 'Empty cart cannot proceed to checkout'
    $result = Request '/cart/add' @{videoId=$videoId; quantity=2}
    $result = Request '/checkout'
    Assert-Check ($result.Status -eq 200 -and $result.Content.Contains('COD')) 'COD checkout page renders'
    $result = Request '/checkout' @{receiverName='QA test'; receiverPhone='0901234567'; receiverAddress=''; note='QA'}
    Assert-Check ($result.Status -eq 200 -and (Query 'SELECT COUNT(*) FROM dbo.Orders WHERE Username=@testUsername') -eq 0) 'Missing address blocks order creation'
    $result = Request '/checkout' @{receiverName='QA test'; receiverPhone='0901234567'; receiverAddress='QA address'; note='Automated verification'}
    $orderId = Query 'SELECT TOP 1 OrderId FROM dbo.Orders WHERE Username=@testUsername ORDER BY OrderId DESC'
    Assert-Check ($result.Status -eq 302 -and $result.Location.Contains('checkout_success') -and $orderId -gt 0) 'COD checkout creates order'
    Assert-Check ((Query "SELECT COUNT(*) FROM dbo.Orders WHERE Username=@testUsername AND Status='NEW' AND PaymentMethod='COD' AND TotalAmount=(SELECT SUM(Price*Quantity) FROM dbo.OrderItems WHERE OrderId=@orderId)" @{orderId=$orderId}) -eq 1) 'New COD order has correct total and status'
    Assert-Check ((Query 'SELECT Quantity FROM dbo.OrderItems WHERE OrderId=@orderId' @{orderId=$orderId}) -eq 2) 'Order retains item quantity'
    Assert-Check ((Query 'SELECT COUNT(*) FROM dbo.Carts WHERE Username=@testUsername') -eq 0) 'Successful checkout clears cart'
    $result = Request '/checkout' @{receiverAddress='QA address'}
    Assert-Check ($result.Status -eq 302 -and (Query 'SELECT COUNT(*) FROM dbo.Orders WHERE Username=@testUsername') -eq 1) 'Repeated empty checkout creates no extra order'

    foreach ($status in @('NEW','CONFIRMED','PREPARING','SHIPPING','DELIVERING','DELIVERED','CANCELED','RETURNED')) {
        $null = Query 'UPDATE dbo.Orders SET Status=@status WHERE OrderId=@orderId AND Username=@testUsername' @{status=$status; orderId=$orderId}
        $result = Request "/orders?status=$status"
        Assert-Check ($result.Status -eq 200 -and $result.Content.Contains("#$orderId</h5>")) "History includes $status after database update"
        $otherStatus = if ($status -eq 'NEW') {'DELIVERED'} else {'NEW'}
        $result = Request "/orders?status=$otherStatus"
        Assert-Check ($result.Status -eq 200 -and -not $result.Content.Contains("#$orderId</h5>")) "Other filter excludes $status order"
    }
    $result = Request '/order-history'
    Assert-Check ($result.Status -eq 200 -and $result.Content.Contains("#$orderId</h5>")) 'History alias lists all statuses'
    Write-Output "Verified $checks checks. Temporary test data will be removed."
} finally {
    if ($db.State -eq 'Open') {
        $null = Query 'DELETE FROM dbo.Users WHERE Username=@testUsername'
    }
    $db.Dispose()
    $client.Dispose()
    $handler.Dispose()
}
