# Windows环境安装指南

## 文件说明

本目录包含Windows平台下的安装和配置脚本：

## 文件说明

本目录包含Windows平台下的安装和配置脚本：

### 主要脚本

1. **`install.bat`** - 一键安装配置脚本
   - 检查Python环境和版本
   - 配置pip镜像源（清华大学）
   - 安装项目依赖包
   - 安装Playwright浏览器驱动
   - 用户选择GUI/CLI启动模式
   - 在项目根目录创建"一键启动.bat"
   - 可选配置开机自启动

2. **`uninstall.bat`** - 卸载清理脚本
   - 清理开机自启动配置
   - 删除临时日志文件
   - 可选清理pip配置和程序文件

## 使用方法

## 使用方法

### 推荐方式：一键安装

1. 直接运行 `install.bat`
2. 按提示选择启动模式（GUI或CLI）
3. 选择是否配置开机自启动
4. 安装完成后使用项目根目录下的"一键启动.bat"

### 手动配置

如果自动脚本有问题，可以手动执行以下步骤：

```batch
# 1. 配置pip镜像源
python -m pip install -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple --trusted-host mirrors.tuna.tsinghua.edu.cn --upgrade pip

# 2. 安装依赖
python -m pip install -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple --trusted-host mirrors.tuna.tsinghua.edu.cn -r requirements.txt

# 3. 安装浏览器驱动
python -m playwright install chromium

# 4. 手动配置开机启动
# 按 Win + R，输入 shell:startup
# 在打开的文件夹中创建启动脚本
```

## 系统要求

- **操作系统**：Windows 10/11
- **Python版本**：3.10 或更高版本
- **网络环境**：需要联网下载依赖包
- **权限要求**：管理员权限（用于配置开机启动）

## 镜像源配置

脚本使用清华大学PyPI镜像源以提高下载速度：
- 主镜像：`https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple`
- 备用镜像：可在脚本中修改为其他国内镜像源

## 开机自启动配置

### 自动配置
脚本会自动将启动脚本添加到Windows启动文件夹：
- 位置：`%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\`
- 文件：`校园网认证.bat` 或快捷方式

### 手动配置
如果自动配置失败，可以手动操作：
1. 按 `Win + R` 打开运行对话框
2. 输入 `shell:startup` 并回车
3. 在打开的文件夹中创建启动脚本

### 卸载自启动
运行本目录下的 `uninstall.bat` 即可清理所有配置。

## 故障排除

### 1. Python未找到
**问题**：提示"未检测到Python环境"
**解决**：
- 从 [Python官网](https://www.python.org/downloads/) 下载安装Python 3.10+
- 安装时勾选"Add Python to PATH"
- 重启命令提示符

### 2. 依赖安装失败
**问题**：pip安装报错
**解决**：
- 检查网络连接
- 尝试切换镜像源
- 升级pip：`python -m pip install --upgrade pip`

### 3. 浏览器驱动安装失败
**问题**：Playwright安装报错
**解决**：
- 手动安装：`python -m playwright install chromium`
- 检查磁盘空间是否充足
- 尝试清除代理设置

### 4. 开机自启动不生效
**问题**：重启后程序未自动运行
**解决**：
- 检查启动文件夹中是否有相关文件
- 手动运行 `startup.bat` 测试
- 查看系统任务管理器的启动项

## 日志和调试

- 启动日志：`%TEMP%\campus_auth_startup.log`
- 错误日志：`%TEMP%\campus_auth_error.log`
- 程序日志：项目根目录的 `logs` 文件夹

## 注意事项

1. **首次运行**：程序首次启动会显示用户协议，需要同意后才能正常使用
2. **防火墙**：如果Windows防火墙拦截，请选择允许访问
3. **杀毒软件**：部分杀毒软件可能误报，请添加到白名单
4. **权限问题**：如遇权限错误，请以管理员身份运行相关脚本

## 更新和维护

- 更新依赖：重新运行安装脚本即可
- 修改配置：编辑项目根目录的 `.env` 文件
- 卸载程序：删除项目文件夹和启动项即可

---

如有问题，请查看项目GitHub页面：[JCU_auto_network](https://github.com/Misyra/JCU_auto_network)