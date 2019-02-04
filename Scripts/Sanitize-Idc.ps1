$lines = [IO.File]::ReadAllLines("..\12593358.idc")

$builder = New-Object -TypeName "System.Text.StringBuilder";

foreach($line in $lines)
{
	if ((-not $line.StartsWith("//")) -and -not $line.Contains("ExtLinA"))
	{
		$unused = $builder.AppendLine($line)
	}
}

Out-File -FilePath ("..\12593358.sanitized.idc") -InputObject $builder.ToString() -Encoding ASCII