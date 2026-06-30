@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul
title GAMING SYSTEM TOOLKIT v6.2 (Ultimate) — by Topzi-afk

:: ==========================================
:: АВТО-НАСТРОЙКА ШРИФТА ДЛЯ БОЛЬШИХ МОНИТОРОВ
:: ==========================================
reg add "HKCU\Console\Gaming System Toolkit" /v FontSize /t REG_DWORD /d 0x00120000 /f >nul 2>&1
reg add "HKCU\Console\Gaming System Toolkit" /v FaceName /t REG_SZ /d "Consolas" /f >nul 2>&1
reg add "HKCU\Console\Gaming System Toolkit" /v FontFamily /t REG_DWORD /d 0x00000036 /f >nul 2>&1
reg add "HKCU\Console\Gaming System Toolkit" /v FontWeight /t REG_DWORD /d 0x00000190 /f >nul 2>&1

:: ==========================================
:: НАДЁЖНЫЙ ОБХОД UAC (Работает на Win 10/11)
:: ==========================================
>nul 2>&1 "%SYSTEMROOT%\system32\fsutil.exe" dirty query %SYSTEMDRIVE%
if '%errorlevel%' NEQ '0' (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\uac.vbs"
    echo UAC.ShellExecute "%~f0", "", "%~dp0", "runas", 1 >> "%temp%\uac.vbs"
    "%temp%\uac.vbs"
    del "%temp%\uac.vbs"
    exit /b
)

:init_ansi
reg add "HKCU\Console" /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1
mode con: cols=100 lines=45

:: Инициализация цветов (ANSI)
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set "ESC=%%b"
set "R=%ESC%[91m"
set "G=%ESC%[92m"
set "Y=%ESC%[93m"
set "B=%ESC%[94m"
set "P=%ESC%[95m"
set "C=%ESC%[96m"
set "W=%ESC%[97m"
set "DIM=%ESC%[2m"
set "RESET=%ESC%[0m"
set "HL_BG=%ESC%[44;97m"

:: ── Меню выбора языка перед Дисклеймером ──
call :disclaimer_menu

:: ── Быстрый сбор информации о системе (Без wmic, для Win 10/11) ──
for /f "tokens=1,2,3,4 delims=|" %%a in ('powershell -NoProfile -Command "$c=(Get-CimInstance Win32_Processor).Name; $o=(Get-CimInstance Win32_OperatingSystem).Caption; $r=[math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory/1GB,1); $v=(Get-CimInstance Win32_VideoController).Name; Write-Output ($c + '|' + $o + '|' + $r + '|' + $v)"') do (
    set "SYS_CPU=%%a"
    set "SYS_OS=%%b"
    set "SYS_RAM=%%c"
    set "SYS_GPU=%%d"
)
:: Обрезаем длинные названия для идеального отображения в рамке
set "SYS_CPU=!SYS_CPU:~0,40!"
set "SYS_GPU=!SYS_GPU:~0,40!"
set "SYS_OS=!SYS_OS:~0,40!"

for /f "tokens=1,2 delims=:" %%a in ('powershell -NoProfile -Command "Get-Date -Format 'dd.MM.yyyy:HH:mm'"') do (
    set "SYS_DATE=%%a"
    set "SYS_TIME=%%b"
)

call :boot_splash
goto :main_menu

:: ══════════════════════════════════════════════════════════════════════════
::  ФУНКЦИЯ ЗАДЕРЖКИ
:: ══════════════════════════════════════════════════════════════════════════
:delay
ping 127.0.0.1 -n 1 -w %~1 >nul
exit /b

:: ══════════════════════════════════════════════════════════════════════════
::  ВЫБОР ЯЗЫКА ДЛЯ ДИСКЛЕЙМЕРА
:: ══════════════════════════════════════════════════════════════════════════
:disclaimer_menu
cls
echo.
echo   %HL_BG%====================================================================================%RESET%
echo   %HL_BG%                              ВЫБОР ЯЗЫКА / SELECT LANGUAGE                         %RESET%
echo   %HL_BG%====================================================================================%RESET%
echo.
echo   %G%[1]%W% Русский (Russian) %DIM%— по умолчанию
echo   %B%[2]%W% English
echo.
set "lang_choice="
set /p lang_choice="   %C%» Выбор (1/2): %RESET%"
if "%lang_choice%"=="2" goto :disclaimer_en
goto :disclaimer_ru

:: ══════════════════════════════════════════════════════════════════════════
::  ДИСКЛЕЙМЕР (РУССКИЙ)
:: ══════════════════════════════════════════════════════════════════════════
:disclaimer_ru
cls
echo.
echo   %P%╔══════════════════════════════════════════════════════════════════════════════════╗%RESET%
echo   %P%║%W%                      GAMING SYSTEM TOOLKIT  v6.2 (Ultimate)                      %P%║%RESET%
echo   %P%╠══════════════════════════════════════════════════════════════════════════════════╣%RESET%
echo   %P%║%C%  ПРОЕКТ С ОТКРЫТЫМ ИСХОДНЫМ КОДОМ (OPEN SOURCE)                                 %P%║%RESET%
echo   %P%║                                                                                  %P%║%RESET%
echo   %P%║%W%  Автор и разработчик: %G%Topzi-afk                                                  %P%║%RESET%
echo   %P%║%W%  GitHub: %DIM%github.com/Topzi-afk                                                   %P%║%RESET%
echo   %P%║                                                                                  %P%║%RESET%
echo   %P%║%Y%  ВНИМАНИЕ / DISCLAIMER:                                                           %P%║%RESET%
echo   %P%║%W%  Данный скрипт создан для оптимизации ОС Windows 10 и 11.                         %P%║%RESET%
echo   %P%║%W%  Проект является Open Source, абсолютно бесплатен и распространяется              %P%║%RESET%
echo   %P%║%W%  по лицензии MIT. Вы можете свободно использовать, модифицировать и               %P%║%RESET%
echo   %P%║%W%  распространять его.                                                              %P%║%RESET%
echo   %P%║                                                                                  %P%║%RESET%
echo   %P%║%W%  Инструмент вносит изменения в системный реестр, службы и                         %P%║%RESET%
echo   %P%║%W%  планировщик задач для повышения FPS и снижения задержек в играх.                 %P%║%RESET%
echo   %P%║                                                                                  %P%║%RESET%
echo   %P%║%R%  Автор не несет ответственности за любые поломки, потерю данных или               %P%║%RESET%
echo   %P%║%R%  нестабильность системы. ВСЕ ДЕЙСТВИЯ ВЫ ВЫПОЛНЯЕТЕ НА СВОЙ СТРАХ!                %P%║%RESET%
echo   %P%║                                                                                  %P%║%RESET%
echo   %P%║%G%  РЕКОМЕНДАЦИЯ: Обязательно создайте точку восстановления системы                 %P%║%RESET%
echo   %P%║%G%  перед использованием твиаков!                                                    %P%║%RESET%
echo   %P%║                                                                                  %P%║%RESET%
echo   %P%║%Y%  [!] ЕСЛИ ТЕКСТ МЕЛКИЙ: ЗАЖМИТЕ CTRL И КРУТИТЕ КОЛЕСО МЫШИ ВВЕРХ                  %P%║%RESET%
echo   %P%╠══════════════════════════════════════════════════════════════════════════════════╣%RESET%
echo   %P%║%Y%  [1] Сменить язык (Change language)                                              %P%║%RESET%
echo   %P%║%G%  [2] Принимаю условия и продолжаю (I accept)                                     %P%║%RESET%
echo   %P%╚══════════════════════════════════════════════════════════════════════════════════╝%RESET%
echo.
set "dis_choice="
set /p dis_choice="   %C%» Выбор: %RESET%"
if "%dis_choice%"=="1" goto :disclaimer_en
if "%dis_choice%"=="2" exit /b
goto :disclaimer_ru

