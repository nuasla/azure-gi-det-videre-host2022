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
        Write-Output $kort
        
    }        
} 

skrivKortstokk($kortstokk)

function sumPoengKortstokk {
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

Write-Output "Poengsum: $(sumPoengKortstokk -kortstokk $kortstokk)"
Write-Output ""

$meg = $kortstokk[0..1]

Write-Output "Meg: "
    skrivKortstokk($meg)

$kortstokk = $kortstokk[2..($kortstokk.Count -1)]

$magnus = $kortstokk[0..1]

Write-Output "Magnus: "
    skrivKortstokk($magnus)

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
    Write-Output "Mine kort:"
    skrivKortstokk($kortStokkMeg)
Write-Output "Magnus sine kort:"
skrivKortstokk($kortStokkMagnus)
Write-Output "Vinner er:" $vinner

}

$blackjack = 21


if ((sumPoengKortstokk -kortstokk $meg) -eq $blackjack) {
    skrivUtResultat -vinner "meg" -kortStokkMagnus $magnus -kortStokkMeg $meg 
    
}
elseif ((sumPoengKortstokk -kortstokk $magnus) -eq $blackjack) {
    skrivUtResultat -vinner "magnus" -kortStokkMagnus $magnus -kortStokkMeg $meg
    
}
