[CmdletBinding()]
param (
    [Parameter(HelpMessage = "URL til kortstokk", Mandatory = $false)]
    [string]
    $UrlKortstokk = 'http://nav-deckofcards.herokuapp.com/shuffle'
    )
    
    $ErrorActionPreference = 'Stop' #Stopper skript hvis det dukker opp feil
    
    
    
function skrivKortstokk {
    param (
        [object[]]
        $kortstokk
    )
    
    foreach ($kort in $kortstokk) {
        Write-Output "$($kort.suit.substring(0,1))$($kort.value)"
    }
} 

function KortVerdi {
    param (
        [object[]]
        $kortstokk 
    )    
    $bildekort = @{A=11; J=10; K=10; Q=10;}
    $sumkort = 0
    
    foreach ($kort in $kortstokk){
        # summerer kortstokk
        if ($bildekort.ContainsKey($kort.value)) {
            $sumkort = $sumkort + $($bildekort[$kort.value])
            #Her plusser den på bildekort verdi.
        }
        
        else {
            $sumkort = $sumkort + $kort.value
        }
    }
    return $sumkort
}

function skrivUtResultat {
    param (
        [string]
        $vinner,        
        [object[]]
        $kortStokkMagnus,
        [object[]]
        $kortStokkMeg        
    )
    Write-Output "magnus | $(KortVerdi -kortstokk $kortStokkMagnus) | $(skrivKortstokk -kortstokk $kortStokkMagnus)"
    Write-Output "meg    | $(KortVerdi -kortstokk $kortStokkMeg) | $(skrivKortstokk -kortstokk $kortStokkMeg)"
    Write-Output "Vinner: $vinner"

}

$webRequest = Invoke-WebRequest -Uri "$UrlKortstokk" 

$kortstokkJson = $webRequest.Content

$kortstokk = ConvertFrom-Json -InputObject $kortstokkJson

$meg = $kortstokk[0..1]

$kortstokk = $kortstokk[2..($kortstokk.Count -1)]

$magnus = $kortstokk[0..1]

$kortstokk = $kortstokk[2..($kortstokk.Count -1)]

$blackjack = 21

$Megverdi = KortVerdi -kortstokk $meg

$Magnusverdi = KortVerdi -kortstokk $magnus


while ($Megverdi -lt 17) {
    $meg = $meg + $kortstokk[0]
    $kortstokk = $kortstokk[1..($kortstokk.Count -1)] #Setter kortstokk=kortstokk minus det første kortet
    $Megverdi = KortVerdi -kortstokk $meg
}

while ($Magnusverdi -lt 17) {
    $Magnus = $Magnus + $kortstokk[0]
    $kortstokk = $kortstokk[1..($kortstokk.Count -1)] #Setter kortstokk=kortstokk minus det første kortet
    $Magnusverdi = KortVerdi -kortstokk $Magnus
}

if ($Megverdi -eq $blackjack) {
    skrivUtResultat -vinner "Meg | Blackjack" -kortStokkMagnus $magnus -kortStokkMeg $meg 
}

elseif ($Magnusverdi -eq $blackjack) {
    skrivUtResultat -vinner "Magnus | Blackjack" -kortStokkMagnus $magnus -kortStokkMeg $meg
}

elseif ($Megverdi -gt $blackjack -and $Magnusverdi -lt $blackjack) {
    skrivUtResultat -vinner "Magnus" -kortStokkMagnus $magnus -kortStokkMeg $meg
}

elseif ($Magnusverdi -gt $blackjack -and $Megverdi -lt $blackjack) {
    skrivUtResultat -vinner "Meg" -kortStokkMagnus $magnus -kortStokkMeg $meg
}

elseif ($Magnusverdi -gt $Megverdi) {
    skrivUtResultat -vinner "Magnus" -kortStokkMagnus $magnus -kortStokkMeg $meg
}

elseif ($Megverdi -gt $Magnusverdi) {
    skrivUtResultat -vinner "Meg" -kortStokkMagnus $magnus -kortStokkMeg $meg
}

elseif ($Megverdi -eq $Magnusverdi) {
    skrivUtResultat -vinner "Draw!!!!!" -kortStokkMagnus $magnus -kortStokkMeg $meg
}

else  {
    skrivUtResultat -vinner "Ingen vinner!" -kortStokkMagnus $magnus -kortStokkMeg $meg
}