:: ══════════════════════════════════════════════════════════════════════════
::  ДИСКЛЕЙМЕР (АНГЛИЙСКИЙ)
:: ══════════════════════════════════════════════════════════════════════════
:disclaimer_en
cls
echo.
echo   %B%╔══════════════════════════════════════════════════════════════════════════════════╗%RESET%
echo   %B%║%W%                      GAMING SYSTEM TOOLKIT  v6.2 (Ultimate)                      %B%║%RESET%
echo   %B%╠══════════════════════════════════════════════════════════════════════════════════╣%RESET%
echo   %B%║%C%  OPEN SOURCE PROJECT                                                             %B%║%RESET%
echo   %B%║                                                                                  %B%║%RESET%
echo   %B%║%W%  Author and Developer: %G%Topzi-afk                                                 %B%║%RESET%
echo   %B%║%W%  GitHub: %DIM%github.com/Topzi-afk                                                   %B%║%RESET%
echo   %B%║                                                                                  %B%║%RESET%
echo   %B%║%Y%  WARNING / DISCLAIMER:                                                           %B%║%RESET%
echo   %B%║%W%  This script is designed to optimize Windows 10 and 11 OS.                       %B%║%RESET%
echo   %B%║%W%  The project is Open Source, absolutely free, and distributed under              %B%║%RESET%
echo   %B%║%W%  the MIT license. You are free to use, modify, and distribute it.                %B%║%RESET%
echo   %B%║                                                                                  %B%║%RESET%
echo   %B%║%W%  The tool makes changes to the system registry, services, and task               %B%║%RESET%
echo   %B%║%W%  scheduler to increase FPS and reduce latency in games.                          %B%║%RESET%
echo   %B%║                                                                                  %B%║%RESET%
echo   %B%║%R%  The author is not responsible for any breakdowns, data loss, or                 %B%║%RESET%
echo   %B%║%R%  system instability. YOU USE IT AT YOUR OWN RISK!                                %B%║%RESET%
echo   %B%║                                                                                  %B%║%RESET%
echo   %B%║%G%  RECOMMENDATION: Be sure to create a System Restore point before                 %B%║%RESET%
echo   %B%║%G%  using any tweaks!                                                               %B%║%RESET%
echo   %B%║                                                                                  %B%║%RESET%
echo   %B%║%Y%  [!] IF TEXT IS SMALL: HOLD CTRL AND SCROLL MOUSE WHEEL UP                       %B%║%RESET%
echo   %B%╠══════════════════════════════════════════════════════════════════════════════════╣%RESET%
echo   %B%║%Y%  [1] Change language (Сменить язык)                                             %B%║%RESET%
echo   %B%║%G%  [2] I accept the terms and continue                                            %B%║%RESET%
echo   %B%╚══════════════════════════════════════════════════════════════════════════════════╝%RESET%
echo.
set "dis_choice="
set /p dis_choice="   %C%» Choice: %RESET%"
if "%dis_choice%"=="1" goto :disclaimer_ru
if "%dis_choice%"=="2" exit /b
goto :disclaimer_en

:: ══════════════════════════════════════════════════════════════════════════
::  АНИМАЦИЯ ЗАГРУЗКИ
:: ══════════════════════════════════════════════════════════════════════════
:boot_splash
cls
echo.
echo   %C%╔══════════════════════════════════════════════════════════════════════════════════╗%RESET%
echo   %C%║                                                                                  ║%RESET%
echo   %C%║   %W%██████╗ ████████╗  ████████╗ ██████╗  ██╗  ██╗ ██╗                            %C%║%RESET%
echo   %C%║   %C%██╔════╝ ╚══██╔══╝  ╚══██╔══╝██╔═══██╗██║ ██╔╝ ██║                            %C%║%RESET%
echo   %C%║   %G%██║  ███╗   ██║        ██║   ██║   ██║█████╔╝  ██║                            %C%║%RESET%
echo   %C%║   %Y%██║   ██║   ██║        ██║   ██║   ██║██╔═██╗  ██║                            %C%║%RESET%
echo   %C%║   %P%╚██████╔╝   ██║        ██║   ╚██████╔╝██║  ██╗ ██║                            %C%║%RESET%
echo   %C%║   %R% ╚═════╝    ╚═╝        ╚═╝    ╚═════╝ ╚═╝  ╚═╝ ╚═╝                            %C%║%RESET%
echo   %C%║                                                                                  ║%RESET%
echo   %C%║         %W%S Y S T E M   T O O L K I T   v 6 . 2%C%                                 %C%║%RESET%
echo   %C%║                                                                                  ║%RESET%
echo   %C%╚══════════════════════════════════════════════════════════════════════════════════╝%RESET%
echo.
echo   %DIM%%C%                  by Topzi-afk / Open Source Project%RESET%
echo.
call :delay 600

echo   %Y%  Инициализация системы...%RESET%
echo.
<nul set /p "=   %C%["
for /l %%i in (1,1,30) do (
    <nul set /p "=%G%█%RESET%"
    call :delay 35
)
echo %C%]%RESET%
echo.
echo   %G%  [ОК] Готово! Добро пожаловать, Администратор.%RESET%
call :delay 500
exit /b

:: ══════════════════════════════════════════════════════════════════════════
::  УНИВЕРСАЛЬНАЯ АНИМАЦИЯ УСТАНОВКИ
:: ══════════════════════════════════════════════════════════════════════════
:anim_install
echo.
<nul set /p "   %C%["
for /l %%i in (1,1,20) do (
    <nul set /p "=%Y%▓%RESET%"
    call :delay 50
)
echo %C%] %G%100%%%RESET%
exit /b

