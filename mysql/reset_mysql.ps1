$mysqlBin = "C:\Program Files\MySQL\MySQL Server 8.0\bin"
$dataDir = "C:\ProgramData\MySQL\MySQL Server 8.0\Data"

# Create reset SQL file in a writable location
"ALTER USER 'root'@'localhost' IDENTIFIED BY 'root123';FLUSH PRIVILEGES;" | Out-File -FilePath "D:\MYSHOP\mysql\reset-init.sql" -Encoding ASCII

# Copy to data dir
Copy-Item "D:\MYSHOP\mysql\reset-init.sql" -Destination "$dataDir\reset-init.sql" -Force

# Add init-file to my.ini
$myIni = "$dataDir\..\my.ini"
$txt = Get-Content $myIni -Raw
if ($txt -notmatch "init-file") {
    $txt = $txt -replace "\[mysqld\]", "[mysqld]`r`ninit-file=C:/ProgramData/MySQL/MySQL Server 8.0/Data/reset-init.sql"
    Set-Content -Path $myIni -Value $txt -Encoding ASCII
}

# Restart MySQL service
Restart-Service -Name MySQL80 -Force

# Wait for service to restart and process init file
Start-Sleep -Seconds 5

# Remove init-file from my.ini to avoid re-execution
$txt2 = Get-Content $myIni -Raw
$txt2 = $txt2 -replace "`r`ninit-file=.*", ""
Set-Content -Path $myIni -Value $txt2 -Encoding ASCII

# Remove the init SQL
Remove-Item "$dataDir\reset-init.sql" -Force -ErrorAction SilentlyContinue

Write-Output "MySQL root password reset to: root123"
