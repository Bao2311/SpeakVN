# ==============================================================
# Run Backend: FSA Capstone 2026 (SpeakVN)
# Port: 8082
# Profile: local
# ==============================================================

$JDK_PATH = "C:\Users\Boss\.jdks\openjdk-25.0.2"
$PG_BIN   = "C:\Program Files\PostgreSQL\18\bin"

if (Test-Path $JDK_PATH) {
    $env:JAVA_HOME = $JDK_PATH
    $env:Path = "$JDK_PATH\bin;$env:Path"
    Write-Host "[OK] Using Java at: $JDK_PATH" -ForegroundColor Green
}

if (Test-Path $PG_BIN) {
    $env:Path = "$PG_BIN;$env:Path"
}

Write-Host "Starting Spring Boot on port 8082 (profile: local)..." -ForegroundColor Cyan
Set-Location -Path $PSScriptRoot
& .\mvnw.cmd spring-boot:run
