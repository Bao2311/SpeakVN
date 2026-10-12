# ==============================================================
#  setup-local-db.ps1
#  Script tạo và nạp toàn bộ database speakvn_db từ schema.sql & seed_sample_data.sql
#  Chạy: .\setup-local-db.ps1
#  Yêu cầu: PostgreSQL 17 hoặc 18 đã cài, password mặc định là 123456
# ==============================================================

$PG_BIN = if (Test-Path "C:\Program Files\PostgreSQL\17\bin") { "C:\Program Files\PostgreSQL\17\bin" } elseif (Test-Path "C:\Program Files\PostgreSQL\18\bin") { "C:\Program Files\PostgreSQL\18\bin" } else { "C:\Program Files\PostgreSQL\16\bin" }
$DB_NAME       = "speakvn_db"
$DB_USER       = "postgres"
$DB_PASS       = "123456"       # <-- Đổi nếu bạn dùng password khác
$SCHEMA_FILE   = "$PSScriptRoot\schema.sql"
$SEED_FILE     = "$PSScriptRoot\seed_sample_data.sql"

# Thêm psql vào PATH tạm thời
$env:Path = "$PG_BIN;$env:Path"
$env:PGPASSWORD = $DB_PASS

Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "  SETUP LOCAL DATABASE - speakvn_db (SpeakVN)" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

# --- Bước 1: Kiểm tra psql ---
Write-Host "[1/5] Kiem tra ket noi PostgreSQL..." -ForegroundColor Yellow
$psqlCheck = & psql -U $DB_USER -c "SELECT version();" 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "  [LOI] Khong the ket noi toi PostgreSQL!" -ForegroundColor Red
    Write-Host "  Dam bao PostgreSQL service dang chay va password dung (123456)." -ForegroundColor Red
    exit 1
}
Write-Host "  [OK] Ket noi PostgreSQL thanh cong!" -ForegroundColor Green

# --- Bước 2: Xóa database cũ nếu có ---
Write-Host ""
Write-Host "[2/5] Xoa database cu '$DB_NAME' (neu co)..." -ForegroundColor Yellow
& psql -U $DB_USER -c "DROP DATABASE IF EXISTS $DB_NAME WITH (FORCE);" 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "  [OK] Da xoa database cu sach se." -ForegroundColor Green
} else {
    Write-Host "  [CANH BAO] Khong the xoa bang WITH FORCE, thu tiep tuc..." -ForegroundColor DarkYellow
}

# --- Bước 3: Tạo database mới ---
Write-Host ""
Write-Host "[3/5] Tao database moi '$DB_NAME'..." -ForegroundColor Yellow
& psql -U $DB_USER -c "CREATE DATABASE $DB_NAME ENCODING 'UTF8';" 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "  [LOI] Khong the tao database $DB_NAME!" -ForegroundColor Red
    exit 1
}
Write-Host "  [OK] Tao database '$DB_NAME' thanh cong!" -ForegroundColor Green

# --- Bước 4: Chạy schema.sql ---
Write-Host ""
Write-Host "[4/5] Nap schema va du lieu co ban tu schema.sql (1-2 phut)..." -ForegroundColor Yellow
Write-Host "  File: $SCHEMA_FILE" -ForegroundColor Gray

if (-not (Test-Path $SCHEMA_FILE)) {
    Write-Host "  [LOI] Khong tim thay file schema.sql!" -ForegroundColor Red
    exit 1
}

& psql -U $DB_USER -d $DB_NAME -f $SCHEMA_FILE 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "  [CANH BAO] Co canh bao trong qua trinh nap schema, tiep tuc kiem tra..." -ForegroundColor DarkYellow
} else {
    Write-Host "  [OK] Nap schema.sql thanh cong!" -ForegroundColor Green
}

# --- Bước 5: Chạy seed_sample_data.sql ---
Write-Host ""
Write-Host "[5/5] Nap du lieu mau toan dien tu seed_sample_data.sql..." -ForegroundColor Yellow
Write-Host "  File: $SEED_FILE" -ForegroundColor Gray

if (Test-Path $SEED_FILE) {
    & psql -U $DB_USER -d $DB_NAME -f $SEED_FILE 2>&1 | Out-Null
    Write-Host "  [OK] Nap seed_sample_data.sql thanh cong!" -ForegroundColor Green
} else {
    Write-Host "  [CANH BAO] Khong tim thay seed_sample_data.sql, bo qua." -ForegroundColor DarkYellow
}

# --- Kiem tra tai khoan va he thong ---
Write-Host ""
Write-Host "--- KET QUA KHOI TAO DATABASE ---" -ForegroundColor Cyan
$accCount = (& psql -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM account;").Trim()
$tableCount = (& psql -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';").Trim()
$unitCount = (& psql -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM learning_unit;").Trim()

Write-Host "  + So bang da tao       : $tableCount bang" -ForegroundColor White
Write-Host "  + So bai hoc/unit      : $unitCount unit" -ForegroundColor White
Write-Host "  + So tai khoan khoi tao: $accCount tai khoan" -ForegroundColor White
Write-Host ""

# --- Tổng kết ---
Write-Host "======================================================" -ForegroundColor Green
Write-Host "  HOAN THANH SETUP DATABASE LOCAL SPEAKVN!" -ForegroundColor Green
Write-Host "======================================================" -ForegroundColor Green
Write-Host ""
Write-Host "  Database   : $DB_NAME (PostgreSQL localhost:5432)" -ForegroundColor White
Write-Host "  User       : $DB_USER | Password: $DB_PASS" -ForegroundColor White
Write-Host ""
Write-Host "  DANH SACH TAI KHOAN SAN SANG DANG NHAP (Mat khau tat ca: Pen1112003@):" -ForegroundColor Yellow
Write-Host "    [1] ADMIN     : admin@fsa.com" -ForegroundColor White
Write-Host "    [2] EDUCATOR  : educator@fsa.com" -ForegroundColor White
Write-Host "    [3] STUDENT   : student@fsa.com" -ForegroundColor White
Write-Host ""
