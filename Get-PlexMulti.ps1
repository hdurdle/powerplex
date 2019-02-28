# Find media which has 2 or more files on the disk
# ./Get-PlexMulti.ps1 "Film"
#
param (
    [System.String]$Type = "tv" # default to TV
)
$query = .\Get-Plex.ps1 -Type $Type

if ($query.MediaContainer.title1 -eq "Film") {
    $keys = $query.MediaContainer.Metadata

    $totalMovies = $keys.Count
    Write-Host $totalMovies movies to check
    $keys | ForEach-Object -Begin { $i = 0} -Process {
        if ($_.Media.Count -gt 1) {$_.Media.Part.file} 
        $i = $i + 1
        Write-Progress -Activity "Finding $Type movies with duplicate files" -Status "Progress:" -PercentComplete ($i / $totalMovies * 100)
    }
}
else {
    $keys = $query.MediaContainer.Metadata.ratingKey
    $totalShows = $keys.Count
    Write-Host $totalShows shows to check
    $keys | ForEach-Object -Begin { $i = 0} -Process {
        (.\Get-Plex.ps1 -allEpisodes $_).MediaContainer.Metadata | ForEach-Object { if ($_.Media.Count -gt 1) {$_.Media.Part.file} } 
        $i = $i + 1
        Write-Progress -Activity "Finding $Type episodes with duplicate files" -Status "Progress:" -PercentComplete ($i / $totalShows * 100)
    }
}