# dsh-fairy-visual

Fairy UI · DeepSeek Harness 独立插件，版本 `1.1.2`。

动态大眼睛、渐变网格背景、H.D.D 开关、右侧外观控件及流式回复滚动保护。1.1.2 修复桌面对话面板挡住背景、YAML 代码块工具栏覆盖输入区，并兼容 Settings portal 的模态遮罩。同时避免 hover 提示重建滑块布局、打断快速鼠标拖动；原生滑块及持续使用的布局标记保持不变，Voice 包不改。

保留 1.1.1 的 Git graph 分支/工作区分行、底部分支菜单向上展开及过期分支投影修复。音量滑块需要同时安装 Voice 1.1.1；单独安装 UI 只有眼睛大小和动画速度两个控件。

## 安装与更新

适用 Windows x64，DeepSeek Harness `0.2.0-rc.2`。使用 [1.1.2 背景修复包](https://github.com/FLKSSSSS/Fairy/releases/tag/background-v1.1.2) 更新 UI 1.1.2 / Voice 1.1.1；保留现有 Orb 与语音模型。先 `-CheckOnly` 检查，正常退出目标 DSH 后再 `-TargetClosed` 安装。

详细安装、背景开启及排错见[背景修复使用说明](../../docs/背景修复使用说明.txt)和[仓库首页](../../README.md)。更新后确认 H.D.D 已开启。现有独立 `dsh-orb` 可保留；不要用旧全集脚本修复现有桌面配置，也不要叠加手写同名挂载。

## 代码与发行包

此目录保存运行代码、资源、类型声明与 bundle 配置，不包含第三方 `node_modules` 或语音模型。GitHub Source code ZIP 不等于可直接安装的发行包，请使用 Releases 的 `.tgz` 或修复 ZIP。

隔离测试验证官方桌面客户端模块、实际 tgz 安装/重复安装、浅色/深色背景、代码块层级、设置弹窗、H.D.D 开关及流式滚动。没有执行用户实际 Electron 桌面窗口验收或真实 TTS 推理。详见[验证报告](../../docs/背景修复验证报告.txt)。

可用 Node 自带测试运行源码契约与轻量 DOM 回归检查：

```powershell
node --test scripts/tests/background-regression.test.cjs
```

完整功能见 [README.txt](README.txt)，来源与许可见 [PROVENANCE.txt](PROVENANCE.txt)。
