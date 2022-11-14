[CmdletBinding()]
param (
    [Parameter(HelpMessage = "URL til kortstokk", Mandatory = $false)]
    [string]
    $UrlKortstokk = 'http://nav-deckofcards.herokuapp.com/shuffle'
)

$ErrorActionPreference = 'Stop' #Stopper skript hvis det dukker opp feil

$webRequest = Invoke-WebRequest -Uri "$UrlKortstokk" #Henter kortstokk fra URL

$kortstokkJson = $webRequest.Content

$kortstokk = ConvertFrom-Json -InputObject $kortstokkJson

function skrivKortstokk {
    param (
        [object[]]
        $kortstokk
    )
    
    foreach ($kort in $kortstokk) {
        Write-Output "$($kort.suit.substring(0,1))$($kort.value)"
    }
} 

#skrivKortstokk($kortstokk)

<# function sumPoengKortstokk {
    [OutputType([int])]
    param (
        [object[]]
        $kortstokk
    )

    $poengKortstokk = 0

    foreach ($kort in $kortstokk) {
        $poengKortstokk += switch ($kort.value) {
            { $_ -cin @('J', 'K', 'Q') } { 10 }
            'A' { 11 }
            default { $kort.value }
        }
    }
    return $poengKortstokk
}
 #>
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

#Write-Output "Poengsum: $(KortVerdi -kortstokk $kortstokk)"

$meg = $kortstokk[0..1]

#Write-Output "Meg: "
    #skrivKortstokk($meg)

$kortstokk = $kortstokk[2..($kortstokk.Count -1)]

$magnus = $kortstokk[0..1]

#Write-Output "Magnus: "
    #skrivKortstokk($magnus)

$kortstokk = $kortstokk[2..($kortstokk.Count -1)]


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


$blackjack = 21

$Megverdi = KortVerdi -kortstokk $meg
$Magnusverdi = KortVerdi -kortstokk $magnus



if ($Megverdi -eq $blackjack) {
    skrivUtResultat -vinner "meg" -kortStokkMagnus $magnus -kortStokkMeg $meg 
    
}
elseif ($Magnusverdi -eq $blackjack) {
    skrivUtResultat -vinner "magnus" -kortStokkMagnus $magnus -kortStokkMeg $meg
    
}

else  {
    skrivUtResultat -vinner "Ingen vinner!" -kortStokkMagnus $magnus -kortStokkMeg $meg
    
}
