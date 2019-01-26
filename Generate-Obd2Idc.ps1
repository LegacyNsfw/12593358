param($Path)

$bytes = [System.IO.File]::ReadAllBytes("12593358.bin")
$baseAddress = [Convert]::ToUInt16("1F70", 16);

$lines = [IO.File]::ReadAllLines(".\pidlist.txt")

$pids = @{}
foreach($line in $lines)
{
	$parts = $line.Split(' ', 2);
	$name = $parts[1] -replace '[^a-zA-Z]'
	$pids.Add($parts[0], $name);		
}

write-output "static main() {"

foreach ($index in 0..308)
{
	$start = $baseAddress + (8 * $index);

#	write-host $index $start.ToString("X4")

	$parameterId = $bytes[$start] * 256
	$parameterId += $bytes[$start+1]

	$functionAddress = $bytes[$start+5] * 256 * 256
	$functionAddress += $bytes[$start+6] * 256
	$functionAddress += $bytes[$start+7]

	$parameterIdString = $parameterId.ToString("X4")
	$pidName = $pids[$parameterIdString]
	$functionName = "GetPid_" + $parameterIdString

	if (-not [string]::IsNullOrEmpty($pidName))
	{
		$functionName += "_" + $pidName
	}

	$idc = "MakeNameEx(0x" + $functionAddress.ToString("X6") + ", `"$functionName`", 0);"
	write-output $idc
}

write-output "}"