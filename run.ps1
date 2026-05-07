$engine = "D:\Games\vkQuake\vkQuake.exe"
$basedir = "D:\SteamLibrary\steamapps\common\Quake\rerelease"
$game = Split-Path $PSScriptRoot -Leaf
$path = Join-Path -Path $basedir -ChildPath $game

& $engine -multiuser -basedir $basedir -game $game