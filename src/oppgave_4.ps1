[CmdletBinding()]
param (
    [Parameter(HelpMessage = "URL til kortstokk", Mandatory = $false)]
    [string]
    $UrlKortstokk = 'http://nav-deckofcards.herokuapp.com/shuffle'
)

$ErrorActionPreference = 'Stop' #Stopper skript hvis det dukker opp feil

$webRequest = Invoke-WebRequest -Uri "$UrlKortstokk" #Henter kortstokk fra URL

$kortstokkJson = $webRequest.Content

$kortstokk = ConvertFrom-Json -InputObject $kortstokkJson <#en string som innholder json#>


foreach ($kort in $kortstokk) {
    Write-Output $kort
}


