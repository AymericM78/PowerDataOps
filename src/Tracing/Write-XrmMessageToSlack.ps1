<#
    .SYNOPSIS
    Push message to slack

    .DESCRIPTION
    Use Slack webhook to send current message in target channel.

    .PARAMETER SlackUrl
    Url to Slack webhook.

    .PARAMETER BotName
    User name for message sender.

    .PARAMETER Message
    Message to send.

    .PARAMETER Emoji
    Emoji to use as the icon for this message.
    
    .LINK
    https://api.slack.com/methods/chat.postMessage
#>
function Write-XrmMessageToSlack {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $false)]
        [String]
        $SlackUrl = $env:SLACKURL,
        
        [Parameter(Mandatory = $false)]	
        [String]
        $BotName = "DevOps",

        [Parameter(Mandatory = $true)]	
        [String]
        $Message,

        [Parameter(Mandatory = $false)]
        [String]
        $Emoji
    )
    process {
        
        if ($BotName -eq "DevOps") {
            # $projectName = $env:SYSTEM_TEAMPROJECT;
            
            if ($env:RELEASE_DEFINITIONNAME) {
                $BotName = "Release $($env:RELEASE_DEFINITIONNAME)";
            }
            elseif ($env:BUILD_DEFINITIONNAME) {
                $BotName = "Build $($env:BUILD_DEFINITIONNAME)";
            }
        }        
        
        $BodyTemplate = ConvertTo-Json @{
            username   = "$BotName"
            text       = "$Message"
            icon_emoji = "$Emoji"
        }

        Invoke-RestMethod -uri $SlackUrl -Method Post -body $BodyTemplate -ContentType 'application/json' | Out-Null;
    }
}

Export-ModuleMember -Function Write-XrmMessageToSlack -Alias *;