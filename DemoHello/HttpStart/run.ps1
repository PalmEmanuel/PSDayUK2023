using namespace System.Net

param($Request, $TriggerMetadata, $starter)

$Starter | ConvertTo-Json | Write-Information

$FunctionName = $Request.Params.FunctionName
$InstanceId = Start-DurableOrchestration -FunctionName $FunctionName
Write-Host "Started orchestration with ID = '$InstanceId'"

$Response = New-DurableOrchestrationCheckStatusResponse -Request $Request -InstanceId $InstanceId
Push-OutputBinding -Name Response -Value $Response