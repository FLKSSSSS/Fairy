Fairy UI 1.1.2（2026-10-09）
DeepSeek Harness 0.2.0-rc.2 / Windows x64 / web UI。

动态大眼睛、渐变网格背景、H.D.D 开关、眼睛大小/速度与流式滚动保护。
修复桌面版进入对话后不透明面板遮住渐变背景的问题，适配官方 main.conversation slot。
恢复输入栏的原生层级，代码块 YAML 粘性工具栏不再遮住输入区；保留工具栏复制功能。
修复悬停音量条触发提示时重建滑块、快速拖动失效的问题；保留 Voice 包与配置。
适配官方 Settings portal；设置弹窗打开时输入栏位于遮罩后，关闭后恢复正常。
保留 1.1.1 Git graph 分支与工作区分行、分支菜单向上及过期投影修复。
单装本插件只有两个眼睛控件；第三条音量需要 dsh-fairy-voice 1.1.1。
不注册 Fairy agent、不改默认预设、不安装或替换 Orb。

安装/升级
正常退出目标 DSH，在实际使用的数据目录/profile 中通过官方插件管理器安装：
  dsh plugin --profile desktop add "dsh-fairy-visual-1.1.2.tgz"
若使用命令行 web，改为 --profile web。自定义 DSH_HOME 安装和启动必须一致。
已有 dsh-orb 可保留；不要与旧非 bundle 版 Fairy UI/Voice 或手写同名挂载叠加。
建议使用 Fairy-Background-Fix-1.1.2-Windows-x64.zip 中的修复安装.ps1：
先 -CheckOnly，再正常退出目标后 -TargetClosed。脚本更新 UI 1.1.2 / Voice 1.1.1，不改 Orb。
重新打开 DSH，确认右上 H.D.D 已开启；背景在关闭 H.D.D 时不显示是正常行为。
详细用法、排错及验证限制见修复 ZIP 内的使用说明.txt。

运行依赖与模型
发行包内打包所需 Node 依赖；GitHub Source code ZIP 不含 node_modules，不等于发行包。
已有语音模型无需重下。Voice 1.1.1 与此前发行包字节相同，不更新语音功能。
验证使用隔离 DSH_HOME、无头 Edge 和模拟模型；未运行真实 TTS/GPU 或用户 Electron 整机验收。
来源与素材许可见 PROVENANCE.txt，第三方许可保留。
