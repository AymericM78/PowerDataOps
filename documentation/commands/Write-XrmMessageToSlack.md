# Command : `Write-XrmMessageToSlack` 

## Description

**Push message to slack** : Use Slack webhook to send current message in target channel.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
SlackUrl|String|1|false|$env:SLACKURL|Url to Slack webhook.
BotName|String|2|false|DevOps|User name for message sender.
Message|String|3|true||Message to send.
Emoji|String|4|false||Emoji to use as the icon for this message.


## Usage

```Powershell 
Write-XrmMessageToSlack [[-SlackUrl] <String>] [[-BotName] <String>] [-Message] <String> [[-Emoji] <String>] [<CommonParameters>]
``` 

## More informations

https://api.slack.com/methods/chat.postMessage


