function New-ARAM {
    param (
        [switch]$AddChamp,
        [switch]$LastChamp
    )

    [string[]]$blue = New-Object int[] 15;
    [string[]]$red = New-Object int[] 15;
    [string[]]$blueBan = New-Object int[] 3;
    [string[]]$redBan = New-Object int[] 3;
    [hashtable]$champHash = Import-Clixml $PSScriptRoot\Champs.xml
    [int]$numChamps = $champHash.Count

    function Get-Champ {
        param (
            [int]$number = $numChamps
        )
        Get-Random -Maximum $numChamps
    }

    function Find-Champ {
        [CmdletBinding()]
        param (
            [string]$champName,
            [int]$number = $numChamps,
            [hashtable]$hash = $champHash
        )
        foreach($h in $hash.Keys) {
            if($hash[$h] -eq $champName){
                return $h;
            }
        }
    }

    function Remove-Champ {
        param (
            [string]$champName
        )
        [int]$champNumber = Find-Champ $champName
        $champHash.Remove($champNumber);
    }

    function Set-Champ {
        param (
            $array,
            [int]$index = 0,
            [int]$iteration = 5,
            [hashtable]$hash = $champHash
        )
        while ($index -lt $iteration) {
            $n = Get-Champ
            if ($hash[$n]) {
                $array[$index] = $hash[$n];
                $hash.Remove($n);
                $index++;
            } else {
            }
        }
    }

    function Get-LastChamp {
        param (
            [int]$number = $numChamps,
            [hashtable]$hash = $champHash
        )
        write-host "The last champ added was " $hash[($number - 1)]
        Write-Host "The current champion count is " $number
    }

    if ($LastChamp) {
        Get-LastChamp
        Break
    }

    function New-Champ {
        param (
            [int]$number = $numChamps,
            [hashtable]$hash = $champHash
        )
        $champName = read-host "What is the name of the new Champion?"
        $hash.Add($number, $champName)
        $hash | Export-Clixml $PSScriptRoot\Champs.xml
        Break
    }

    if ($addChamp) {
        New-Champ
    }

    $blueBan[0] = read-host "What Champion do you ban for Blue 1?"
    $redBan[0] = read-host "What Champion do you ban for Red 1?"   
    $redBan[1] = read-host "What Champion do you ban for Red 2?"   
    $blueBan[1] = read-host "What Champion do you ban for Blue 2?"   
    $blueBan[2] = read-host "What Champion do you ban for Blue 3?"   
    $redBan[2] = read-host "What Champion do you ban for Red 3?"
    
    foreach ($item in $blueBan) {
        Remove-Champ $item
    }
    foreach ($item in $redBan) {
        Remove-Champ $item
    }

    $blueChampHash = $champHash.Clone()
    $redChampHash = $champHash.Clone()

    Set-Champ $blue -iteration $blue.Count -hash $blueChampHash
    Set-Champ $red -iteration $red.Count -hash $redChampHash

    Write-Host ""
    write-host "Blue Team Initial Picks:"
    $blue[0..4]
    Write-Host ""
    Write-Host "Blue Team Bench:"
    $blue[5..14]

    Write-Host ""
    Write-Host ""
    write-host "Red Team Initial Picks:"
    $red[0..4]
    Write-Host ""
    Write-Host "Red Team Bench:"
    $red[5..14]
}
