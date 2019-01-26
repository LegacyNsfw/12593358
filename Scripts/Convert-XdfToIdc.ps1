param ($SourceXdf)

$builder = New-Object -TypeName "System.Text.StringBuilder";

$unused = $builder.AppendLine("static main() {")
$unused = $builder.AppendLine("auto nameFlags = 0;")

[xml]$xdf = Get-Content $SourceXdf

function Sanitize-Name
{
	Param($Input)

	$output = ""

	foreach ($c in $Input)
	{
	$c
		if ($c -eq " ")
		{
			$output += "_"
		}
		
		if ([System.Char]::IsLetter($c) -or [System.Char]::IsNumber($c))
		{
			$output += $c
		}
	}

	return $output
}

foreach ($flag in $xdf.XDFFORMAT.XDFFLAG)
{
	$name = "Flag " + $flag.mask + " " + $flag.title 
	$address = $flag.EMBEDDEDDATA.mmedaddress;
	$unused = $builder.AppendLine("MakeNameEx($address, `"$name`", nameFlags);")
}

foreach ($constant in $xdf.XDFFORMAT.XDFCONSTANT)
{
	$size = $constant.EMBEDDEDDATA.mmedelementsizebits
	$name = "Constant" + $size + " " + $constant.title 
	$address = $constant.EMBEDDEDDATA.mmedaddress;
	$unused = $builder.AppendLine("MakeNameEx($address, `"$name`", nameFlags);")
}

foreach ($table in $xdf.XDFFORMAT.XDFTABLE)
{
	$columns = $table.XDFAXIS[0].indexcount;
	$rows = $table.XDFAXIS[1].indexcount;

	if ($columns -eq 1)
	{
		if ($rows -eq 1)
		{
			$name = "" # this is a checksum 'table' and the name will be clear enough
		}
		else
		{
			$name = "CurveTable " + $rows + " Rows"
		}
	}
	else
	{
		if ($rows -eq 1)
		{
			$name = "CurveTable " + $columns + " Columns"
		}
		else 
		{
			$name = "SurfaceTable " + $columns + "x" + $rows
		}
	}

	$name = $name + " " + $table.title

	$address = $table.XDFAXIS[$table.XDFAXIS.Length - 1].EMBEDDEDDATA.mmedaddress;

	$unused = $builder.AppendLine("MakeNameEx($address, `"$name`", nameFlags);")
}

$unused = $builder.Append("}")

Out-File -FilePath ($SourceXdf + ".idc") -InputObject $builder.ToString() -Encoding ASCII