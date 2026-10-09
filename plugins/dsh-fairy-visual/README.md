# dsh-fairy-visual

Fairy UI · DeepSeek Harness 独立插件，版本 `1.1.1`。

修复 Git graph 的 master 与工作区名/模式标签重叠；分支菜单向上展开，首条回复后不保留过期分支。音量滑块显示需要同时安装 Voice。

## 安装与更新

适用 Windows x64，DeepSeek Harness `0.2.0-rc.2`。使用 [1.1.1 控件修复包](https://github.com/FLKSSSSS/Fairy/releases/tag/controls-v1.1.1) 更新 UI 与 Voice；保留现有 Orb 与语音模型。先 `-CheckOnly` 检查，正常退出目标 DSH 后再 `-TargetClosed` 安装。

详细安装、音量位置及排错见[控件修复使用说明](../../docs/控件修复使用说明.txt)和[仓库首页](../../README.md)。现有独立 `dsh-orb` 可保留；不要用旧全集的安装脚本修复现有桌面配置。

## 代码与发行包

此目录保存运行代码、资源、类型声明与 bundle 配置，不包含第三方 `node_modules` 或语音模型。GitHub Source code ZIP 不等于可直接安装的发行包，请使用 Releases 的 `.tgz` 或修复 ZIP。

隔离环境已验证安装/重复安装和真实浏览器界面；没有执行用户实际桌面窗口验收或真实 TTS 推理。详见[验证报告](../../docs/控件修复验证报告.txt)。

完整功能见 [README.txt](README.txt)，来源与许可见 [PROVENANCE.txt](PROVENANCE.txt)。
