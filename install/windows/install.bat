@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

:: ==============================================================================
:: 校园网自动认证工具 - 快速安装脚本
:: 功能：一键安装依赖并配置自启动
:: ==============================================================================

echo.
echo ==========================================
echo     校园网自动认证工具 - 快速安装
echo ==========================================
echo.

:: 设置路径
set "PROJECT_ROOT=%~dp0..\.."
cd /d "%PROJECT_ROOT%"

:: 检查Python
echo [1/4] 检查Python...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未找到Python，请先安装Python 3.10+
    pause
    exit /b 1
)
echo [成功] Python环境正常

:: 配置镜像源并安装依赖
echo.
echo [2/4] 安装依赖包（使用清华镜像源）...
python -m pip install -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple --trusted-host mirrors.tuna.tsinghua.edu.cn -r requirements.txt
if %errorlevel% neq 0 (
    echo [错误] 依赖安装失败
    pause
    exit /b 1
)

:: 安装浏览器驱动
echo.
echo [3/4] 安装浏览器驱动...
python -m playwright install chromium --with-deps
if %errorlevel% neq 0 (
    echo [警告] 浏览器驱动安装失败，请稍后手动安装
)

:: 用户选择启动模式
echo.
echo [4/5] 选择启动模式...
echo.
echo 请选择您希望使用的启动模式：
echo 1. GUI模式 - 图形界面（推荐）
echo 2. CLI模式 - 命令行界面
echo.
set /p "MODE_CHOICE=请输入选择 (1/2): "

if "%MODE_CHOICE%"=="1" (
    set "START_COMMAND=python app.py"
    set "MODE_NAME=GUI模式"
) else if "%MODE_CHOICE%"=="2" (
    set "START_COMMAND=python app_cli.py"
    set "MODE_NAME=CLI模式"
) else (
    echo [信息] 未选择或选择无效，默认使用GUI模式
    set "START_COMMAND=python app.py"
    set "MODE_NAME=GUI模式"
)

echo [信息] 已选择：!MODE_NAME!

:: 创建一键启动脚本
echo.
echo [5/5] 创建一键启动脚本...

set "STARTUP_BAT=%PROJECT_ROOT%\一键启动.bat"
echo @echo off > "%STARTUP_BAT%"
echo chcp 65001 ^>nul >> "%STARTUP_BAT%"
echo :: 校园网自动认证工具 - 一键启动脚本 >> "%STARTUP_BAT%"
echo :: 启动模式：!MODE_NAME! >> "%STARTUP_BAT%"
echo. >> "%STARTUP_BAT%"
echo cd /d "%%~dp0" >> "%STARTUP_BAT%"
echo !START_COMMAND! >> "%STARTUP_BAT%"
echo pause >> "%STARTUP_BAT%"

:: 配置开机自启动
echo.
set /p "AUTO_START=是否配置开机自启动？(y/N): "
if /i "%AUTO_START%"=="y" (
    echo.
    echo 开机自启动模式选择：
    echo 1. GUI模式 - 开机后显示图形界面
    echo 2. CLI模式 - 开机后后台运行（推荐）
    echo.
    set /p "AUTO_MODE=请选择开机启动模式 (1/2): "
    
    if "!AUTO_MODE!"=="1" (
        set "AUTO_COMMAND=python app.py"
        set "AUTO_MODE_NAME=GUI模式"
    ) else if "!AUTO_MODE!"=="2" (
        set "AUTO_COMMAND=python app_cli.py"
        set "AUTO_MODE_NAME=CLI模式"
    ) else (
        echo [信息] 未选择或选择无效，默认使用CLI模式（后台运行）
        set "AUTO_COMMAND=python app_cli.py"
        set "AUTO_MODE_NAME=CLI模式"
    )
    
    echo [信息] 开机自启动将使用：!AUTO_MODE_NAME!
    
    set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
    
    echo @echo off > "%TEMP%\campus_startup.bat"
    echo chcp 65001 ^>nul >> "%TEMP%\campus_startup.bat"
    echo :: 校园网自动认证工具 - 开机自启动脚本 >> "%TEMP%\campus_startup.bat"
    echo :: 启动模式：!AUTO_MODE_NAME! >> "%TEMP%\campus_startup.bat"
    echo timeout /t 10 /nobreak ^>nul >> "%TEMP%\campus_startup.bat"
    echo cd /d "%PROJECT_ROOT%" >> "%TEMP%\campus_startup.bat"
    
    if "!AUTO_MODE!"=="1" (
        echo start /min !AUTO_COMMAND! >> "%TEMP%\campus_startup.bat"
    ) else (
        echo start /b !AUTO_COMMAND! >> "%TEMP%\campus_startup.bat"
    )
    
    copy "%TEMP%\campus_startup.bat" "!STARTUP_FOLDER!\校园网认证.bat" >nul 2>&1
    del "%TEMP%\campus_startup.bat" >nul 2>&1
    
    if !errorlevel! equ 0 (
        echo [成功] 开机自启动配置完成 - !AUTO_MODE_NAME!
    ) else (
        echo [警告] 开机自启动配置失败，请手动配置
    )
) else (
    echo [信息] 跳过开机自启动配置
)

echo.
echo ==========================================
echo              安装完成！
echo ==========================================
echo.
echo 使用方法：
echo 1. 双击运行: 一键启动.bat
echo 2. 手动启动模式: !MODE_NAME!
if /i "%AUTO_START%"=="y" (
    echo 3. 开机自启动: 已配置 - !AUTO_MODE_NAME!
    echo 4. 如需卸载开机启动: 删除 %STARTUP_FOLDER%\校园网认证.bat
) else (
    echo 3. 开机自启动: 未配置
)
echo.
pause