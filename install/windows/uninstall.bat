@echo off
chcp 65001 >nul

:: ==============================================================================
:: 校园网自动认证工具 - 卸载脚本
:: 功能：清理开机自启动和相关配置
:: ==============================================================================

echo.
echo ==========================================
echo      校园网认证工具 - 卸载脚本
echo ==========================================
echo.

set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "PROJECT_ROOT=%~dp0..\.."

echo 正在清理开机自启动配置...

:: 删除启动文件夹中的文件
if exist "%STARTUP_FOLDER%\校园网认证.bat" (
    del "%STARTUP_FOLDER%\校园网认证.bat"
    echo [成功] 已删除启动脚本：校园网认证.bat
)

if exist "%STARTUP_FOLDER%\校园网自动认证.lnk" (
    del "%STARTUP_FOLDER%\校园网自动认证.lnk"
    echo [成功] 已删除启动快捷方式：校园网自动认证.lnk
)

:: 清理临时日志文件
if exist "%TEMP%\campus_auth_startup.log" (
    del "%TEMP%\campus_auth_startup.log"
    echo [成功] 已删除启动日志文件
)

if exist "%TEMP%\campus_auth_error.log" (
    del "%TEMP%\campus_auth_error.log"
    echo [成功] 已删除错误日志文件
)

:: 询问是否删除pip配置
echo.
set /p "REMOVE_PIP=是否删除pip镜像源配置？(y/N): "
if /i "%REMOVE_PIP%"=="y" (
    if exist "%USERPROFILE%\pip\pip.conf" (
        del "%USERPROFILE%\pip\pip.conf"
        echo [成功] 已删除pip配置文件
    )
)

:: 询问是否删除程序文件
echo.
echo 注意：以下操作将删除整个程序目录！
set /p "REMOVE_APP=是否删除程序文件？(y/N): "
if /i "%REMOVE_APP%"=="y" (
    echo 删除程序文件需要手动操作
    echo 程序目录：%PROJECT_ROOT%
    echo.
    echo 您可以手动删除整个目录来完全卸载程序
) else (
    echo [信息] 保留程序文件，仅清理了自启动配置
)

echo.
echo ==========================================
echo             卸载完成！
echo ==========================================
echo.
echo 已清理项目：
echo - 开机自启动配置
echo - 临时日志文件
if /i "%REMOVE_PIP%"=="y" echo - pip镜像源配置
echo.
echo 如需完全卸载，请手动删除项目文件夹
echo.
pause