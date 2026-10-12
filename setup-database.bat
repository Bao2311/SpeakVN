@echo off
title SpeakVN - Setup Local Database
powershell -ExecutionPolicy Bypass -File "%~dp0setup-database.ps1"
pause
