import-module au

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
        }
        "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
        }
     }
}

function global:au_GetLatest {

    # Unfortunately, they're including a Byte Order Mark, so we have to trim that off
    $response = Invoke-RestMethod -Uri "https://download.lenovo.com/ibmdl/pub/pc/pccbbs/agent/SSClientCommon/HelloLevel_9_34_00.xml"
    $xml = [xml] $response.Substring(3)
    $version = $xml.LevelDescriptor.Version

    $Latest = @{
        URL32 = "https://download.lenovo.com/pccbbs/thinkvantage_en/systemupdate$($version).exe";
        ReleaseNotes = "https://download.lenovo.com/pccbbs/thinkvantage_en/systemupdate$($version).txt"
        Version = $version 
    }
    return $Latest
}

update
