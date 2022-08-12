# Get Access Token
$clientId = "3744a5c5d4ca4731a2abdbc8ec12f05f"
$secret = 'kahP2k65BVoz77OxQb25wy6BN5OTCHeS'
$Url = "https://eu.api.blizzard.com/data/wow/token/?namespace=dynamic-eu"

Add-Type -AssemblyName System.Web
$encodedSecret = [System.Web.HttpUtility]::UrlEncode($secret)
$uri = "https://eu.battle.net/oauth/token"

$body = "grant_type=client_credentials&client_id=$clientId&client_secret=$encodedSecret"
$tokenRequest = Invoke-RestMethod -Method Post -Uri $uri -Body $body -ContentType "application/x-www-form-urlencoded"

# Get data with token

IF ($tokenRequest.expires_in -gt 1) 
    {
        $token = $tokenRequest.access_token
        $header = @{
        Authorization = "Bearer $token"
        }
        $wowTokenData = Invoke-RestMethod -Uri $Url –Method GET -Headers $header
        $latestItem = ($wowTokenData|Sort-Object endTime -Descending)[0]
        $exportFileName = 'c:\tmp\wowTokenPriceEu_' + [DateTime]::Now.ToString("yyyyMMdd-HHmmss") + '.json'
        $latestItem | Select-Object "last_updated_timestamp", "price" | ConvertTo-Json | Set-Content $exportFileName
     }
        
ELSE {$exportFileName = 'c:\tmp\wowTokenPriceEu_' + [DateTime]::Now.ToString("yyyyMMdd-HHmmss") + '.json'
"{ELSE block redirect}" > $exportFileName
      }