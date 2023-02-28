using namespace System.Net

# Starter is a DurableClient, contains runtime info
param($Request, $TriggerMetadata, $Starter)

$RequestInfo = @{
    'BaseUrl' = $Starter['baseUrl']
    'KeyQueryParameter' = $Starter['requiredQueryStringParameters']
    'WebhookUrl' = $env:WebhookUrl
}
$InstanceId = Start-DurableOrchestration -FunctionName 'ApprovalFlow' -InputObject $RequestInfo
Write-Information "Started orchestration with ID = '$InstanceId'"

$Response = New-DurableOrchestrationCheckStatusResponse -Request $Request -InstanceId $InstanceId
Push-OutputBinding -Name Response -Value $Response
