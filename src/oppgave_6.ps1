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


foreach ($kort in $kortstokk) {
    Write-Output $kort
}

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


$meg = $kortstokk[0..1]

$kortstokk = $kortstokk[2..($kortstokk.Count -1)]

$magnus = $kortstokk[2..($kortstokk.Count -1)]
$kortstokk = $kortstokk[]


