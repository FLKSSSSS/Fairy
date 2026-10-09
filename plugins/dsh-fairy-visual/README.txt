Fairy 独立插件使用说明
构建日期：2026-10-09

一、这是什么
这是三个真正声明 dsh.bundle.patch 的 DeepSeek Harness 插件，安装时由 DSH 插件管理器加入当前 profile 的 bundles，正常安装后不需要手写 cordis.patch.yml。
1. dsh-fairy-visual-1.1.0.tgz：Fairy UI。动态大眼睛、H.D.D 开关、渐变背景、眼睛大小/速度控制、对话滚动保护。首次安装默认开启、浅色、眼睛缩放 0.55；已有保存的设置仍优先，不覆盖个人偏好。单独使用 UI 不注册 Fairy agent。
2. dsh-fairy-voice-1.1.0.tgz：Fairy 朗读。手动朗读、自动朗读设置、音量/中断播放、长回复简报，内含参考音频和参考文本；不依赖 UI 或 Orb。它是文本转语音/朗读插件，不是语音识别插件。Python、GPT-SoVITS、音色及基础模型另附 ZIP。
3. dsh-fairy-orb-1.1.0.tgz：Fairy 悬浮窗。内含动态眼睛、输入区修复、鼠标悬浮闪烁修复、独立 Fairy 角色与语料、GUI 工具，以及 Windows x64 离线 Electron。新会话使用 fairy；打开旧会话保留其原始预设身份。保留 computer-use 旧预设；后台 code_agent 仍用原预设，不强改成 Fairy。此插件不把主 DSH 的全局默认预设改成 Fairy；主窗口要使用 Fairy，可在新建会话时选择 Fairy。
三个插件可以分别安装；主窗口右下角语音音量控制需要 UI+Voice。UI 单装仍有眼睛大小和动画速度控件。Orb 单装可对话，但没有语音插件就没有 Fairy 朗读服务。

二、适用环境与空间
本次实测兼容 DeepSeek Harness 0.2.0-rc.2 的 web profile。这里的 1.1.0 是插件版本，不是 DSH 版本。未验证正式 0.2.0 或其他版本，请勿跳过版本安全门。
交付目标为 Windows x64。本包没有 DSH 主程序；先自行安装该版本 DSH，确认 PowerShell 中 dsh --version 能运行。
悬浮窗包已有 Electron，不需要另装 Electron。模型包自带 Python 3.10，不需要改系统 Python，也不要对其中环境运行 pip 全量升级。
模型 ZIP 约 5.85 GB，解压约 8.04 GB；加上压缩包、插件和日志，建议至少保留 16 GB 可用空间。首次解压会比较久，这是正常现象。
不包含 API Key、浏览器会话、个人对话记录、voice-brain.json 或用户设置。你需要在自己的 DSH 里配置模型账号/API Key。
第三方程序与模型许可按随附 LICENSE/notice 为准；Fairy 角色与声音素材不代表新授予商业/公开分发权限，使用者应自行确认用途许可。

三、必须先看：不要与旧 Fairy 整合版叠加
旧 Fairy 整合版已有同名 UI/Voice、fairy preset、orb-host 或原 dsh-orb，叠加会造成重复挂载和端点冲突。安装脚本检测到这些情况会拒绝，不删除原配置。
推荐测试独立 DSH_HOME：
  $env:DSH_HOME = 'F:\Fairy-DSH-插件测试数据'
此设置只对当前 PowerShell 会话及其子进程生效；每次从新终端启动，都应设置同一路径。新的数据目录不会继承旧账号、聊天记录，需重新配置模型。
不要把本次包直接解压覆盖到 E:\Fairy 或原插件 node_modules。先正常退出你准备安装的目标 DSH，再安装。脚本不会结束当前 Fairy、不会自动重启，也不会替你杀进程。

