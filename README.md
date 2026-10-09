# Fairy · DeepSeek Harness 插件合集

将 Fairy 的界面、语音朗读和桌面悬浮窗拆分成三个可独立安装的 DeepSeek Harness 插件。

**插件版本：1.1.0** · **已验证：DeepSeek Harness 0.2.0-rc.2 / Windows x64 / web profile**

> 正式版 `0.2.0` 及其他版本尚未验证。此仓库不是 DSH 主程序，也不内置对话模型或 API Key。安装包适配 Windows x64，不代表其他系统兼容。

## 三个插件

### Fairy UI · `dsh-fairy-visual`

为 DeepSeek Harness 打造的 Fairy 风格界面插件，提供动态大眼睛、渐变背景、右下角快捷控件与外观设置，并优化流式回复时的滚动体验，让对话界面更生动、流畅。可独立安装使用。

- 动态大眼睛与待机动画
- 渐变背景、H.D.D 开关与眼睛大小/动画速度设置
- 对话流式更新滚动位置保护
- UI 单独安装不注册 Fairy agent；音量控件需要同时安装 Voice

[插件代码与说明](plugins/dsh-fairy-visual)

### Fairy Voice · `dsh-fairy-voice`

为 DeepSeek Harness 提供 Fairy 本地语音朗读功能，支持手动朗读、自动朗读、音量调节与播放中断，集成 GPT-SoVITS 本地 TTS 接口及长回复语音简报。语音模型与运行环境单独安装，可独立于 UI 和悬浮窗使用。

- 手动朗读、自动朗读设置与播放控制
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

## 下载

前往 **[Releases / plugins-v1.1.0](https://github.com/FLKSSSSS/Fairy/releases/tag/plugins-v1.1.0)**：

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

## 快速安装

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

## 安装并开启本地语音

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

详细说明：[使用说明](docs/使用说明.txt) · [语音环境说明](docs/语音环境使用说明.txt) · [验证报告](docs/验证报告.txt)

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
