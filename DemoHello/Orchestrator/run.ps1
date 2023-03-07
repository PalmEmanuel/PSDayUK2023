param($Context)

$Context | ConvertTo-Json | Write-Information

$Tasks = @()

$Tasks += Invoke-DurableActivity -FunctionName 'Hello' -Input 'Tokyo' -NoWait
$Tasks += Invoke-DurableActivity -FunctionName 'Hello' -Input 'Seattle' -NoWait
$Tasks += Invoke-DurableActivity -FunctionName 'Hello' -Input 'London' -NoWait

Wait-DurableTask -Task $Tasks
