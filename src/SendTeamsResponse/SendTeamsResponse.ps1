param($RequestInfo)

# Set up common parameters as hashtable for splatting
$Params = @{
    Uri = $RequestInfo.WebhookUrl
    ContentType = 'application/json'
    Method = 'Post'
}

# Add body to hashtable based on Action
switch ($RequestInfo.Action) {
    'Approve' {
        Write-Information "Approved!"
        $Params['Body'] = [string](Get-Content .\SendTeamsResponse\ApprovedMessage.json)
    }
    'Reject' {
        Write-Information "Rejected!"
        $Params['Body'] = [string](Get-Content .\SendTeamsResponse\RejectedMessage.json)
    }
    default { throw 'Invalid Action!' }
}

# Send prepared request to Teams webhook
Invoke-RestMethod @Params