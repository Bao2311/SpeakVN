# ==============================================================
# Run Frontend: SpeakVN Journey (React + Vite)
# Port: 5173
# Proxy -> http://localhost:8082
# ==============================================================

Write-Host "Starting SpeakVN Frontend Vite Dev Server..." -ForegroundColor Cyan
Set-Location -Path $PSScriptRoot
npm run dev
