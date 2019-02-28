# Get names of Plex Libraries
# .\Get-PlexSections.ps1
#

# -----------------------------------------------------------------------------------------
$plexConfig = Get-Content -Path .\Plex.config | ConvertFrom-Json
$plexServer = $plexConfig.server
$token = Get-Content -Path Plex.token # Use Get-PlexToken to get this
# -----------------------------------------------------------------------------------------

$plexUri = "http://$plexServer/library/sections/"

$headers = @{}
$headers.Add("accept", "application/json") | out-null
$headers.Add("X-Plex-Client-Identifier", "PowerPlex") | Out-Null
$headers.Add("X-Plex-Product", "PowerPlex") | Out-Null
$headers.Add("X-Plex-Version", $host.Version.Major) | Out-Null
$headers.Add("X-Plex-Token", $token) | Out-Null
$plexJson = Invoke-RestMethod -Uri $plexUri -Headers $headers
$plexJson.MediaContainer.Directory | Select-Object -Property title, key