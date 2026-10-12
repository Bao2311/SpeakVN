# ==============================================================
# Run Backend: FSA Capstone 2026 (SpeakVN)
# Port: 8082
# Profile: local
# ==============================================================

$JDK_PATHS = @(
    "C:\Users\Admin\.jdks\openjdk-25.0.2",
    "C:\Users\Boss\.jdks\openjdk-25.0.2"
)

foreach ($jdk in $JDK_PATHS) {
    if (Test-Path $jdk) {
        $env:JAVA_HOME = $jdk
        $env:Path = "$jdk\bin;$env:Path"
        Write-Host "[OK] Using Java at: $jdk" -ForegroundColor Green
        break
    }
}

$PG_PATHS = @(
    "C:\Program Files\PostgreSQL\17\bin",
    "C:\Program Files\PostgreSQL\18\bin"
)
foreach ($pg in $PG_PATHS) {
    if (Test-Path $pg) {
        $env:Path = "$pg;$env:Path"
        break
    }
}

Write-Host "Starting Spring Boot on port 8082 (profile: local)..." -ForegroundColor Cyan
Set-Location -Path $PSScriptRoot
& .\mvnw.cmd spring-boot:run
