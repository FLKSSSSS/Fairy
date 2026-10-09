# 更新日志

## UI / Voice 1.1.1 · 2026-10-09

- Visual：Git graph 分支、工作区和 agent 模式分行显示，不再重叠。
- Visual：分支菜单向上展开，首条回复后的工作区投影不再克隆过期分支。
- Visual：音量滑块保持实际滑块/滑块手柄可见，与大小和速度控件独立。
- Visual：补全 Schemastery 的离线传递依赖，修复独立安装时可能缺失 Cosmokit 的加载错误。
- Voice：取消对 Fairy UI/H.D.D 开关的依赖；TTS 离线也可预设音量，新增百分比可访问性提示。
- Windows 修复安装脚本：默认 desktop、支持已有 dsh-orb、SHA256 验证、只读检查、关闭目标确认及有限元数据备份；不停止进程、不覆盖用户 patch、不重下模型。
- Orb 仍为 1.1.0，不更改默认 agent 与悬浮窗。

验证使用隔离 DSH_HOME、真实浏览器和模拟服务；未做用户实际 Electron 窗口或真实音频推理验收，不保证所有第三方皮肤组合。
