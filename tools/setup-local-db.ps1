param([string]$InstanceName = 'SQLEXPRESS')
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
$configPath = Join-Path $projectRoot 'db.local.properties'
$instanceRegistry = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL'
$instanceId = $instanceRegistry.$InstanceName
if (-not $instanceId) { throw "SQL Server instance $InstanceName was not found." }
$tcpConfig = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\$instanceId\MSSQLServer\SuperSocketNetLib\Tcp\IPAll"
$sqlPort = if ($tcpConfig.TcpPort) { $tcpConfig.TcpPort } else { $tcpConfig.TcpDynamicPorts }
if (-not $sqlPort -or $sqlPort -eq '0') { throw 'SQL Server TCP port is unavailable.' }

$localSettings = @{}
if (Test-Path -LiteralPath $configPath) {
    $localSettings = ConvertFrom-StringData (Get-Content -LiteralPath $configPath -Raw)
}
$appLogin = $localSettings.username
$appPassword = $localSettings.password
if ($appLogin -notmatch '^KT_QT_web_[a-f0-9]{8}$' -or -not $appPassword) {
    $appLogin = 'KT_QT_web_' + [Guid]::NewGuid().ToString('N').Substring(0, 8)
    $appPassword = 'Kt!9' + [Convert]::ToHexString([System.Security.Cryptography.RandomNumberGenerator]::GetBytes(24))
}

$connection = [System.Data.SqlClient.SqlConnection]::new("Server=.\$InstanceName;Database=KT_QT;Integrated Security=True;Connect Timeout=5;TrustServerCertificate=True")
try {
    $connection.Open()
    $command = $connection.CreateCommand()
    $command.CommandText = [System.IO.File]::ReadAllText((Join-Path $projectRoot 'database-commerce-migration.sql'))
    [void]$command.ExecuteNonQuery()
    $command.CommandText = @'
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = @login)
BEGIN
    DECLARE @createLogin NVARCHAR(MAX) = N'CREATE LOGIN ' + QUOTENAME(@login)
        + N' WITH PASSWORD = ' + QUOTENAME(@password, '''') + N', CHECK_POLICY = ON';
    EXEC sys.sp_executesql @createLogin;
END;
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = @login)
BEGIN
    DECLARE @createUser NVARCHAR(MAX) = N'CREATE USER ' + QUOTENAME(@login) + N' FOR LOGIN ' + QUOTENAME(@login);
    EXEC sys.sp_executesql @createUser;
END;
DECLARE @grant NVARCHAR(MAX) = N'GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO ' + QUOTENAME(@login);
EXEC sys.sp_executesql @grant;
'@
    [void]$command.Parameters.AddWithValue('@login', $appLogin)
    [void]$command.Parameters.AddWithValue('@password', $appPassword)
    [void]$command.ExecuteNonQuery()

    $builder = [System.Data.SqlClient.SqlConnectionStringBuilder]::new()
    $builder['Data Source'] = "tcp:localhost,$sqlPort"
    $builder['Initial Catalog'] = 'KT_QT'
    $builder['User ID'] = $appLogin
    $builder['Password'] = $appPassword
    $builder['Connect Timeout'] = 5
    $builder['TrustServerCertificate'] = $true
    $verification = [System.Data.SqlClient.SqlConnection]::new($builder.ConnectionString)
    try { $verification.Open() } finally { $verification.Dispose() }

    $lines = @('server=localhost', "port=$sqlPort", 'database=KT_QT', "username=$appLogin", "password=$appPassword")
    [System.IO.File]::WriteAllLines($configPath, $lines, [System.Text.UTF8Encoding]::new($false))
    Write-Output "Database configuration verified on localhost:$sqlPort. Existing data retained."
} finally {
    $connection.Dispose()
}