:: ══════════════════════════════════════════════════════════════════════════
::  ГЛАВНОЕ МЕНЮ
:: ══════════════════════════════════════════════════════════════════════════
:main_menu
cls
set "choice="
echo   %C%╔══════════════════════════════════════════════════════════════════════════════════╗%RESET%
echo   %C%║%W%                          GAMING SYSTEM TOOLKIT  v6.2                            %C%║%RESET%
echo   %C%╠══════════════════════════════════════════════════════════════════════════════════╣%RESET%
echo   %C%║%G%  CPU: %W%!SYS_CPU!%C%                                                                      ║%RESET%
echo   %C%║%G%  GPU: %W%!SYS_GPU!%C%                                                                      ║%RESET%
echo   %C%║%G%  RAM: %W%!SYS_RAM! GB     OS: !SYS_OS!%C%                                                ║%RESET%
echo   %C%║%Y%  Дата: %W%!SYS_DATE!   Время: !SYS_TIME!%C%                                               ║%RESET%
echo   %C%╠══════════════════════════════════════════════════════════════════════════════════╣%RESET%
echo   %C%║                                                                                  ║%RESET%
echo   %C%║  %G%[1]%W%  [ SOFT ]   Базовый Софт и Активация                                           %C%║%RESET%
echo   %C%║  %G%[2]%W%  [ DIAG ]   Диагностика и Стресс-тесты                                         %C%║%RESET%
echo   %C%║  %G%[3]%W%  [ TWEAK ]   Твики Windows и FPS-Оптимизация                                   %C%║%RESET%
echo   %C%║  %G%[4]%W%  [ NET  ]   Сеть, DNS, VPN и Безопасность                                     %C%║%RESET%
echo   %C%║  %G%[5]%W%  [ PAD  ]   Геймпады и Периферия                                              %C%║%RESET%
echo   %C%║  %G%[6]%W%  [AUDIO]   Аудио, Захват и Стриминг                                          %C%║%RESET%
echo   %C%║  %G%[7]%W%  [ DEV  ]   Разработка и Гейминг-инструменты                                 %C%║%RESET%
echo   %C%║  %G%[8]%W%  [CLEAN ]   Очистка и Обслуживание системы                                   %C%║%RESET%
echo   %C%║                                                                                  ║%RESET%
echo   %C%║  %R%[9]%W%  [EXIT ]   Выход из программы                                                %C%║%RESET%
echo   %C%║                                                                                  ║%RESET%
echo   %C%╠══════════════════════════════════════════════════════════════════════════════════╣%RESET%
echo   %C%║%Y%  [!] ЕСЛИ ТЕКСТ МЕЛКИЙ: ЗАЖМИТЕ CTRL И КРУТИТЕ КОЛЕСО МЫШИ ВВЕРХ                  %C%║%RESET%
echo   %C%╚══════════════════════════════════════════════════════════════════════════════════╝%RESET%
echo.
set /p choice="   %C%» Раздел (1-9) + Enter: %RESET%"

if "%choice%"=="1" goto :menu_soft
if "%choice%"=="2" goto :menu_diag
if "%choice%"=="3" goto :menu_tweaks
if "%choice%"=="4" goto :menu_net
if "%choice%"=="5" goto :menu_periph
if "%choice%"=="6" goto :menu_audio
if "%choice%"=="7" goto :menu_dev
if "%choice%"=="8" goto :menu_clean
if "%choice%"=="9" goto :exit_toolkit
goto :main_menu

:: ══════════════════════════════════════════════════════════════════════════
::  [1] БАЗОВЫЙ СОФТ И АКТИВАЦИЯ
:: ══════════════════════════════════════════════════════════════════════════
:menu_soft
cls
set "choice="
echo   %G%╔══════════════════════════════════════════════════════════════════════════════════╗%RESET%
echo   %G%║         [ SOFT ]  УСТАНОВКА БАЗОВОГО СОФТА И АКТИВАЦИИ                            ║%RESET%
echo   %G%╠══════════════════════════════════════════════════════════════════════════════════╣%RESET%
echo   %G%║  %P%[1]%W%  WinUtil — Браузеры, Steam, Discord, OBS одним кликом                    %G%║%RESET%
echo   %G%║  %P%[2]%W%  MAS — Чистая активация Windows и Office                               %G%║%RESET%
echo   %G%║  %P%[3]%W%  DirectX + Visual C++ Runtimes (полный пак)                           %G%║%RESET%
echo   %G%║  %P%[4]%W%  7-Zip — Лучший архиватор (бесплатно)                                %G%║%RESET%
echo   %G%║  %P%[5]%W%  WinRAR — Популярный архиватор                                        %G%║%RESET%
echo   %G%║  %P%[6]%W%  VLC Media Player — Воспроизведение любого медиа                    %G%║%RESET%
echo   %G%║  %P%[7]%W%  Notepad++ — Продвинутый текстовый редактор                         %G%║%RESET%
echo   %G%║  %P%[8]%W%  Revo Uninstaller — Полное удаление программ                        %G%║%RESET%
echo   %G%║  %P%[9]%W%  Everything — Мгновенный поиск файлов на ПК                         %G%║%RESET%
echo   %G%║  %P%[A]%W%  Telegram Desktop                                                    %G%║%RESET%
echo   %G%║  %P%[B]%W%  qBittorrent — Чистый торрент-клиент                                %G%║%RESET%
echo   %G%║  %P%[C]%W%  PotPlayer — Мощный медиаплеер для геймеров                         %G%║%RESET%
echo   %G%║  %P%[D]%W%  ShareX — Бесплатные скриншоты и запись экрана                      %G%║%RESET%
echo   %G%║  %P%[E]%W%  KeePassXC — Менеджер паролей (оффлайн)                            %G%║%RESET%
echo   %G%╠══════════════════════════════════════════════════════════════════════════════════╣%RESET%
echo   %G%║  %Y%[0]%W%  Назад в главное меню                                                  %G%║%RESET%
echo   %G%╚══════════════════════════════════════════════════════════════════════════════════╝%RESET%
echo.
set /p choice="   %G%» Выберите пункт: %RESET%"

if /i "%choice%"=="1" ( powershell -NoProfile -Command "irm https://christitus.com/win | iex" & goto :menu_soft )
if /i "%choice%"=="2" ( powershell -NoProfile -Command "irm https://get.activated.win | iex" & goto :menu_soft )
if /i "%choice%"=="3" (
    echo   %G%► Установка DirectX и Visual C++ пакетов...%RESET%
    call :anim_install
    powershell -NoProfile -Command "winget install Microsoft.DirectX --silent --accept-source-agreements --accept-package-agreements; winget install Microsoft.VCRedist.2015+.x64 --silent --accept-package-agreements; winget install Microsoft.VCRedist.2015+.x86 --silent --accept-package-agreements; winget install Microsoft.VCRedist.2013.x64 --silent --accept-package-agreements; winget install Microsoft.VCRedist.2012.x64 --silent --accept-package-agreements"
    echo   %G%[ОК] Установлено!%RESET% & pause & goto :menu_soft
)
if /i "%choice%"=="4" ( echo   %G%► Установка 7-Zip...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install IgorPavlov.7-Zip --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] 7-Zip установлен!%RESET% & pause & goto :menu_soft )
if /i "%choice%"=="5" ( echo   %G%► Установка WinRAR...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install RARLab.WinRAR --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] WinRAR установлен!%RESET% & pause & goto :menu_soft )
if /i "%choice%"=="6" ( echo   %G%► Установка VLC...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install VideoLAN.VLC --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] VLC установлен!%RESET% & pause & goto :menu_soft )
if /i "%choice%"=="7" ( echo   %G%► Установка Notepad++...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install Notepad++.Notepad++ --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] Notepad++ установлен!%RESET% & pause & goto :menu_soft )
if /i "%choice%"=="8" ( echo   %G%► Установка Revo Uninstaller...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install RevoUninstaller.RevoUninstaller --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] Revo установлен!%RESET% & pause & goto :menu_soft )
if /i "%choice%"=="9" ( echo   %G%► Установка Everything...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install voidtools.Everything --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] Everything установлен!%RESET% & pause & goto :menu_soft )
if /i "%choice%"=="A" ( echo   %G%► Установка Telegram...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install Telegram.TelegramDesktop --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] Telegram установлен!%RESET% & pause & goto :menu_soft )
if /i "%choice%"=="B" ( echo   %G%► Установка qBittorrent...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install qBittorrent.qBittorrent --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] qBittorrent установлен!%RESET% & pause & goto :menu_soft )
if /i "%choice%"=="C" ( echo   %G%► Установка PotPlayer...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install Daum.PotPlayer --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] PotPlayer установлен!%RESET% & pause & goto :menu_soft )
if /i "%choice%"=="D" ( echo   %G%► Установка ShareX...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install ShareX.ShareX --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] ShareX установлен!%RESET% & pause & goto :menu_soft )
if /i "%choice%"=="E" ( echo   %G%► Установка KeePassXC...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install KeePassXCTeam.KeePassXC --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] KeePassXC установлен!%RESET% & pause & goto :menu_soft )
if "%choice%"=="0" goto :main_menu
goto :menu_soft

