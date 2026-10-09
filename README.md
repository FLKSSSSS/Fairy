# Fairy · DeepSeek Harness 插件合集

将 Fairy 的界面、语音朗读和桌面悬浮窗拆分成三个可独立安装的 DeepSeek Harness 插件。

**UI / Voice：1.1.1** · **Orb：1.1.0（本次不变）** · **已验证：DeepSeek Harness 0.2.0-rc.2 / Windows x64**

> 正式版 `0.2.0` 及其他版本尚未验证。此仓库不是 DSH 主程序，也不内置对话模型或 API Key。安装包适配 Windows x64，不代表其他系统兼容。

## 三个插件

### Fairy UI · `dsh-fairy-visual`

为 DeepSeek Harness 打造的 Fairy 风格界面插件，提供动态大眼睛、渐变背景、右下角快捷控件与外观设置，并优化流式回复时的滚动体验，让对话界面更生动、流畅。可独立安装使用。

- 动态大眼睛与待机动画
- 渐变背景、H.D.D 开关与眼睛大小/动画速度设置
- 对话流式更新滚动位置保护
- 修复 Git 分支与工作区标签重叠、底部分支菜单超屏
- UI 单独安装不注册 Fairy agent；音量控件需要同时安装 Voice

[插件代码与说明](plugins/dsh-fairy-visual)

### Fairy Voice · `dsh-fairy-voice`

为 DeepSeek Harness 提供 Fairy 本地语音朗读功能，支持手动朗读、自动朗读、音量调节与播放中断，集成 GPT-SoVITS 本地 TTS 接口及长回复语音简报。语音模型与运行环境单独安装，可独立于 UI 和悬浮窗使用。

- 手动朗读、自动朗读设置与播放控制
- H.D.D 关闭或单装 Voice 时仍显示控件；TTS 离线可预设音量
- GPT-SoVITS 本地 TTS 接口
- 内含参考音频和参考文本
- 长回复简报；未配置简报 API Key 时使用本地降级摘要
- 这是文本转语音插件，不包含语音识别

[插件代码与说明](plugins/dsh-fairy-voice)

### Fairy Orb · `dsh-fairy-orb`

为 DeepSeek Harness 提供 Fairy 动态大眼睛桌面悬浮窗，支持快捷输入、拖动定位与 Fairy 角色对话，新会话默认使用 Fairy 预设。包含悬停闪烁及输入框消失修复，发行包附带 Windows x64 Electron 运行时，可独立安装使用。

- 动态大眼睛与桌面悬浮交互
- 输入区及鼠标悬停稳定性修复
- 新会话使用 Fairy；旧会话保留原 preset
- 不修改后台 code-agent 预设，也不改变主窗口全局默认 agent
- 不安装 Voice 也可文字对话；朗读需要 Voice 和本地 TTS 服务

[插件代码与说明](plugins/dsh-fairy-orb)

## 1.1.1 控件修复（2026-10-09）

修复安装后 `master` 与工作区名重叠、缺少音量 UI。本次只更新 UI / Voice，保留已有悬浮窗、聊天和语音模型，不改变默认 agent。

