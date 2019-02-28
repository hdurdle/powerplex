# Obtain the Plex server token by logging in with Plex Credentials
# .\Get-PlexToken.ps1 | Set-Content -Path Plex.token
#
$url = "https://plex.tv/users/sign_in.xml"
$PlexCredential = Get-Credential
$headers = @{}
$headers.Add("X-Plex-Client-Identifier", "PowerPlex") | Out-Null
$headers.Add("X-Plex-Product", "PowerPlex") | Out-Null
$headers.Add("X-Plex-Version", $host.Version.Major) | Out-Null
[xml]$res = Invoke-RestMethod -Headers:$headers -Method Post -Uri:$url -Credential $PlexCredential
$token = $res.user.authenticationtoken
$token