:: ══════════════════════════════════════════════════════════════════════════
::  [2] ДИАГНОСТИКА И СТРЕСС-ТЕСТЫ
:: ══════════════════════════════════════════════════════════════════════════
:menu_diag
cls
set "choice="
echo   %Y%╔══════════════════════════════════════════════════════════════════════════════════╗%RESET%
echo   %Y%║         [ DIAG ]  ДИАГНОСТИКА И СТРЕСС-ТЕСТЫ ЖЕЛЕЗА                              ║%RESET%
echo   %Y%╠══════════════════════════════════════════════════════════════════════════════════╣%RESET%
echo   %Y%║  %C%[1]%W%  AIDA64 Engineer — Полная инфо + мониторинг                             %Y%║%RESET%
echo   %Y%║  %C%[2]%W%  MSI Afterburner + RTSS — Разгон и оверлей FPS                        %Y%║%RESET%
echo   %Y%║  %C%[3]%W%  HWiNFO64 — Точнейшие датчики температур                             %Y%║%RESET%
echo   %Y%║  %C%[4]%W%  CPU-Z + GPU-Z — Характеристики чипов                               %Y%║%RESET%
echo   %Y%║  %C%[5]%W%  FurMark — Стресс-тест видеокарты (GPU)                             %Y%║%RESET%
echo   %Y%║  %C%[6]%W%  OCCT — Тест стабильности CPU / RAM / БП                            %Y%║%RESET%
echo   %Y%║  %C%[7]%W%  Prime95 — Экстремальный стресс-тест процессора                      %Y%║%RESET%
echo   %Y%║  %C%[8]%W%  CrystalDiskInfo + Mark — Здоровье и скорость SSD/HDD               %Y%║%RESET%
echo   %Y%║  %C%[9]%W%  UserBenchmark — Онлайн-бенчмарк всей системы                       %Y%║%RESET%
echo   %Y%║  %C%[A]%W%  3DMark — Синтетический бенчмарк GPU (Steam)                        %Y%║%RESET%
echo   %Y%║  %C%[B]%W%  LatencyMon — Диагностика микрофризов и DPC латентности            %Y%║%RESET%
echo   %Y%║  %C%[C]%W%  TreeSize Free — Что жрёт место на диске                             %Y%║%RESET%
echo   %Y%╠══════════════════════════════════════════════════════════════════════════════════╣%RESET%
echo   %Y%║  %W%[0]%W%  Назад в главное меню                                                  %Y%║%RESET%
echo   %Y%╚══════════════════════════════════════════════════════════════════════════════════╝%RESET%
echo.
set /p choice="   %Y%» Выберите пункт: %RESET%"

if /i "%choice%"=="1" ( powershell -NoProfile -Command "Start-BitsTransfer -Source 'https://download.aida64.com/aida64engineer692.zip' -Destination '%temp%\aida64.zip'; Expand-Archive '%temp%\aida64.zip' -DestinationPath '%temp%\aida64' -Force; Start-Process '%temp%\aida64\aida64.exe'" & goto :menu_diag )
if /i "%choice%"=="2" ( echo   %C%► Установка MSI Afterburner + RTSS...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install MSI.Afterburner --silent --accept-package-agreements; winget install Guru3D.RTSS --silent --accept-package-agreements"& echo   %G%[ОК] Установлено!%RESET% & pause & goto :menu_diag )
if /i "%choice%"=="3" ( echo   %C%► Установка HWiNFO64...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install REALiX.HWiNFO --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] HWiNFO64 установлен!%RESET% & pause & goto :menu_diag )
if /i "%choice%"=="4" ( echo   %C%► Установка CPU-Z и GPU-Z...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install CPUID.CPU-Z --silent --accept-package-agreements; winget install TechPowerUp.GPU-Z --silent --accept-package-agreements"& echo   %G%[ОК] Установлено!%RESET% & pause & goto :menu_diag )
if /i "%choice%"=="5" ( echo   %C%► Установка FurMark...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install Geeks3D.FurMark --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] FurMark установлен!%RESET% & pause & goto :menu_diag )
if /i "%choice%"=="6" ( powershell -NoProfile -Command "Start-BitsTransfer -Source 'https://download.ocbase.com/v11/OCCT.exe' -Destination '%temp%\OCCT.exe'; Start-Process '%temp%\OCCT.exe'" & goto :menu_diag )
if /i "%choice%"=="7" ( start "" "https://www.mersenne.org/download/" & goto :menu_diag )
if /i "%choice%"=="8" ( echo   %C%► Установка CrystalDisk утилит...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install CrystalMaru.CrystalDiskInfo --silent --accept-package-agreements; winget install CrystalMaru.CrystalDiskMark --silent --accept-package-agreements"& echo   %G%[ОК] Установлено!%RESET% & pause & goto :menu_diag )
if /i "%choice%"=="9" ( start "" "https://www.userbenchmark.com/" & goto :menu_diag )
if /i "%choice%"=="A" ( start "" "https://store.steampowered.com/app/223850/3DMark/" & goto :menu_diag )
if /i "%choice%"=="B" ( echo   %C%► Установка LatencyMon...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install ResplendenceLatencyMon.LatencyMon --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] LatencyMon установлен!%RESET% & pause & goto :menu_diag )
if /i "%choice%"=="C" ( echo   %C%► Установка TreeSize Free...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install JAMSoftware.TreeSize.Free --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] TreeSize установлен!%RESET% & pause & goto :menu_diag )
if "%choice%"=="0" goto :main_menu
goto :menu_diag

