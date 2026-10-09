# 更新日志

## UI 1.1.2 / Voice 1.1.1 · 2026-10-09

- Visual：适配官方 `main.conversation` slot，标记 active phase 为透明背景面板，修复对话时渐变网格被不透明底色挡住。
- Visual：恢复原生输入栏层级（z-index 7），YAML 等代码块 sticky 工具栏不再覆盖编辑器，保留工具栏和复制功能。
- Visual：识别官方 Settings portal；设置弹窗打开时输入栏降到遮罩后，关闭后恢复正常。
- Visual：原地协调输入栏布局标记，修复 hover 提示重排打断音量原生滑块快速拖动；保留仍在使用的节点与标记，Voice 发行包不改。
- 保留 1.1.1 右侧音量/外观控件、Git graph 分行、分支菜单与滚动保护。
- 修复包包含 UI 1.1.2 与字节不变的 Voice 1.1.1；Orb 1.1.0、默认 agent 和语音模型不变。
- 安装器仅升级目标插件、校验 SHA256、要求目标已关闭，不启动或停止用户程序；旧 1.1.1 Release 与模型草稿不覆盖。
- 隔离回归覆盖源码、已安装 tgz、官方桌面客户端模块、纯 UI、重新加载应用及 PowerShell 安装安全边界；不等于真实 Electron 或真实 TTS/GPU 验收。

## UI / Voice 1.1.1 · 2026-10-09

- Visual：Git graph 分支、工作区和 agent 模式分行显示，不再重叠。
- Visual：分支菜单向上展开，首条回复后的工作区投影不再克隆过期分支。
- Visual：音量滑块保持实际滑块/滑块手柄可见，与大小和速度控件独立。
- Visual：补全 Schemastery 的离线传递依赖，修复独立安装时可能缺失 Cosmokit 的加载错误。
- Voice：取消对 Fairy UI/H.D.D 开关的依赖；TTS 离线也可预设音量，新增百分比可访问性提示。
- Windows 修复安装脚本：默认 desktop、支持已有 dsh-orb、SHA256 验证、只读检查、关闭目标确认及有限元数据备份；不停止进程、不覆盖用户 patch、不重下模型。
- Orb 仍为 1.1.0，不更改默认 agent 与悬浮窗。

验证使用隔离 DSH_HOME、真实浏览器和模拟服务；未做用户实际 Electron 窗口或真实音频推理验收，不保证所有第三方皮肤组合。
