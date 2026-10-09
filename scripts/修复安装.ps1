[CmdletBinding()]
param(
  [string]$DshHome='',
  [string]$DshCommand='dsh',
  [string]$Profile='desktop',
  [switch]$CheckOnly,
  [switch]$TargetClosed
)
$ErrorActionPreference='Stop'
$oldHome=$env:DSH_HOME
$wanted=@{ 'dsh-fairy-visual'='1.1.2'; 'dsh-fairy-voice'='1.1.1' }
function Get-PackageSHA256([string]$LiteralPath) {
  # Use .NET directly: Windows PowerShell launched from PS7 can inherit a
  # module search path where Get-FileHash is unavailable. No modules needed.
  $stream=[IO.File]::OpenRead($LiteralPath)
  $hasher=[Security.Cryptography.SHA256]::Create()
  try { return ([BitConverter]::ToString($hasher.ComputeHash($stream))).Replace('-','').ToLowerInvariant() }
  finally { $hasher.Dispose(); $stream.Dispose() }
}
try {
  if ($DshHome) { $env:DSH_HOME=[IO.Path]::GetFullPath($DshHome) }
  $homePath=if ($env:DSH_HOME) { [IO.Path]::GetFullPath($env:DSH_HOME) } else { Join-Path $HOME '.dsh' }
  if ($Profile -notmatch '^[A-Za-z0-9][A-Za-z0-9_-]*$') { throw 'Profile 必须是普通配置名，不能包含路径。' }
  $cli=Get-Command $DshCommand -ErrorAction Stop
  if ($cli.CommandType -notin @('Application','ExternalScript')) { throw 'DshCommand 必须指向 dsh 可执行文件、dsh.cmd 或启动脚本。' }
  $version=(& $cli.Source --version | Out-String).Trim()
  if ($LASTEXITCODE -ne 0 -or $version -notmatch '(^|\s)0\.2\.0-rc\.2(\s|$)') { throw "本修复仅验证 DSH 0.2.0-rc.2；检测结果：$version" }
  $profilePath=Join-Path (Join-Path $homePath 'profiles') $Profile
  $manifestPath=Join-Path $profilePath 'package.json'
  $patchPath=Join-Path $profilePath 'cordis.patch.yml'
  $beforeDeps=@{}
  $beforeBundles=@()
  if (Test-Path -LiteralPath $manifestPath) {
    $manifest=Get-Content -LiteralPath $manifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
    if ($manifest.dependencies) { foreach($dep in $manifest.dependencies.PSObject.Properties) { $beforeDeps[$dep.Name]=$dep.Value } }
    $beforeBundles=@($manifest.dsh.profile.bundles)
    if ($beforeBundles -notcontains '@deepseek-ai/dsh-web-app') { throw '目标 profile 不包含 dsh-web-app，请指定实际使用的桌面或 web profile。' }
    foreach($name in @('dsh-fairy-visual','dsh-fairy-voice')) {
      $mp=Join-Path (Join-Path (Join-Path $profilePath 'node_modules') $name) 'package.json'
      if ($beforeDeps.ContainsKey($name) -or (Test-Path -LiteralPath $mp)) {
        if (!(Test-Path -LiteralPath $mp)) { throw "已有 $name 但安装不完整，请先修复其依赖，不要覆盖来源不明的旧整合版。" }
        $installed=Get-Content -LiteralPath $mp -Raw -Encoding UTF8 | ConvertFrom-Json
        if (!$installed.dsh.bundle.patch) { throw "已有非 bundle 版 $name，拒绝重复挂载；请不要直接覆盖旧 Fairy 整合版。" }
        Write-Host "检测到 $name $($installed.version)，将通过官方插件管理器更新。"
      }
    }
    if ($beforeDeps.ContainsKey('dsh-fairy-runtime') -or $beforeDeps.ContainsKey('dsh-fairy-startup')) { throw '检测到旧 Fairy 整合版，不适合本次独立插件修复。请使用其专用更新方式。' }
    if ($beforeDeps.ContainsKey('dsh-orb')) { Write-Host '原 dsh-orb 将保留。本次不安装、不替换、不启动任何悬浮窗插件。' }
  } elseif ($Profile -ne 'web') { throw '找不到目标 desktop profile。请用 -DshHome 指向桌面实际的数据目录；新测试配置可用 -Profile web。' }
  if (Test-Path -LiteralPath $patchPath) {
    # Inspect only for duplicate mounts; never print or copy user configuration.
    $patch=Get-Content -LiteralPath $patchPath -Raw -Encoding UTF8
    if ($patch -match '(?m)name:\s*["'']?(dsh-fairy-(visual|voice))([/\s"'']|$)') { throw '用户 patch 已手动挂载 Fairy UI/Voice；本脚本不删除配置，也不叠加第二份。请先核对安装方式。' }
  }
  $hashPath=Join-Path $PSScriptRoot 'SHA256SUMS.txt'
  if (!(Test-Path -LiteralPath $hashPath)) { throw '缺少 SHA256SUMS.txt，请完整解压修复 ZIP。' }
  $hashes=@{}
  Get-Content -LiteralPath $hashPath -Encoding UTF8 | ForEach-Object {
    if ($_ -match '^([a-fA-F0-9]{64})\s+(.+)$') {
      if ($hashes.ContainsKey($matches[2])) { throw '校验文件包含重复记录。' }
      $hashes[$matches[2]]=$matches[1]
    }
  }
  $packages=@()
  foreach($name in @('dsh-fairy-visual','dsh-fairy-voice')) {
    $file="$name-$($wanted[$name]).tgz"
    $p=Join-Path $PSScriptRoot $file
    if (!(Test-Path -LiteralPath $p)) { throw "缺少 $file，请完整解压修复 ZIP。" }
    if (!$hashes.ContainsKey($file) -or (Get-PackageSHA256 $p) -ne $hashes[$file]) { throw "SHA256 校验失败：$file" }
    $packages+=$p
  }
  Write-Host "目标 DSH_HOME：$homePath"
  Write-Host "目标 profile：$Profile；DSH：$version；UI：1.1.2 / Voice：1.1.1"
  if ($CheckOnly) { Write-Host '检查通过；未创建目录、备份、安装或启动任何服务。'; return }
  if (!$TargetClosed) { throw '请先正常退出目标 DSH/Fairy，再添加 -TargetClosed 执行安装。本脚本不会结束或重启用户程序。仅检查请使用 -CheckOnly。' }
  if (Test-Path -LiteralPath $profilePath) {
    $backup=Join-Path $profilePath ('backups\fairy-background-1.1.2-'+(Get-Date -Format yyyyMMdd-HHmmss-fff))
    New-Item -ItemType Directory -Path $backup -Force | Out-Null
    foreach($file in @('package.json','pnpm-lock.yaml','pnpm-workspace.yaml')) {
      $p=Join-Path $profilePath $file
      if (Test-Path -LiteralPath $p) { Copy-Item -LiteralPath $p -Destination (Join-Path $backup $file) }
    }
    Write-Host "已备份插件管理元数据：$backup（不复制 patch、凭据、会话或语音配置）"
  }
  & $cli.Source plugin --profile $Profile add @packages
  if ($LASTEXITCODE -ne 0) { throw '官方插件管理器安装失败；请查看上方错误。不会自动覆盖配置或回滚会话。' }
  $after=Get-Content -LiteralPath $manifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
  foreach($name in @('dsh-fairy-visual','dsh-fairy-voice')) {
    $mp=Join-Path (Join-Path (Join-Path $profilePath 'node_modules') $name) 'package.json'
    $installed=Get-Content -LiteralPath $mp -Raw -Encoding UTF8 | ConvertFrom-Json
    if ($installed.version -ne $wanted[$name] -or !$installed.dsh.bundle.patch) { throw "安装后 $name 的版本或 bundle 声明不正确。" }
    if (@($after.dsh.profile.bundles | Where-Object { $_ -eq $name }).Count -ne 1) { throw "安装后 $name 的 bundle 未启用或重复。" }
  }
  foreach($name in $beforeDeps.Keys) {
    if (!$wanted.ContainsKey($name) -and $after.dependencies.$name -ne $beforeDeps[$name]) { throw "其他插件依赖发生变化，请查看元数据备份：$name" }
  }
  foreach($name in $beforeBundles) {
    if (@($after.dsh.profile.bundles) -notcontains $name) { throw "原 bundle 意外丢失，请查看元数据备份：$name" }
  }
  Write-Host '修复安装完成：Fairy UI 1.1.2 + Fairy Voice 1.1.1。原悬浮窗及其他插件已保留。'
  Write-Host '请用原来的方式重新打开目标 DSH。音量在输入框右侧最上方；朗读服务还需在“朗读”设置中配置。'
  Write-Host '重新打开后请确认右上 H.D.D 已开启；新会话和已有对话均应显示渐变网格背景。'
  Write-Host '不需要重新下载语音模型；本脚本没有启动 TTS 或 DSH。若使用自定义 DSH_HOME，重新启动时也要使用同一目录。'
} finally { $env:DSH_HOME=$oldHome }
