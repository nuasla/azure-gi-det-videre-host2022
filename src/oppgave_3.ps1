$ErrorActionPreference = 'Stop' #Stopper skript hvis det dukker opp feil


$webRequest = Invoke-WebRequest -Uri 'http://nav-deckofcards.herokuapp.com/shuffle' #Henter kortstokk fra URL

$kortstokkJson = $webRequest.Content

$kortstokk = ConvertFrom-Json -InputObject $kortstokkJson <#en string som innholder json#>


foreach ($kort in $kortstokk) {
    Write-Output $kort
}