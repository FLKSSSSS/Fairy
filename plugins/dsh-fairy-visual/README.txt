Fairy UI 1.1.1（2026-10-09）
DeepSeek Harness 0.2.0-rc.2 / Windows x64 / web UI。

动态大眼睛、渐变背景、H.D.D 开关、眼睛大小/速度与流式滚动保护。
修复 Git graph 分支与工作区重叠，分支菜单向上展开，投影不克隆过期分支。
单装本插件只有两个眼睛控件；第三条音量需要 dsh-fairy-voice 1.1.1。
不注册 Fairy agent、不改默认预设、不安装或替换 Orb。

安装/升级
正常退出目标 DSH，在实际使用的数据目录/profile 中通过官方插件管理器安装：
  dsh plugin --profile desktop add "dsh-fairy-visual-1.1.1.tgz"
若使用命令行 web，改为 --profile web。自定义 DSH_HOME 安装和启动必须一致。
已有 dsh-orb 可保留；不要与旧非 bundle 版 Fairy UI/Voice 或手写同名挂载叠加。
建议使用 Fairy-Controls-Fix-1.1.1-Windows-x64.zip 中的修复安装.ps1，先 -CheckOnly，再关闭目标后 -TargetClosed。
完整用法、音量位置、排错和验证限制见修复 ZIP 内的使用说明.txt。

运行依赖与模型
发行包内打包所需 Node 依赖；GitHub Source code ZIP 不含 node_modules，不等于发行包。
本次未运行真实 TTS/GPU 推理，不宣称所有第三方皮肤/桌面环境无故障。
来源与素材许可见 PROVENANCE.txt，第三方许可保留。