:: ══════════════════════════════════════════════════════════════════════════
::  [3] ТВИКИ WINDOWS И FPS-ОПТИМИЗАЦИЯ
:: ══════════════════════════════════════════════════════════════════════════
:menu_tweaks
cls
set "choice="
echo   %P%╔══════════════════════════════════════════════════════════════════════════════════╗%RESET%
echo   %P%║         [ TWEAK ]  ТВИКИ WINDOWS И FPS-ОПТИМИЗАЦИЯ                              ║%RESET%
echo   %P%╠══════════════════════════════════════════════════════════════════════════════════╣%RESET%
echo   %P%║  %R%[1]%W%  Активировать план "Максимальная производительность"                   %P%║%RESET%
echo   %P%║  %R%[2]%W%  Активировать ультима-план питания (скрытый)                           %P%║%RESET%
echo   %P%║  %R%[3]%W%  Отключить полноэкранную оптимизацию Windows                         %P%║%RESET%
echo   %P%║  %R%[4]%W%  Включить аппаратное ускорение GPU (HAGS)                            %P%║%RESET%
echo   %P%║  %R%[5]%W%  Отключить Xbox Game Bar и DVR                                       %P%║%RESET%
echo   %P%║  %R%[6]%W%  Установить ISLC — устранение микрофризов RAM                        %P%║%RESET%
echo   %P%║  %R%[7]%W%  Установить Process Lasso — умное управление ядрами                  %P%║%RESET%
echo   %P%║  %R%[8]%W%  Установить Lossless Scaling (генератор кадров, Steam)               %P%║%RESET%
echo   %P%║  %R%[9]%W%  Установить WizTree — поиск тяжёлых файлов мгновенно                %P%║%RESET%
echo   %P%║  %R%[A]%W%  Установить Timer Resolution — снизить задержки CPU                  %P%║%RESET%
echo   %P%║  %R%[B]%W%  Отключить Search Indexing (снижает нагрузку на диск)                %P%║%RESET%
echo   %P%║  %R%[C]%W%  Включить режим игры Windows (Game Mode)                             %P%║%RESET%
echo   %P%║  %R%[D]%W%  Отключить визуальные эффекты Windows (макс. быстрота)               %P%║%RESET%
echo   %P%║  %R%[E]%W%  Отключить фоновые приложения и Виджеты (Win 11)                    %P%║%RESET%
echo   %P%╠══════════════════════════════════════════════════════════════════════════════════╣%RESET%
echo   %P%║  %Y%[0]%W%  Назад в главное меню                                                  %P%║%RESET%
echo   %P%╚══════════════════════════════════════════════════════════════════════════════════╝%RESET%
echo.
set /p choice="   %P%» Выберите пункт: %RESET%"

if /i "%choice%"=="1" ( powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c& echo   %G%[ОК] План питания изменён!%RESET% & pause & goto :menu_tweaks )
if /i "%choice%"=="2" ( powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61& echo   %G%[ОК] Ультимативный план добавлен и активирован!%RESET% & pause & goto :menu_tweaks )
if /i "%choice%"=="3" ( reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d 2 /f >nul& reg add "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d 1 /f >nul& echo   %G%[ОК] Полноэкранная оптимизация отключена.%RESET% & pause & goto :menu_tweaks )
if /i "%choice%"=="4" ( reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f >nul& echo   %G%[ОК] HAGS включён! Перезагрузите ПК.%RESET% & pause & goto :menu_tweaks )
if /i "%choice%"=="5" ( reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f >nul& reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul& powershell -NoProfile -Command "Get-AppxPackage Microsoft.XboxGamingOverlay | Remove-AppxPackage" >nul 2>&1& echo   %G%[ОК] Game Bar и DVR отключены!%RESET% & pause & goto :menu_tweaks )
if /i "%choice%"=="6" ( echo   %G%► Установка ISLC...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install Wagnardsoft.ISLC --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] ISLC установлен!%RESET% & pause & goto :menu_tweaks )
if /i "%choice%"=="7" ( echo   %G%► Установка Process Lasso...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install Bitsum.ProcessLasso --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] Process Lasso установлен!%RESET% & pause & goto :menu_tweaks )
if /i "%choice%"=="8" ( start "" "https://store.steampowered.com/app/2381520/Lossless_Scaling/" & goto :menu_tweaks )
if /i "%choice%"=="9" ( echo   %G%► Установка WizTree...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install AntibodySoftware.WizTree --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] WizTree установлен!%RESET% & pause & goto :menu_tweaks )
if /i "%choice%"=="A" ( start "" "https://www.majorgeeks.com/files/details/windows_timer_resolution.html" & goto :menu_tweaks )
if /i "%choice%"=="B" ( sc stop WSearch >nul 2>&1& sc config WSearch start= disabled >nul 2>&1& echo   %G%[ОК] Индексирование отключено!%RESET% & pause & goto :menu_tweaks )
if /i "%choice%"=="C" ( reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d 1 /f >nul& echo   %G%[ОК] Game Mode включён!%RESET% & pause & goto :menu_tweaks )
if /i "%choice%"=="D" ( reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 2 /f >nul& echo   %G%[ОК] Эффекты отключены! Перезайдите в сессию.%RESET% & pause & goto :menu_tweaks )
if /i "%choice%"=="E" ( reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f >nul& reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v "AllowNewsAndInterests" /t REG_DWORD /d 0 /f >nul& echo   %G%[ОК] Фоновые приложения и виджеты отключены!%RESET% & pause & goto :menu_tweaks )
if "%choice%"=="0" goto :main_menu
goto :menu_tweaks

:: ══════════════════════════════════════════════════════════════════════════
::  [4] СЕТЬ, DNS, VPN И БЕЗОПАСНОСТЬ
:: ══════════════════════════════════════════════════════════════════════════
:menu_net
cls
set "choice="
echo   %B%╔══════════════════════════════════════════════════════════════════════════════════╗%RESET%
echo   %B%║         [ NET ]  СЕТЬ, DNS, VPN И БЕЗОПАСНОСТЬ                                  ║%RESET%
echo   %B%╠══════════════════════════════════════════════════════════════════════════════════╣%RESET%
echo   %B%║  %C%[1]%W%  Оптимизировать пинг (сброс DNS + сетевого стека)                       %B%║%RESET%
echo   %B%║  %C%[2]%W%  Установить DNS на Cloudflare (1.1.1.1) — быстрый DNS                 %B%║%RESET%
echo   %B%║  %C%[3]%W%  Установить DNS на Google (8.8.8.8)                                   %B%║%RESET%
echo   %B%║  %C%[4]%W%  Вернуть DNS автоматически (DHCP)                                      %B%║%RESET%
echo   %B%║  %C%[5]%W%  Показать текущий пинг (ping до серверов)                             %B%║%RESET%
echo   %B%║  %C%[6]%W%  Установить Malwarebytes (защита от малвари)                           %B%║%RESET%
echo   %B%║  %C%[7]%W%  Установить Simplewall (лёгкий файрвол)                                %B%║%RESET%
echo   %B%║  %C%[8]%W%  Установить Wireshark (анализ сетевого трафика)                        %B%║%RESET%
echo   %B%║  %C%[9]%W%  Показать открытые порты (netstat)                                     %B%║%RESET%
echo   %B%║  %C%[A]%W%  Отключить телеметрию Windows (hosts + сервисы)                        %B%║%RESET%
echo   %B%║  %C%[B]%W%  GoodbyeDPI — Обход блокировок без VPN (для РФ)                       %B%║%RESET%
echo   %B%║  %C%[C]%W%  AmneziaVPN — Бесплатный Open Source VPN                              %B%║%RESET%
echo   %B%╠══════════════════════════════════════════════════════════════════════════════════╣%RESET%
echo   %B%║  %Y%[0]%W%  Назад в главное меню                                                  %B%║%RESET%
echo   %B%╚══════════════════════════════════════════════════════════════════════════════════╝%RESET%
echo.
set /p choice="   %B%» Выберите пункт: %RESET%"

