#Requires -Version 5.1
param(
  [switch]$Baseline,
  [switch]$Spinal,
  [switch]$BuildOnly
)
$ErrorActionPreference = "Stop"
$repo = Split-Path -Parent $PSScriptRoot
if (-not $Baseline -and -not $Spinal) { $Spinal = $true }
$args2 = @()
if ($Baseline) { $args2 += "--baseline" }
if ($Spinal) { $args2 += "--spinal" }
if (-not $BuildOnly) { $args2 += "--run" }
Write-Host "RUN: python simulation/sim_ddr.py $($args2 -join ' ')"
& python "$repo\simulation\sim_ddr.py" @args2
exit $LASTEXITCODE
