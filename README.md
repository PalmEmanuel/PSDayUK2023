# PSDayUK 2023

This is the repo for my presentation **Code Orchestration with Durable Azure Functions** at PSDayUK 2023 with demo code showcasing a Teams Approval flow using a webhook.

The following tools are required or recommended to run the demos:
- [Azure Function Core Tools](https://learn.microsoft.com/en-us/azure/azure-functions/functions-run-local#install-the-azure-functions-core-tools)
- [Visual Studio Code](https://aka.ms/vscode)
- [Visual Studio Code Extension - Azurite](https://marketplace.visualstudio.com/items?itemName=Azurite.azurite)
- [Visual Studio Code Extension - Azure Functions](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurefunctions)
- [Visual Studio Code Extension - Durable Functions Monitor](https://marketplace.visualstudio.com/items?itemName=DurableFunctionsMonitor.durablefunctionsmonitor)

For intellisense when working with Azure Functions, import the PowerShellWorker (for PS 7.2, can be modified) module locally.

```powershell
# Find the 'func' command from the Azure Function Core Tools
# Use the source of the command and recursively find the 7.2 PowerShell folder
# Find and import PowerShellWorker module, first import compiled .dll module, then import the .psd1 manifest file including script .psm1 module
Get-ChildItem "$(Split-Path (Get-Command 'func').Source -Parent)\*\7.2" -Recurse | Get-ChildItem -Recurse -Filter 'Microsoft.Azure.Functions.PowerShellWorker*' -File | Where-Object { $_.Extension -in '.dll','.psd1' } | Import-Module
```

## DemoHello

A demo based on the Durable Functions that the VS Code Extension for Azure Functions creates.

## DemoHelloNetherite

A demo based on the Durable Functions that the VS Code Extension for Azure Functions creates, but where the storage provider is changed to Netherite.

Uses the option `SingleHost` for Netherite local development.

## DemoTeamsApproval

A demo where the orchestrator sends a card to Microsoft Teams using a configured Incoming Webhook to ask for approval or rejection, with the option of timeout after 1 day.

Uses an application setting called `WebhookUrl` with the URL to the Teams webhook.