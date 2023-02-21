function New-ARAM {
    param (
        [switch]$NoBans
    )

    [string[]]$Blue = New-Object int[] 15;
    [string[]]$Red = New-Object int[] 15;
    [string[]]$Bans = New-Object int[] 6;
    $ChampList = (Invoke-RestMethod -Uri http://ddragon.leagueoflegends.com/cdn/13.1.1/data/en_US/champion.json).data
    [int]$NumChamps = ($champList.psobject.properties | Measure-Object).Count

    function Remove-Champ {
        param (
            [string]$champName,
            $champs
        )
        $champs.psobject.properties.Remove($champName);
    }

    function Set-Champ {
        param (
            $array,
            [int]$index = 0,
            [int]$iteration = 5,
            $champs
        )
        while ($index -lt $iteration) {
            $champ = $champs.psobject.properties | Select-Object -Index (Get-Random -Maximum $numChamps)
            if($champ) {    
                $array[$index] = $champ.Value.Name;
                Remove-Champ -champName $champ.Name -champs $champs;
                $index++;
            }
        }
    }

    if (!$NoBans) {
        $Bans[0] = read-host "What Champion do you ban for Blue 1?";
        $Bans[1] = read-host "What Champion do you ban for Red 1?";
        $Bans[2] = read-host "What Champion do you ban for Red 2?";
        $Bans[3] = read-host "What Champion do you ban for Blue 2?";   
        $Bans[4] = read-host "What Champion do you ban for Blue 3?";   
        $Bans[5] = read-host "What Champion do you ban for Red 3?";  
        
        foreach ($champ in $Bans) {
            Remove-Champ -champName $champ -champs $champList;
        }
    }
    
    $BlueChampList = $ChampList.psobject.Copy();
    $RedChampList = $ChampList.psobject.Copy();
    
    Set-Champ $Blue -iteration $Blue.Count -champs $BlueChampList
    Set-Champ $Red -iteration $Red.Count -champs $RedChampList

    Clear-Host

    Write-Host "";
    write-host "Blue Team Initial Picks:";
    $blue[0..4];
    Write-Host "";
    Write-Host "Blue Team Bench:";
    $blue[5..14];

    Write-Host "";
    Write-Host "";
    write-host "Red Team Initial Picks:";
    $red[0..4];
    Write-Host "";
    Write-Host "Red Team Bench:";
    $red[5..14];
}
