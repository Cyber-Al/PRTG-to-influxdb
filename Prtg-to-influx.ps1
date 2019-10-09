Import-Module Influx
Import-Module PRTGapi



function QueryPingSensors
{
Connect-PrtgServer URL (New-Credential "Username" "Password")
$metrics = Get-sensor ping

 foreach ($i in $metrics)
    {
        #$NameContat = $i.name.Trim("\")
        #$nameContat
        $AssetName = ""
        $StatusTemp = ""
        $assettemp = $i.Device
        $AssetName = $i.Device       
        $statusTemp = $i.Status

        $AssetName = switch($i.Device)
        {
        'ALI-P105 (192.168.32.104)' {'AP-105';break}
        default {"$assettemp";break}
        }
        
        if ($statusTemp -eq "Up")
        {
            $statusNum = 1
        }
        elseif ($statusTemp -eq "Down")
        {
            $statusNum = -1
        }
        else
        {
            $statusNum = 0
        }


        $InputMetric = @{
            AssetName = "$AssetName"
            Status = "$statusTemp"
            StatusNum = $statusNum
        }

        Write-Influx -Measure Status -Tags @{Hostname=$assettemp} -Metrics $InputMetric -Database PRTG -Server InfluxDB_server_URL -Verbose
    }
    Disconnect-PrtgServer
    }
    QueryPingSensors
    

