# ==============================================================
#  setup-local-db.ps1
#  Script tạo và nạp toàn bộ database speakvn_db từ schema.sql
#  Chạy: .\setup-local-db.ps1
#  Yêu cầu: PostgreSQL 18 đã cài, password mặc định là 123456
# ==============================================================

$PG_BIN    = "C:\Program Files\PostgreSQL\18\bin"
$DB_NAME   = "speakvn_db"
$DB_USER   = "postgres"
$DB_PASS   = "123456"       # <-- Đổi nếu bạn dùng password khác
$SCHEMA_FILE = "$PSScriptRoot\schema.sql"

# Thêm psql vào PATH tạm thời
$env:Path = "$PG_BIN;$env:Path"
$env:PGPASSWORD = $DB_PASS

Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "  SETUP LOCAL DATABASE - speakvn_db" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

# --- Bước 1: Kiểm tra psql ---
Write-Host "[1/4] Kiem tra ket noi PostgreSQL..." -ForegroundColor Yellow
$psqlCheck = & psql -U $DB_USER -c "SELECT version();" 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "  [LOI] Khong the ket noi toi PostgreSQL!" -ForegroundColor Red
    Write-Host "  Dam bao PostgreSQL dang chay va password dung." -ForegroundColor Red
    exit 1
}
Write-Host "  [OK] Ket noi thanh cong!" -ForegroundColor Green

# --- Bước 2: Xóa database cũ nếu có ---
Write-Host ""
Write-Host "[2/4] Xoa database cu (neu co)..." -ForegroundColor Yellow
& psql -U $DB_USER -c "DROP DATABASE IF EXISTS $DB_NAME WITH (FORCE);" 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "  [OK] Da xoa (hoac chua ton tai)." -ForegroundColor Green
} else {
    Write-Host "  [CANH BAO] Khong xoa duoc, thu tiep tuc..." -ForegroundColor DarkYellow
}

# --- Bước 3: Tạo database mới ---
Write-Host ""
Write-Host "[3/4] Tao database moi '$DB_NAME'..." -ForegroundColor Yellow
& psql -U $DB_USER -c "CREATE DATABASE $DB_NAME ENCODING 'UTF8';" 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "  [LOI] Khong the tao database!" -ForegroundColor Red
    exit 1
}
Write-Host "  [OK] Tao database thanh cong!" -ForegroundColor Green

# --- Bước 4: Chạy schema.sql ---
Write-Host ""
Write-Host "[4/4] Nap du lieu tu schema.sql (co the mat 1-3 phut)..." -ForegroundColor Yellow
Write-Host "  File: $SCHEMA_FILE" -ForegroundColor Gray

if (-not (Test-Path $SCHEMA_FILE)) {
    Write-Host "  [LOI] Khong tim thay file schema.sql!" -ForegroundColor Red
    exit 1
}

& psql -U $DB_USER -d $DB_NAME -f $SCHEMA_FILE 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "  [CANH BAO] Co mot so lenh bi loi (co the do data da ton tai)." -ForegroundColor DarkYellow
    Write-Host "  Kiem tra lai o tren neu thay ERROR nghiem trong." -ForegroundColor DarkYellow
} else {
    Write-Host "  [OK] Nap schema va data thanh cong!" -ForegroundColor Green
}

# --- Tổng kết ---
Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "  HOAN THANH!" -ForegroundColor Green
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Database : $DB_NAME" -ForegroundColor White
Write-Host "  Host     : localhost:5432" -ForegroundColor White
Write-Host "  User     : $DB_USER" -ForegroundColor White
Write-Host "  Password : $DB_PASS" -ForegroundColor White
Write-Host ""
Write-Host "  Kiem tra ket qua trong pgAdmin hoac chay:" -ForegroundColor Gray
Write-Host "  psql -U postgres -d speakvn_db -c `"\dt`"" -ForegroundColor Gray
Write-Host ""
