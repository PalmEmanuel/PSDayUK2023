param($RequestInfo)

# Assemble url for raiseEvent endpoint
$ApprovalUrl = "$($RequestInfo['BaseUrl'])/instances/$($RequestInfo['InstanceId'])/raiseEvent/Approve?$($RequestInfo['KeyQueryParameter'])"
$RejectUrl = "$($RequestInfo['BaseUrl'])/instances/$($RequestInfo['InstanceId'])/raiseEvent/Reject?$($RequestInfo['KeyQueryParameter'])"
Write-Information "Approve event URL: $ApprovalUrl"

# Set up common parameters as hashtable for splatting
$Params = @{
    Uri = $RequestInfo['WebhookUrl']
    ContentType = 'application/json'
    Method = 'Post'
    Body = (Get-Content .\RequestTeamsApproval\ApprovalRequestCard.json) -replace '{{approve-url}}',$ApprovalUrl -replace '{{reject-url}}',$RejectUrl
}

# Send prepared request to Teams webhook
Invoke-RestMethod @Params