if /i "%choice%"=="1" ( ipconfig /flushdns >nul& ipconfig /release >nul& ipconfig /renew >nul& netsh int ip reset >nul& netsh winsock reset >nul& netsh int tcp set global autotuninglevel=normal >nul& echo   %G%[ОК] Сеть сброшена! Перезагрузите ПК.%RESET% & pause & goto :menu_net )
if /i "%choice%"=="2" ( powershell -NoProfile -Command "Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | ForEach-Object { Set-DnsClientServerAddress -InterfaceIndex $_.ifIndex -ServerAddresses ('1.1.1.1','1.0.0.1') }"& echo   %G%[ОК] DNS Cloudflare установлен!%RESET% & pause & goto :menu_net )
if /i "%choice%"=="3" ( powershell -NoProfile -Command "Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | ForEach-Object { Set-DnsClientServerAddress -InterfaceIndex $_.ifIndex -ServerAddresses ('8.8.8.8','8.8.4.4') }"& echo   %G%[ОК] DNS Google установлен!%RESET% & pause & goto :menu_net )
if /i "%choice%"=="4" ( powershell -NoProfile -Command "Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | ForEach-Object { Set-DnsClientServerAddress -InterfaceIndex $_.ifIndex -ResetServerAddresses }"& echo   %G%[ОК] DNS сброшен на DHCP!%RESET% & pause & goto :menu_net )
if /i "%choice%"=="5" ( echo. & echo   %C%Cloudflare 1.1.1.1:%RESET% & ping -n 4 1.1.1.1 & echo. & echo   %C%Google 8.8.8.8:%RESET% & ping -n 4 8.8.8.8 & echo. & pause & goto :menu_net )
if /i "%choice%"=="6" ( echo   %G%► Установка Malwarebytes...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install Malwarebytes.Malwarebytes --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] Malwarebytes установлен!%RESET% & pause & goto :menu_net )
if /i "%choice%"=="7" ( echo   %G%► Установка Simplewall...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install Henry++.simplewall --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] Simplewall установлен!%RESET% & pause & goto :menu_net )
if /i "%choice%"=="8" ( echo   %G%► Установка Wireshark...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install WiresharkFoundation.Wireshark --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] Wireshark установлен!%RESET% & pause & goto :menu_net )
if /i "%choice%"=="9" ( echo   %G%► Активные сетевые соединения:%RESET% & netstat -ano | findstr LISTENING & echo. & pause & goto :menu_net )
if /i "%choice%"=="A" ( sc stop DiagTrack >nul 2>&1 & sc config DiagTrack start= disabled >nul 2>&1 & sc stop dmwappushservice >nul 2>&1 & sc config dmwappushservice start= disabled >nul 2>&1 & reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul& echo   %G%[ОК] Телеметрия отключена!%RESET% & pause & goto :menu_net )
if /i "%choice%"=="B" ( echo   %G%► Скачивание GoodbyeDPI...%RESET%& powershell -NoProfile -Command "Start-BitsTransfer -Source 'https://github.com/ValdikSS/GoodbyeDPI/releases/download/0.2.3rc3/goodbyedpi-0.2.3rc3.zip' -Destination '%temp%\gdpi.zip'; Expand-Archive '%temp%\gdpi.zip' -DestinationPath '%temp%\gdpi' -Force; Start-Process '%temp%\gdpi\1_russia_blacklist.cmd'"& echo   %G%[ОК] GoodbyeDPI запущен!%RESET% & pause & goto :menu_net )
if /i "%choice%"=="C" ( echo   %G%► Установка AmneziaVPN...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install AmneziaVPN.AmneziaVPN --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] AmneziaVPN установлен!%RESET% & pause & goto :menu_net )
if "%choice%"=="0" goto :main_menu
goto :menu_net

:: ══════════════════════════════════════════════════════════════════════════
::  [5] ГЕЙМПАДЫ И ПЕРИФЕРИЯ
:: ══════════════════════════════════════════════════════════════════════════
:menu_periph
cls
set "choice="
echo   %C%╔══════════════════════════════════════════════════════════════════════════════════╗%RESET%
echo   %C%║         [ PAD ]  ГЕЙМПАДЫ И ПЕРИФЕРИЯ                                            ║%RESET%
echo   %C%╠══════════════════════════════════════════════════════════════════════════════════╣%RESET%
echo   %C%║  %P%[1]%W%  DS4Windows — DualShock 4 / DualSense на ПК                             %C%║%RESET%
echo   %C%║  %P%[2]%W%  AntiMicroX — Маппинг любого геймпада                                 %C%║%RESET%
echo   %C%║  %P%[3]%W%  OpenRGB — Управление подсветкой любого железа                         %C%║%RESET%
echo   %C%║  %P%[4]%W%  x360ce — Эмулятор Xbox 360 контроллера для игр                       %C%║%RESET%
echo   %C%║  %P%[5]%W%  JoyToKey — Геймпад в клавиатурные горячие клавиши                    %C%║%RESET%
echo   %C%║  %P%[6]%W%  ViGEmBus — Виртуальный геймпад (нужен DS4Windows)                    %C%║%RESET%
echo   %C%║  %P%[7]%W%  Mouse Sensitivity — Онлайн-конвертер чувствительности                %C%║%RESET%
echo   %C%║  %P%[8]%W%  Aurory Mouse Tool (mouserate.exe) — Тест Polling Rate                 %C%║%RESET%
echo   %C%╠══════════════════════════════════════════════════════════════════════════════════╣%RESET%
echo   %C%║  %Y%[0]%W%  Назад в главное меню                                                  %C%║%RESET%
echo   %C%╚══════════════════════════════════════════════════════════════════════════════════╝%RESET%
echo.
set /p choice="   %C%» Выберите пункт: %RESET%"

if /i "%choice%"=="1" ( echo   %G%► Установка DS4Windows...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install Ryochan7.DS4Windows --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] DS4Windows установлен!%RESET% & pause & goto :menu_periph )
if /i "%choice%"=="2" ( echo   %G%► Установка AntiMicroX...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install AntiMicroX.AntiMicroX --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] AntiMicroX установлен!%RESET% & pause & goto :menu_periph )
if /i "%choice%"=="3" ( echo   %G%► Установка OpenRGB...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install OpenRGB.OpenRGB --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] OpenRGB установлен!%RESET% & pause & goto :menu_periph )
if /i "%choice%"=="4" ( start "" "https://www.x360ce.com/" & goto :menu_periph )
if /i "%choice%"=="5" ( start "" "https://joytokey.net/en/" & goto :menu_periph )
if /i "%choice%"=="6" ( echo   %G%► Установка ViGEmBus...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install nefarius.vigembus --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] ViGEmBus установлен!%RESET% & pause & goto :menu_periph )
if /i "%choice%"=="7" ( start "" "https://www.mouse-sensitivity.com/" & goto :menu_periph )
if /i "%choice%"=="8" ( start "" "https://www.hiok.com/mouserate/" & goto :menu_periph )
if "%choice%"=="0" goto :main_menu
goto :menu_periph

