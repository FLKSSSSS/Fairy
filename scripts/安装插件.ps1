[CmdletBinding()]
param(
  [ValidateSet('All','UI','Voice','Orb')][string]$Component='All',
  [string]$DshHome='',
  [string]$DshCommand='dsh',
  [string]$Profile='web'
)
$ErrorActionPreference='Stop'
$oldHome=$env:DSH_HOME
try {
  if ($DshHome) { $env:DSH_HOME=[IO.Path]::GetFullPath($DshHome) }
  $homePath=if ($env:DSH_HOME) { [IO.Path]::GetFullPath($env:DSH_HOME) } else { Join-Path $HOME '.dsh' }
  if ($Profile -notmatch '^[A-Za-z0-9][A-Za-z0-9_-]*$') { throw 'Profile 必须是普通配置名，不能包含路径。' }
  $cli=Get-Command $DshCommand -ErrorAction Stop
  $version=(& $cli.Source --version | Out-String).Trim()
  if ($LASTEXITCODE -ne 0 -or $version -notmatch '(^|\s)0\.2\.0-rc\.2(\s|$)') { throw "本包只验证 DSH 0.2.0-rc.2；检测结果：$version" }
  $profilePath=Join-Path (Join-Path $homePath 'profiles') $Profile
  $manifestPath=Join-Path $profilePath 'package.json'
  $patchPath=Join-Path $profilePath 'cordis.patch.yml'
  if (Test-Path -LiteralPath $manifestPath) {
    $manifest=Get-Content -LiteralPath $manifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $deps=@($manifest.dependencies.PSObject.Properties.Name)
    if ($deps -contains 'dsh-orb' -or $deps -contains 'dsh-fairy-runtime' -or $deps -contains 'dsh-fairy-startup') { throw '检测到旧 Fairy 整合版/原 dsh-orb。为避免重复 preset、host 和设置路由，拒绝叠加安装。请使用独立 DSH_HOME。' }
    foreach($name in @('dsh-fairy-visual','dsh-fairy-voice')) {
      if ($deps -contains $name) {
        $mp=Join-Path (Join-Path (Join-Path $profilePath 'node_modules') $name) 'package.json'
        if (!(Test-Path -LiteralPath $mp) -or !((Get-Content -LiteralPath $mp -Raw | ConvertFrom-Json).dsh.bundle.patch)) { throw "检测到旧的非 bundle 插件 $name，请使用独立 DSH_HOME，不要覆盖整合版。" }
      }
    }
    if (@($manifest.dsh.profile.bundles) -notcontains '@deepseek-ai/dsh-web-app') { throw '这不是 web profile；本包的 UI、语音和悬浮窗需要 dsh-web-app。' }
  } elseif ($Profile -ne 'web') { throw '新配置请使用 web；自定义 profile 必须先配置 dsh-web-app。' }
  if (Test-Path -LiteralPath $patchPath) {
    $patch=Get-Content -LiteralPath $patchPath -Raw -Encoding UTF8
    if ($patch -match '(?m)name:\s*["'']?(dsh-fairy-(visual|voice|runtime)|dsh-orb)([/\s"'']|$)' -or $patch -match '(?m)^\s*-?\s*id:\s*(preset-fairy|preset-computer-use|orb-host|ui-settings-orb)\s*$') { throw '用户 patch 中已有 Fairy/orb 手动挂载项，会与新 bundle 重复。请使用新的 DSH_HOME；本脚本不会删除你的配置。' }
  }
  $items=@()
  if ($Component -in @('All','UI')) { $items+='dsh-fairy-visual-1.1.0.tgz' }
  if ($Component -in @('All','Voice')) { $items+='dsh-fairy-voice-1.1.0.tgz' }
  if ($Component -in @('All','Orb')) { $items+='dsh-fairy-orb-1.1.0.tgz' }
  $packages=@($items | ForEach-Object { $p=Join-Path $PSScriptRoot $_; if (!(Test-Path -LiteralPath $p)) { throw "缺少插件包 $p，请完整解压插件 ZIP。" }; $p })
  $hashPath=Join-Path $PSScriptRoot 'SHA256SUMS.txt'
  if (!(Test-Path -LiteralPath $hashPath)) { throw '缺少 SHA256SUMS.txt，无法验证插件包。' }
  $hashes=@{}
  Get-Content -LiteralPath $hashPath -Encoding UTF8 | ForEach-Object { if ($_ -match '^([a-fA-F0-9]{64})\s+(.+)$') { $hashes[$matches[2]]=$matches[1] } }
  foreach($p in $packages) { $name=Split-Path $p -Leaf; if (!$hashes.ContainsKey($name) -or (Get-FileHash -LiteralPath $p -Algorithm SHA256).Hash -ne $hashes[$name]) { throw "SHA256 校验失败：$name" } }
  if (Test-Path -LiteralPath $profilePath) {
    $backup=Join-Path $profilePath ('backups\fairy-plugins-'+(Get-Date -Format yyyyMMdd-HHmmss-fff))
    New-Item -ItemType Directory -Path $backup -Force | Out-Null
    foreach($file in @('package.json','cordis.patch.yml','pnpm-lock.yaml','pnpm-workspace.yaml')) { $p=Join-Path $profilePath $file; if (Test-Path -LiteralPath $p) { Copy-Item -LiteralPath $p -Destination (Join-Path $backup $file) } }
    Write-Host "已备份 profile 元数据：$backup"
  }
  Write-Host "安装到 $homePath / profile $Profile。请先确保目标 DSH 已正常退出。"
  & $cli.Source plugin --profile $Profile add @packages
  if ($LASTEXITCODE -ne 0) { throw 'DSH 插件管理器安装失败，请查看上方错误；本脚本不会启动或结束任何程序。' }
  Write-Host '插件安装完成。不会自动启动语音服务或 DSH。'
  Write-Host "DSH_HOME=$homePath；启动命令：dsh --profile $Profile"
  if ($Component -in @('All','Voice')) { Write-Host '语音还需单独解压模型 ZIP，运行 voice-runtime\start_tts_portable.ps1。' }
} finally { $env:DSH_HOME=$oldHome }
