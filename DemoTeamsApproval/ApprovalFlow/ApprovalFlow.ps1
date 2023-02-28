param($Context)

# Context.Input is currently Newtonsoft.Json.Linq.JContainer, the values have to be explicitly cast to strings
$InstanceInfo = @{
    'InstanceId' = [string]$Context.InstanceId
    'BaseUrl' = [string]$Context.Input.BaseUrl
    'KeyQueryParameter' = [string]$Context.Input.KeyQueryParameter
    'WebhookUrl' = [string]$Context.Input.WebhookUrl
}

Invoke-DurableActivity -FunctionName 'RequestTeamsApproval' -Input $InstanceInfo

$ApproveEvent = Start-DurableExternalEventListener -EventName 'Approve' -NoWait
$RejectEvent = Start-DurableExternalEventListener -EventName 'Reject' -NoWait
$Timer = Start-DurableTimer -Duration (New-TimeSpan -Days 1) -NoWait

# Wait for the first event to happen (timer to expire, or external event)
$Result = Wait-DurableTask -Task @($Timer,$ApproveEvent,$RejectEvent) -Any
if ($Result -eq $ApproveEvent) {
    Stop-DurableTimerTask -Task $Timer
    Invoke-DurableActivity -FunctionName 'SendTeamsResponse' -Input @{ 'Action' = 'Approve'; 'WebhookUrl' = [string]$Context.Input.WebhookUrl }
}
elseif ($Result -eq $RejectEvent) {
    Stop-DurableTimerTask -Task $Timer
    Invoke-DurableActivity -FunctionName 'SendTeamsResponse' -Input @{ 'Action' = 'Reject'; 'WebhookUrl' = [string]$Context.Input.WebhookUrl }
}
elseif ($Result -eq $Timer) {
    Write-Error 'Timer expired!'
}