:: ══════════════════════════════════════════════════════════════════════════
::  [6] АУДИО, ЗАХВАТ И СТРИМИНГ
:: ══════════════════════════════════════════════════════════════════════════
:menu_audio
cls
set "choice="
echo   %R%╔══════════════════════════════════════════════════════════════════════════════════╗%RESET%
echo   %R%║         [ AUDIO ]  АУДИО, ЗАХВАТ ЭКРАНА И СТРИМИНГ                              ║%RESET%
echo   %R%╠══════════════════════════════════════════════════════════════════════════════════╣%RESET%
echo   %R%║  %Y%[1]%W%  OBS Studio — Запись и стриминг (лучший вариант)                      %R%║%RESET%
echo   %R%║  %Y%[2]%W%  Voicemeeter Banana — Виртуальный аудио-микшер                        %R%║%RESET%
echo   %R%║  %Y%[3]%W%  EarTrumpet — Продвинутый контроль громкости Windows                 %R%║%RESET%
echo   %R%║  %Y%[4]%W%  Equalizer APO + Peace GUI — Эквалайзер системного звука             %R%║%RESET%
echo   %R%║  %Y%[5]%W%  Audacity — Запись и редактирование звука                             %R%║%RESET%
echo   %R%║  %Y%[6]%W%  Lossless Audio Checker (LAC) — Проверка качества звука             %R%║%RESET%
echo   %R%║  %Y%[7]%W%  NVIDIA Broadcast — AI-шумодав от Nvidia                              %R%║%RESET%
echo   %R%║  %Y%[8]%W%  Streamlabs — OBS с готовыми оверлеями для новичков                 %R%║%RESET%
echo   %R%║  %Y%[9]%W%  VB-Audio Virtual Cable — Виртуальный аудиокабель                     %R%║%RESET%
echo   %R%╠══════════════════════════════════════════════════════════════════════════════════╣%RESET%
echo   %R%║  %W%[0]%W%  Назад в главное меню                                                  %R%║%RESET%
echo   %R%╚══════════════════════════════════════════════════════════════════════════════════╝%RESET%
echo.
set /p choice="   %R%» Выберите пункт: %RESET%"

if /i "%choice%"=="1" ( echo   %G%► Установка OBS Studio...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install OBSProject.OBSStudio --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] OBS Studio установлен!%RESET% & pause & goto :menu_audio )
if /i "%choice%"=="2" ( start "" "https://vb-audio.com/Voicemeeter/banana.htm" & goto :menu_audio )
if /i "%choice%"=="3" ( echo   %G%► Установка EarTrumpet...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install File-New-Project.EarTrumpet --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] EarTrumpet установлен!%RESET% & pause & goto :menu_audio )
if /i "%choice%"=="4" ( start "" "https://equalizerapo.com/" & goto :menu_audio )
if /i "%choice%"=="5" ( echo   %G%► Установка Audacity...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install Audacity.Audacity --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] Audacity установлен!%RESET% & pause & goto :menu_audio )
if /i "%choice%"=="6" ( start "" "https://losslessaudiochecker.com/" & goto :menu_audio )
if /i "%choice%"=="7" ( start "" "https://www.nvidia.com/en-us/geforce/broadcasting/broadcast-app/" & goto :menu_audio )
if /i "%choice%"=="8" ( echo   %G%► Установка Streamlabs...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install Streamlabs.Streamlabs --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] Streamlabs установлен!%RESET% & pause & goto :menu_audio )
if /i "%choice%"=="9" ( start "" "https://vb-audio.com/Cable/" & goto :menu_audio )
if "%choice%"=="0" goto :main_menu
goto :menu_audio

:: ══════════════════════════════════════════════════════════════════════════
::  [7] РАЗРАБОТКА И ГЕЙМИНГ-ИНСТРУМЕНТЫ
:: ══════════════════════════════════════════════════════════════════════════
:menu_dev
cls
set "choice="
echo   %G%╔══════════════════════════════════════════════════════════════════════════════════╗%RESET%
echo   %G%║         [ DEV ]  РАЗРАБОТКА И ГЕЙМИНГ-ИНСТРУМЕНТЫ                               ║%RESET%
echo   %G%╠══════════════════════════════════════════════════════════════════════════════════╣%RESET%
echo   %G%║  %C%[1]%W%  Visual Studio Code — Лучший редактор кода                             %G%║%RESET%
echo   %G%║  %C%[2]%W%  Git + Python 3 — Основа любой разработки                            %G%║%RESET%
echo   %G%║  %C%[3]%W%  Node.js LTS — Среда выполнения JavaScript                           %G%║%RESET%
echo   %G%║  %C%[4]%W%  JDK 21 (Java) — Для Minecraft и Java-проектов                       %G%║%RESET%
echo   %G%║  %C%[5]%W%  Playnite — Все игровые лаунчеры в одном месте                       %G%║%RESET%
echo   %G%║  %C%[6]%W%  Heroic Games Launcher — Epic Games + GOG без магазина               %G%║%RESET%
echo   %G%║  %C%[7]%W%  Cheat Engine — Для одиночных игр и обучения                         %G%║%RESET%
echo   %G%║  %C%[8]%W%  Steam — Главная игровая платформа                                   %G%║%RESET%
echo   %G%║  %C%[9]%W%  Discord — Голосовая связь для геймеров                              %G%║%RESET%
echo   %G%║  %C%[A]%W%  Postman — API тестирование для разработчиков                        %G%║%RESET%
echo   %G%║  %C%[B]%W%  Docker Desktop — Контейнеризация приложений                         %G%║%RESET%
echo   %G%║  %C%[C]%W%  Windows Terminal — Современный терминал от Microsoft                %G%║%RESET%
echo   %G%╠══════════════════════════════════════════════════════════════════════════════════╣%RESET%
echo   %G%║  %Y%[0]%W%  Назад в главное меню                                                  %G%║%RESET%
echo   %G%╚══════════════════════════════════════════════════════════════════════════════════╝%RESET%
echo.
set /p choice="   %G%» Выберите пункт: %RESET%"

