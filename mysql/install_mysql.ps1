$console = "C:\Program Files (x86)\MySQL\MySQL Installer for Windows\MySQLInstallerConsole.exe"
& $console community install "server;8.0.16;x64:*:port=3306;rootpasswd=root123;servicename=MySQL80"
Write-Output "Exit code: $LASTEXITCODE"
