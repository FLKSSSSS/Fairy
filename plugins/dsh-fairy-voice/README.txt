Fairy Voice 1.1.1（2026-10-09）
DeepSeek Harness 0.2.0-rc.2 / Windows x64 / web UI。

手动/自动朗读、音量控制、中断播放、GPT-SoVITS 本地 TTS 接口与长回复简报。
不依赖 Fairy UI 或 Orb；关闭 H.D.D 仍可显示控件。
TTS 未运行时也能用鼠标/键盘预设音量；自动朗读要等待 TTS 就绪。
包含参考音频/文本，不含 Python、语音模型或语音识别。

安装/升级
正常退出目标 DSH，在实际使用的数据目录/profile 中通过官方插件管理器安装：
  dsh plugin --profile desktop add "dsh-fairy-voice-1.1.1.tgz"
若使用命令行 web，改为 --profile web。自定义 DSH_HOME 安装和启动必须一致。
已有 dsh-orb 可保留；不要与旧非 bundle 版 Fairy UI/Voice 或手写同名挂载叠加。
建议使用 Fairy-Controls-Fix-1.1.1-Windows-x64.zip 中的修复安装.ps1，先 -CheckOnly，再关闭目标后 -TargetClosed。
完整用法、音量位置、排错和验证限制见修复 ZIP 内的使用说明.txt。

运行依赖与模型
已有模型环境无需重下；沿用原来的 TTS 启动脚本。默认本地服务 127.0.0.1:9880。
发行包内打包所需 Node 依赖；GitHub Source code ZIP 不含 node_modules，不等于发行包。
本次未运行真实 TTS/GPU 推理，不宣称所有第三方皮肤/桌面环境无故障。
来源与素材许可见 PROVENANCE.txt，第三方许可保留。
