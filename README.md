# PowerPlex
PowerShell scripts for querying Plex media libraries

## Getting Started

Copy `Plex.config-dist` to `Plex.config` and add your server host and port in the format: `plex.your.local:32400`

To put the Plex token where the scripts can see it run: 

`.\Get-PlexToken.ps1 | Set-Content -Path Plex.token`

You're all set.


## Examples

### Find Media with duplicate files
Useful if you have multiple copies of a file when you have acquired different quality media over time. Find the ones you don't need any more.

```powershell
> .\Get-PlexMulti.ps1 Film
2567 movies to check
\\film\w\Ralph Breaks the Internet (2018)\Ralph.Breaks.the.Internet.2018.1080p.WEB-DL.DD5.1.H264.mkv
\\film\w\Ralph Breaks the Internet (2018)\Ralph.Breaks.the.Internet.2018.1080p.BluRay.x264.mkv
```

Quotes are only needed if your library name has spaces.

### Find Media with a specific resolution
To find all the 720p files in your Film library:

```powershell
> $lowRes = .\Get-Plex.ps1 -Type Film -resolution 720
> $lowRes.MediaContainer.Metadata.Count
482
> $lowRes.MediaContainer.Metadata.title
  ... will list all titles ...
```

### Now Playing
See what is being played from the server right now.

```powershell
$result = .\Get-Plex.ps1 -nowPlaying
```

Look in `$result.MediaContainer.MetaData` for the details.

### Explore your TV library

```powershell
> $tvResult = .\Get-Plex -Type TV
> $tvResult.MediaContainer.Metadata.Count
529
> $tvResult.MediaContainer.Metadata[9]

ratingKey             : 17034
key                   : /library/metadata/17034/children
studio                : NBC
type                  : show
title                 : The A-Team
titleSort             : A-Team
contentRating         : TV-PG
summary               : The A-Team is about a group of ex-United States Army Special Forces personnel who work as
                        soldiers of fortune, while on the run from the Army after being branded as war criminals for a
                        crime they did not commit.
index                 : 1
rating                : 7.8
year                  : 1983
thumb                 : /library/metadata/17034/thumb/1459134967
art                   : /library/metadata/17034/art/1459134967
banner                : /library/metadata/17034/banner/1459134967
theme                 : /library/metadata/17034/theme/1459134967
duration              : 2700000
originallyAvailableAt : 1983-01-23
leafCount             : 98
viewedLeafCount       : 98
childCount            : 5
addedAt               : 1070726903
updatedAt             : 1459134967
Genre                 : {@{tag=Action}, @{tag=Adventure}}
Role                  : {@{tag=George Peppard}, @{tag=Dirk Benedict}, @{tag=Mr. T}}

> $tvResult.MediaContainer.Metadata | Where-Object {$_.studio -eq "NBC"} | select title

title
-----
30 Rock
The A-Team
... will list all matching titles ...

```

### Grab your Film library

```powershell
> $filmResult = .\Get-Plex.ps1 -Type Film
> $filmResult.MediaContainer.Metadata.Count
2567
> $filmResult.MediaContainer.Metadata[115].title
The Andromeda Strain
> $filmResult.MediaContainer.Metadata[115].Media  # get the details of the media file itself

videoResolution : 1080
id              : 803
duration        : 7837461
bitrate         : 11060
width           : 1920
height          : 816
aspectRatio     : 2.35
audioChannels   : 2
audioCodec      : dca-ma
videoCodec      : h264
container       : mkv
videoFrameRate  : 24p
audioProfile    : ma
videoProfile    : high
Part            : {@{id=808; key=/library/parts/808/1403025933/file.mkv; duration=7837461;
                  file=\\path\to\film\a\The Andromeda Strain
                  (1971)\The.Andromeda.Strain.1971.mkv; size=10835482508;
                  audioProfile=ma; container=mkv; indexes=sd; videoProfile=high}}
```
Explore the contents of `MediaContainer` and `Metadata` - everything Plex knows about your media is in there!
