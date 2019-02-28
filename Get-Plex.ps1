# Query Plex media library
# ./Get-Plex.ps1 -Type "TV"
#
param (
    [string]$resolution,
    [string]$title,
    [string]$year,
    [string]$addedAt,
    [string]$search,	
    [System.String]$Type,	
    [string]$allEpisodes,
    [switch]$originalTitle,
    [switch]$nowPlaying,
    [switch]$history
)
# -----------------------------------------------------------------------------------------
$plexConfig = Get-Content -Path .\Plex.config | ConvertFrom-Json
$plexSections = ./Get-PlexSections.ps1
$plexServer = $plexConfig.server
$token = Get-Content -Path Plex.token # Use Get-PlexToken to get this
# -----------------------------------------------------------------------------------------

if ($nowPlaying) {
    $plexUri = "http://" + $plexServer + "/status/sessions"
}
elseif ($search.length -gt 0) {
    $plexUri = "http://" + $plexServer + "/search/?query=" + $search
}
elseif ($history) {
    $plexUri = "http://" + $plexServer + "/status/sessions/history/all"
}
else {	
    # title search

    $section = ($plexSections | Where-Object { $_.title -eq $Type }).key
    if (-Not $section) { $section = 1 }

    if ($addedAt.length -gt 0) {
        $querystring = ""
        $date1 = (Get-Date -Date "01/01/1970")
        $date2 = (Get-Date -Date $addedAt)
        $addedAt = (New-TimeSpan -Start $date1 -End $date2).TotalSeconds
    }
	
    if ($title.length -gt 0) {
        $querystring += "title=$title"
    }
	
    if ($resolution.length -gt 0) {
        $querystring += "resolution=$resolution"
    }
	
    if ($year.length -gt 0) {
        $querystring += "year=$year"
    }
	
    if ($originalTitle) {
        $querystring += "originalTitle!=$title"
    }
	
    if ($addedAt.length -gt 0) {
        $querystring += "addedAt>=$addedAt"
    }

    $plexUri = "http://$plexServer/library/sections/$section/all"
	
    if ($querystring.length -gt 0) {
        $plexUri += "?$querystring"
    }
	
    if ($allEpisodes.length -gt 0) {
        $plexUri = "http://$plexServer/library/metadata/$allEpisodes/allLeaves"
    }
}
$headers = @{}
$headers.Add("accept", "application/json") | out-null
$headers.Add("X-Plex-Client-Identifier", "PowerPlex") | Out-Null
$headers.Add("X-Plex-Product", "PowerPlex") | Out-Null
$headers.Add("X-Plex-Version", $host.Version.Major) | Out-Null
$headers.Add("X-Plex-Token", $token) | Out-Null
$plexJson = Invoke-RestMethod -Uri $plexUri -Headers $headers
$plexJson