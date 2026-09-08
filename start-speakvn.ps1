# ==============================================================
# SpeakVN Journey - Khởi Động Toàn Diện Dự Án
# 1. Back-End: Spring Boot (Port 8082)
# 2. Front-End: React + Vite (Port 5173)
# 3. Database: PostgreSQL 18 (localhost:5432 / speakvn_db)
# ==============================================================

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "         KHOI DONG DU AN SPEAKVN JOURNEY              " -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

$BE_DIR = "$PSScriptRoot\Back-End\BE_SP26SE049"
$FE_DIR = "$PSScriptRoot\Front-End\FE_SP26SE049"

# 1. Start Backend in a new window
Write-Host "[1/2] Dang mo Backend Spring Boot (Port 8082)..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-ExecutionPolicy", "Bypass", "-File", "$BE_DIR\run-backend.ps1"

# 2. Start Frontend in a new window
Write-Host "[2/2] Dang mo Frontend Vite (Port 5173)..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-ExecutionPolicy", "Bypass", "-File", "$FE_DIR\run-frontend.ps1"

Write-Host ""
Write-Host "======================================================" -ForegroundColor Green
Write-Host "  DA MO 2 CUA SO RIENG BIET CHO BACKEND VA FRONTEND!  " -ForegroundColor Green
Write-Host "======================================================" -ForegroundColor Green
Write-Host ""
Write-Host "  - Backend API   : http://localhost:8082/swagger-ui.html" -ForegroundColor White
Write-Host "  - Frontend Web  : http://localhost:5173" -ForegroundColor White
Write-Host ""
Write-Host "  Tai khoan mau (Mat khau tat ca: Pen1112003@):" -ForegroundColor White
Write-Host "    Admin    : nguyenductuan11012003@gmail.com" -ForegroundColor Gray
Write-Host "    Educator : nguyenductuan122004@gmail.com" -ForegroundColor Gray
Write-Host "    Learner  : nguyenductuan.dev.1112003@gmail.com" -ForegroundColor Gray
Write-Host ""