四、推荐安装方法
1. 将 Fairy-DSH-三个独立插件-20261009.zip 完整解压到任意目录，例如 F:\Fairy插件。脚本、三个 tgz、SHA256SUMS.txt 必须留在同一目录。
2. 打开 PowerShell，确认 dsh --version 输出 0.2.0-rc.2。
3. 选择自己的目标数据目录。第一次使用推荐独立目录，例如：
  $env:DSH_HOME = 'F:\Fairy-DSH-插件测试数据'
4. 安装三个插件：
  powershell -NoProfile -ExecutionPolicy Bypass -File 'F:\Fairy插件\安装插件.ps1'
若 dsh 不在 PATH，用 -DshCommand 指定实际 dsh.cmd 的绝对路径。若只装一个组件：
  powershell -NoProfile -ExecutionPolicy Bypass -File 'F:\Fairy插件\安装插件.ps1' -Component UI
  powershell -NoProfile -ExecutionPolicy Bypass -File 'F:\Fairy插件\安装插件.ps1' -Component Voice
  powershell -NoProfile -ExecutionPolicy Bypass -File 'F:\Fairy插件\安装插件.ps1' -Component Orb
-DshHome 可显式指定安装数据目录，但不会永久设置环境变量；启动 DSH 时仍要指定相同 DSH_HOME。脚本先校验 SHA256，并备份目标 profile 的元数据，不备份或复制凭据。
5. 启动主程序：
  dsh --profile web
安装 tgz 不会启动语音服务。下一节单独说明。

五、也可以用 DSH 原生命令逐个安装
路径请按实际目录修改，带中文或空格都应整体加引号。不要双击 tgz。
  dsh plugin --profile web add 'F:\Fairy插件\dsh-fairy-visual-1.1.0.tgz'
  dsh plugin --profile web add 'F:\Fairy插件\dsh-fairy-voice-1.1.0.tgz'
  dsh plugin --profile web add 'F:\Fairy插件\dsh-fairy-orb-1.1.0.tgz'
这些命令不带包装脚本的旧整合版冲突检查，请自行确认目标干净。安装后可用：
  dsh --profile web --dump-config
检查 fairy-visual、fairy-voice、orb-host、preset-fairy 是否出现。插件管理器界面也能查看/启停 bundle。
模型和角色预设不会替你提供模型凭据；仍需 DSH 的账号/API Key 配置。

六、安装和开启本地语音
1. 另外下载/复制 Fairy-语音模型与本地环境-Windows-x64-20261009.zip。
2. 完整解压到 F:\fairy音频依赖 或任意其他目录。该 ZIP 的顶层目录为 voice-runtime。例如最终应存在：
  F:\fairy音频依赖\voice-runtime\start_tts_portable.ps1
  F:\fairy音频依赖\voice-runtime\Python310\python.exe
  F:\fairy音频依赖\voice-runtime\FairyModels
3. 启动 CPU 模式（兼容优先，不占用 GPU）：
  powershell -NoProfile -ExecutionPolicy Bypass -File 'F:\fairy音频依赖\voice-runtime\start_tts_portable.ps1' -Device cpu -StartupTimeoutSeconds 180
使用自动选择：去掉 -Device cpu（默认 auto）。CUDA 模式依赖机器的 NVIDIA 驱动和显存条件；本次拆分没有重新做 GPU 推理验证，不保证所有显卡适用。
4. 服务仅监听 127.0.0.1:9880；浏览器打开 http://127.0.0.1:9880/docs 检查是否起来。首次加载较慢，超时消息不一定等于启动失败；先看该目录 logs 下日志，不要重复启动多份。
5. 启动 DSH，进入设置的“朗读”页面。先手动点击一条助手回复的朗读按钮，允许浏览器播放声音；再按需要开启“自动朗读”。自动朗读只读开启后符合条件的新回复，不应把全部历史重新播放。
6. 若回复较长，语音简报功能可能需要另外配置自己的 DeepSeek API Key。该 Key 保存到自己的 DSH_HOME\fairy-voice-data\voice-brain.json；未配置时使用本地降级摘要，不影响基础朗读。不要把此文件发给他人。
7. 停止服务：
  powershell -NoProfile -ExecutionPolicy Bypass -File 'F:\fairy音频依赖\voice-runtime\stop_tts_portable.ps1'