从 [controls-v1.1.1](https://github.com/FLKSSSSS/Fairy/releases/tag/controls-v1.1.1) 下载 `Fairy-Controls-Fix-1.1.1-Windows-x64.zip` 并完整解压。**不要使用旧 1.1.0 合集的安装插件.ps1 来修复已有 dsh-orb 的桌面配置。**

桌面版示例（请替换成实际解压位置与 DSH 安装路径）：

```powershell
# 只读检查，未安装、未重启
powershell -NoProfile -ExecutionPolicy Bypass -File 'F:\Fairy修复\修复安装.ps1' -DshCommand 'E:\DSH\resources\runtime\cli\bin\dsh.cmd' -CheckOnly

# 正常退出目标 DSH 后更新；脚本不杀进程、不启动 TTS
powershell -NoProfile -ExecutionPolicy Bypass -File 'F:\Fairy修复\修复安装.ps1' -DshCommand 'E:\DSH\resources\runtime\cli\bin\dsh.cmd' -TargetClosed
```

默认更新 `%USERPROFILE%\.dsh / desktop`；自定义数据目录加 `-DshHome`，命令行 web 版加 `-Profile web`。重新打开 DSH 后，H.D.D 模式输入区右侧三个横条依次为 **音量、眼睛大小、动画速度**。音量可鼠标拖动或键盘调整并保存；出现音量 UI 不代表 TTS 服务已启动。

- 更新脚本校验版本和 SHA256，使用官方 plugin add，备份插件管理元数据。
- 拒绝旧非 bundle UI/Voice 和同名手动重复挂载；不修改用户 patch。
- 已验证保留已有独立 dsh-orb、Git graph 及其他声明依赖，重复安装不重复挂载。
- 真实 Edge 测试覆盖长标签、工作区切换、H.D.D 开关、Voice 单装及流式滚动。
- 桌面内置客户端的隔离加载验证不等同于真实 Electron 整机验收；未运行真实音频合成。

[详细使用说明](docs/控件修复使用说明.txt) · [修复验证报告](docs/控件修复验证报告.txt)

## 旧 1.1.0 完整合集（草稿）

历史完整合集与模型分卷仍保留在草稿中，尚未公开；下面记录其附件与安装方法。当前已安装用户优先使用上面的 1.1.1 修复，不需重新下载模型。

历史草稿：**[Releases / plugins-v1.1.0](https://github.com/FLKSSSSS/Fairy/releases/tag/plugins-v1.1.0)**：

| 文件 | 用途 |
| --- | --- |
| `Fairy-DSH-Plugins-1.1.0-Windows-x64.zip` | 三插件合集，约 189 MB；包括安装脚本、详细中文说明和验证报告 |
| `dsh-fairy-visual-1.1.0.tgz` | 仅 UI |
| `dsh-fairy-voice-1.1.0.tgz` | 仅语音插件，不含模型环境 |
| `dsh-fairy-orb-1.1.0.tgz` | 仅悬浮窗，内含离线 Electron/Koffi |
| `Fairy-Voice-Runtime-Windows-x64.zip.001` / `.002` / `.003` | 本地语音模型与 Python/GPT-SoVITS 环境分卷，必须全部下载 |
| `Restore-VoiceRuntime.ps1` | 验证分卷并合并成完整 ZIP |
| `voice-runtime-manifest.json` | 分卷大小、SHA256 和原 ZIP 校验信息 |
| `SHA256SUMS-release.txt` | Release 附件校验和（不包含此校验文件自身） |

> GitHub 自动生成的 **Source code (zip/tar.gz)** 不包含第三方依赖、Electron 和语音模型，不是可直接安装的整合包。推荐下载上述插件合集。

## 旧 1.1.0 全集安装方式

1. 先安装并确认 `dsh --version` 为 `0.2.0-rc.2`。
2. 将插件合集解压到例如 `F:\Fairy插件`，不要打散脚本、三个 `.tgz` 和 `SHA256SUMS.txt`。
3. 使用干净的 DSH 数据目录，避免与旧 Fairy 整合版重复注册：

```powershell
$env:DSH_HOME = 'F:\Fairy-DSH-插件测试数据'
powershell -NoProfile -ExecutionPolicy Bypass -File 'F:\Fairy插件\安装插件.ps1' -DshHome $env:DSH_HOME
dsh --profile web
```

若 `dsh` 不在 PATH 中，安装时加 `-DshCommand '实际的\dsh.cmd路径'`。仅装一个组件可加 `-Component UI`、`-Component Voice` 或 `-Component Orb`。

`-DshHome` 不会永久设置环境变量。以后启动 DSH 仍需使用同一 `DSH_HOME`。新数据目录不会继承旧账号和聊天记录；需自行配置模型账号/API Key。

## 安装并开启本地语音（旧全集/已有环境）

1. 将全部三个语音分卷、`voice-runtime-manifest.json` 和 `Restore-VoiceRuntime.ps1` 下载到同一目录，例如 `F:\Fairy下载`。
2. 执行合并脚本。脚本检查每个分卷及完整 ZIP 的 SHA256，不覆盖已有 ZIP：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File 'F:\Fairy下载\Restore-VoiceRuntime.ps1'
```

3. 将生成的 `Fairy-Voice-Runtime-Windows-x64.zip` 完整解压到 `F:\fairy音频依赖`。应存在 `F:\fairy音频依赖\voice-runtime\Python310\python.exe`。已有语音环境时不要直接覆盖；先使用新的目录测试。
4. 启动本地 TTS：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File 'F:\fairy音频依赖\voice-runtime\start_tts_portable.ps1' -Device cpu -StartupTimeoutSeconds 180
```

5. 打开 `http://127.0.0.1:9880/docs` 检查服务，再在 DSH “朗读”设置中手动测试，随后开启自动朗读。

停止服务：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File 'F:\fairy音频依赖\voice-runtime\stop_tts_portable.ps1'
```

分卷总大小约 **5.86 GB**，环境解压约 **8.04 GB**。下载分卷、合并 ZIP、解压环境会同时占用空间，建议至少预留 **24 GB**。GPU/CUDA 推理取决于硬件和驱动，本次拆分未做真实推理验证。不要对便携 Python 执行全量 `pip upgrade`。

## 验证与限制

已完成三个单插件及三插件组合的安装、重复安装、bundle/patch、依赖、语法和真实 web 页面加载验证；网页测试未发现页面/控制台错误。

- 网页验证使用 mock TTS 状态，并隔离了 Orb 自动启动。
- 真实桌面鼠标键盘交互、实际音频播放及 GPU/CPU 合成仍需在目标电脑验收。
- 不保证所有崩溃问题已解决，也不宣称支持未经验证的 DSH 版本。
- 发行包经过敏感路径及常见密钥模式检查，不含用户 API Key、浏览器会话、聊天记录和 `voice-brain.json`；扫描不等于能识别所有格式的秘密。

1.1.1 修复另见[控件验证报告](docs/控件修复验证报告.txt)。旧版详细说明：[使用说明](docs/使用说明.txt) · [语音环境说明](docs/语音环境使用说明.txt) · [验证报告](docs/验证报告.txt)

## 仓库结构

```text
plugins/   三插件发行运行代码、资源、类型声明和 bundle 配置
scripts/   安装与语音分卷合并脚本
docs/      中文使用说明、验证报告和原插件包校验文件
```

运行代码来自已修复 Fairy 的拆分产物，仓库未包含完整原始 TypeScript 工程。第三方依赖及 Electron 只随 Releases 发行包提供；不要直接对仓库目录 `npm pack` 并认为它与已验证发行包等价。

## 来源与许可

Orb 基于 [mini-yifan/dsh-orb-cordis](https://github.com/mini-yifan/dsh-orb-cordis)，保留其 MIT LICENSE。Electron、Chromium、Python、GPT-SoVITS、模型及依赖的许可证以相应发行包内的 LICENSE/notice 为准。

Fairy 角色、声音、参考音频及模型权利归各自权利人所有。本仓库不为这些素材新增商业或再分发授权；使用者应自行确认用途许可。不要把某一依赖的 MIT 许可理解为仓库所有素材和模型的统一授权。
