$stopString = "\*\*\*\*\*\*\*\*\*\*\*\* ERROR \*\*\*\*\*\*\*\*\*\*\*\*"
$stop = $false
$ansiRegex = "\x1b\[[0-9;]*m"
$errorRegex = "^(.+?):(\d+)"
$contextCount = 3
function GetSourceContext {
	param (
		[Parameter(Mandatory=$true)] [string]$FilePath,
		[Parameter(Mandatory=$true)] [int]$LineNumber,
		[int]$Context = 2
	)
	if (-not (Test-Path $FilePath)) { return $null }
	try {
		$content = (Get-Content -Path $fileName -ErrorAction Stop)
		$maxIdx = $content.Count - 1
		$targetIdx = $lineNum - 1
		if ($targetIdx -lt 0 -or $targetIdx -gt $maxIdx) { return $null }
		$linesToPrint = @()
		$found = 0
		$curr = $targetIdx - 1
		while ($found -lt $contextCount -and $curr -ge 0) {
			if (-not [string]::IsNullOrWhiteSpace($content[$curr])) {
				$linesToPrint += [PSCustomObject]@{ Num = $curr + 1; Text = $content[$curr]; IsTarget = $false }
				$found++
			}
			$curr--
		}
		$linesToPrint += [PSCustomObject]@{ Num = $targetIdx + 1; Text = $content[$targetIdx]; IsTarget = $true }
		$found = 0
		$curr = $targetIdx + 1
		while ($found -lt $contextCount -and $curr -le $maxIdx) {
			if (-not [string]::IsNullOrWhiteSpace($content[$curr])) {
				$linesToPrint += [PSCustomObject]@{ Num = $curr + 1; Text = $content[$curr]; IsTarget = $false }
				$found++
			}
			$curr++
		}
		return ($linesToPrint | Sort-Object Num | ForEach-Object {
			$marker = if ($_.IsTarget) { " >" } else { "  " }
			$color = if ($_.IsTarget) { "Gray" } else { "DarkGray" }
			[PSCustomObject]@{
				text = "{0}{1,4} | {2}" -f $marker, $_.Num, $_.Text
				isTarget = $_.IsTarget
			}
		})
	}
	catch {
		Write-Host "Error retrieving file content" -ForegroundColor DarkMagenta
		return $null
	}
}
function FormatOutput {
	param (
		$file
	)
	& fteqcc $file *>&1 | ForEach-Object {
	# skip lines after ************ ERROR ************
		if ($_ -is [System.Management.Automation.ErrorRecord]) {
			$line = $_.Exception.Message
		} else {
			$line = "$_"
		}
		$line = $line -replace $ansiRegex, ''
		if ($line -match $stopString) {
			$stop = $true
		}
		if ($stop) { return }
		if ([string]::IsNullOrWhiteSpace($line)) { return }
		# Skip redundant lines
		if ($line -match '^(compiling|writing|done)') { return }
		if ($line -match '^(prototyping|outputfile|FTEQCC)') { return }
		$sourceContext = @()
		if ($line -match $errorRegex) {
			$fileName = $Matches[1]
			$lineNum = [int]$Matches[2]
			$sourceContext = GetSourceContext -Filepath $fileName -LineNumber $linenum -Context $contextLines
		}
		# Color by : Check for keywords and color accordingly
		if ($line -match 'error:') {
			# $line = "$line"
			Write-Host $line -ForegroundColor Red
			if ($sourceContext) {
				$sourceContext | ForEach-Object { if ($_.isTarget) {Write-Host $_.text -ForegroundColor Gray} else {Write-Host $_.text -ForegroundColor DarkGray} }}
		}
		elseif ($line -match 'Statement does not do anything') {
			$line = $line -replace 'Statement does not do anything', 'Statement does nothing'
			# $line = "  $line"
			Write-Host $line -ForegroundColor Yellow
			
			if ($sourceContext) { $sourceContext | ForEach-Object { if ($_.isTarget) {Write-Host $_.text -ForegroundColor Gray} else {Write-Host $_.text -ForegroundColor DarkGray} }}
		}
		elseif ($line -match 'warning:|warning Q') {
			# $line = "  $line"
			Write-Host $line -ForegroundColor Yellow
			if ($sourceContext) { $sourceContext | ForEach-Object { if ($_.isTarget) {Write-Host $_.text -ForegroundColor Gray} else {Write-Host $_.text -ForegroundColor DarkGray} }}
		}
		elseif ($line -match 'in function') {
			$line = $line -replace 'in function', 'Issues in function'
			Write-Host $line
		}
		elseif ($line -match 'source file') {
			$line = $line -replace 'source file: ', ''
			Write-Host $line
		}
		elseif ($line -match 'compile finished') {
			$line = $line -replace 'compile finished:', 'Success! Wrote'
			Write-Host $line -ForegroundColor Green
		}
		else {
			Write-Host $line
		}
	}
}
Write-Host ""
FormatOutput progs.src
Write-Host ""
FormatOutput csprogs.src
Write-Host ""
$game = Split-Path $PSScriptRoot -Leaf
$quake = "D:\SteamLibrary\steamapps\common\Quake\rerelease"
$path = Join-Path -Path $quake -ChildPath $game
try {
	$result = ni -Path $path -ItemType Directory -Force
} catch { Write-Error $_ }
cp progs.dat -Destination $path
cp csprogs.dat -Destination $path
cp quake.rc -Destination $path
cp weapons.rc -Destination $path
cp effectinfo.txt -Destination $path