停止脚本核对本包 PID 与启动时间，只处理属于本环境的服务。不能按 9880 端口盲目杀进程。若已有正确服务正在运行，无需再启；若端口被其他程序占用，应查明身份后自行处理。
语音运行在同一台电脑：包内参考音频路径由 DSH 发送给本机 TTS；把服务挪到远端或 WSL 需要自行处理共享路径，不属于本交付验证范围。

七、开启和使用悬浮窗
安装 Orb 后启动 dsh --profile web，host 会按保存的球开关启动悬浮窗。首次设置使用插件默认值。主界面设置里可找到 Orb/悬浮球设置，调整是否启用、位置、大小及外观。
将鼠标移到球上使用输入区域；点击输入框、输入文本后发送；拖动球可调整位置。新对话固定使用 Fairy；历史会话会保留已有预设身份，不篡改存档。
UI、语音、悬浮窗都不内置对话模型。若能显示悬浮窗却无法回复，先在 DSH 主界面确认模型账号与网络。
Windows 安全软件首次拦截 Electron 或 Koffi 时，先核验包 SHA256、来源和提示，不要关闭所有安全防护。未做签名安装器和每台机器的 SmartScreen 验证。

八、排错
- UI 没显示：确认安装到了正在启动的同一 DSH_HOME/web；检查插件 bundle 启用、H.D.D 开关及已有保存的 enabled 设置。完全退出目标 DSH 再开启以加载新客户端。
- 三个控件不足三项：UI 单装无语音音量控件或该控件禁用是正常的，装 Voice 并确认本地 TTS 可用。
- 没声音：先检查 /docs，再检查网页声音是否被静音、浏览器自动播放限制、朗读设置和系统输出设备。首次请手动点朗读。悬浮窗不等于语音服务。
- localhost 连不上：使用 127.0.0.1:9880。检查模型目录是否完整、是否解压成双层 voice-runtime、日志错误和端口占用；不要按端口杀无关进程。
- 包安装失败：保持 tgz 原文件名与校验文件，核实 DSH 版本；检查 pnpm/Node 的可用性。此交付附带插件 JS 依赖，不代表你原 DSH 安装的所有基础依赖完整。
- 模型路径错误：移动整个 voice-runtime 后重新执行启动脚本，配置会按当前位置生成；不要只搬 Python 或模型文件。
- 旧整合版被拒绝：使用全新 DSH_HOME，不要通过手工删原 profile 配置绕过防护。

九、卸载
先正常退出目标 DSH，再确认环境变量仍指向目标 DSH_HOME，运行：
  dsh plugin --profile web remove dsh-fairy-orb
  dsh plugin --profile web remove dsh-fairy-voice
  dsh plugin --profile web remove dsh-fairy-visual
可以只卸载任意一个组件，其余插件不依赖它。卸载后不自动删除个人聊天、设置、音量或 voice-brain.json。语音运行环境是单独解压目录，先用自己的 stop 脚本正常停止，再按需要手动删除；不要删除原 Fairy 的环境。
安装脚本创建的 profile\backups\fairy-plugins-日期 只是配置备份，不是完整应用快照。回滚之前请先备份当前配置和数据，勿覆盖新增会话。

十、验证边界
随附验证报告记录本次独立安装、四种配置组合、host 导入/语法、离线依赖、包路径与隐私检查、滚动/语音/会话逻辑回归，以及 ZIP CRC/SHA256。
原动态眼睛、hover 和文本框修复直接继承已修复 release 代码；本次不修改正在运行的 Fairy，不测试真实鼠标桌面交互，不启动现有或新 GPU 推理服务。不能把逻辑测试等同于所有机器上的真实 GUI/音频播放无故障。
本次已使用隔离的本机 DeepSeek Harness 复核安装说明清单；凭据只经子进程环境传入，没有写入发布包。