if /i "%choice%"=="1" ( echo   %G%► Установка VS Code...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install Microsoft.VisualStudioCode --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] VS Code установлен!%RESET% & pause & goto :menu_dev )
if /i "%choice%"=="2" ( echo   %G%► Установка Git + Python 3...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install Git.Git --silent --accept-package-agreements; winget install Python.Python.3.12 --silent --accept-package-agreements"& echo   %G%[ОК] Git и Python установлены!%RESET% & pause & goto :menu_dev )
if /i "%choice%"=="3" ( echo   %G%► Установка Node.js LTS...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install OpenJS.NodeJS.LTS --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] Node.js LTS установлен!%RESET% & pause & goto :menu_dev )
if /i "%choice%"=="4" ( echo   %G%► Установка JDK 21...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install Microsoft.OpenJDK.21 --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] JDK 21 установлен!%RESET% & pause & goto :menu_dev )
if /i "%choice%"=="5" ( echo   %G%► Установка Playnite...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install Playnite.Playnite --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] Playnite установлен!%RESET% & pause & goto :menu_dev )
if /i "%choice%"=="6" ( echo   %G%► Установка Heroic Games Launcher...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install HeroicGamesLauncher.HeroicGamesLauncher --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] Heroic установлен!%RESET% & pause & goto :menu_dev )
if /i "%choice%"=="7" ( echo   %G%► Установка Cheat Engine...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install CheatEngine.CheatEngine --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] Cheat Engine установлен!%RESET% & pause & goto :menu_dev )
if /i "%choice%"=="8" ( echo   %G%► Установка Steam...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install Valve.Steam --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] Steam установлен!%RESET% & pause & goto :menu_dev )
if /i "%choice%"=="9" ( echo   %G%► Установка Discord...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install Discord.Discord --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] Discord установлен!%RESET% & pause & goto :menu_dev )
if /i "%choice%"=="A" ( echo   %G%► Установка Postman...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install Postman.Postman --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] Postman установлен!%RESET% & pause & goto :menu_dev )
if /i "%choice%"=="B" ( echo   %G%► Установка Docker Desktop...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install Docker.DockerDesktop --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] Docker Desktop установлен!%RESET% & pause & goto :menu_dev )
if /i "%choice%"=="C" ( echo   %G%► Установка Windows Terminal...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install Microsoft.WindowsTerminal --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] Windows Terminal установлен!%RESET% & pause & goto :menu_dev )
if "%choice%"=="0" goto :main_menu
goto :menu_dev

:: ══════════════════════════════════════════════════════════════════════════
::  [8] ОЧИСТКА И ОБСЛУЖИВАНИЕ СИСТЕМЫ
:: ══════════════════════════════════════════════════════════════════════════
:menu_clean
cls
set "choice="
echo   %W%╔══════════════════════════════════════════════════════════════════════════════════╗%RESET%
echo   %W%║         [ CLEAN ]  ОЧИСТКА И ОБСЛУЖИВАНИЕ СИСТЕМЫ                               ║%RESET%
echo   %W%╠══════════════════════════════════════════════════════════════════════════════════╣%RESET%
echo   %W%║  %Y%[1]%W%  Очистить Temp, Prefetch, логи и кэш браузеров                      %W%║%RESET%
echo   %W%║  %Y%[2]%W%  Запустить sfc /scannow (проверка системных файлов)                  %W%║%RESET%
echo   %W%║  %Y%[3]%W%  Запустить DISM — восстановление образа Windows                      %W%║%RESET%
echo   %W%║  %Y%[4]%W%  Дефрагментация / Оптимизация диска C:                              %W%║%RESET%
echo   %W%║  %Y%[5]%W%  Проверить ошибки диска C: (chkdsk /f /r)                          %W%║%RESET%
echo   %W%║  %Y%[6]%W%  Обновить все программы через winget                                %W%║%RESET%
echo   %W%║  %Y%[7]%W%  Отключить ненужные программы из автозагрузки                       %W%║%RESET%
echo   %W%║  %Y%[8]%W%  Очистить кэш Windows Update                                        %W%║%RESET%
echo   %W%║  %Y%[9]%W%  Установить BleachBit (глубокая очистка системы)                    %W%║%RESET%
echo   %W%╠══════════════════════════════════════════════════════════════════════════════════╣%RESET%
echo   %W%║  %Y%[0]%W%  Назад в главное меню                                                  %W%║%RESET%
echo   %W%╚══════════════════════════════════════════════════════════════════════════════════╝%RESET%
echo.
set /p choice="   %W%» Выберите пункт: %RESET%"

if /i "%choice%"=="1" (
    echo   %G%► Очистка мусора...%RESET%
    del /f /s /q "%systemdrive%\*.tmp" >nul 2>&1
    del /f /s /q "%windir%\Prefetch\*.*" >nul 2>&1
    del /f /s /q "%windir%\Temp\*.*" >nul 2>&1
    powershell -NoProfile -Command "Remove-Item -Path $env:TEMP\* -Recurse -Force -ErrorAction SilentlyContinue; Remove-Item -Path $env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\* -Recurse -Force -ErrorAction SilentlyContinue; Clear-RecycleBin -Force -ErrorAction SilentlyContinue"
    echo   %G%[ОК] Система очищена! Корзина опустошена.%RESET% & pause & goto :menu_clean
)
if /i "%choice%"=="2" ( echo   %Y%► Запуск sfc /scannow...%RESET% & sfc /scannow & echo   %G%[ОК] Проверка завершена!%RESET% & pause & goto :menu_clean )
if /i "%choice%"=="3" ( echo   %Y%► Запуск DISM...%RESET% & DISM /Online /Cleanup-Image /RestoreHealth & echo   %G%[ОК] DISM завершён!%RESET% & pause & goto :menu_clean )
if /i "%choice%"=="4" ( echo   %G%► Оптимизация диска C:...%RESET% & defrag C: /U /V & echo   %G%[ОК] Оптимизация завершена!%RESET% & pause & goto :menu_clean )
if /i "%choice%"=="5" ( echo Y | chkdsk C: /f /r >nul 2>&1 & echo   %Y%[!] Проверка диска запланирована — перезагрузите ПК.%RESET% & pause & goto :menu_clean )
if /i "%choice%"=="6" ( echo   %G%► Обновление программ...%RESET% & winget upgrade --all --accept-source-agreements --accept-package-agreements & echo   %G%[ОК] Все программы обновлены!%RESET% & pause & goto :menu_clean )
if /i "%choice%"=="7" ( start taskmgr & goto :menu_clean )
if /i "%choice%"=="8" (
    echo   %G%► Очистка кэша Windows Update...%RESET%
    net stop wuauserv >nul 2>&1 & net stop bits >nul 2>&1
    powershell -NoProfile -Command "Remove-Item 'C:\Windows\SoftwareDistribution\Download\*' -Recurse -Force -ErrorAction SilentlyContinue"
    net start wuauserv >nul 2>&1 & net start bits >nul 2>&1
    echo   %G%[ОК] Кэш Windows Update очищен!%RESET% & pause & goto :menu_clean
)
if /i "%choice%"=="9" ( echo   %G%► Установка BleachBit...%RESET%& call :anim_install& powershell -NoProfile -Command "winget install BleachBit.BleachBit --silent --accept-source-agreements --accept-package-agreements"& echo   %G%[ОК] BleachBit установлен!%RESET% & pause & goto :menu_clean )
if "%choice%"=="0" goto :main_menu
goto :menu_clean

:: ══════════════════════════════════════════════════════════════════════════
::  ВЫХОД
:: ══════════════════════════════════════════════════════════════════════════
:exit_toolkit
cls
echo.
echo   %C%╔══════════════════════════════════════════════════════════════════════════════════╗%RESET%
echo   %C%║                                                                                  ║%RESET%
echo   %C%║   %G%  Спасибо за использование Gaming System Toolkit!  %C%                          ║%RESET%
echo   %C%║   %W%  Удачи, высоких FPS и низкого пинга!              %C%                        ║%RESET%
echo   %C%║   %DIM%  github.com/Topzi-afk (Open Source Project)%C%                             ║%RESET%
echo   %C%║                                                                                  ║%RESET%
echo   %C%╚══════════════════════════════════════════════════════════════════════════════════╝%RESET%
echo.
powershell -NoProfile -Command "[console]::beep(523,100); [console]::beep(440,100); [console]::beep(392,300)"
call :delay 1200
exit /b
