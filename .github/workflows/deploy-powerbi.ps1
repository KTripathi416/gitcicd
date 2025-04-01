# Power BI Authentication Parameters
$tenantId = $env:TENANT_ID
$clientId = $env:CLIENT_ID
$clientSecret = $env:CLIENT_SECRET

# Power BI Token Request URL
$tokenUrl = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"

# Request Body
$body = @{
    grant_type    = "client_credentials"
    client_id     = $clientId
    client_secret = $clientSecret
    scope         = "https://graph.microsoft.com/.default"
} 

# Convert to JSON and Request Token
$tokenResponse = Invoke-RestMethod -Uri $tokenUrl -Method Post -ContentType "application/x-www-form-urlencoded" -Body $body
$accessToken = $tokenResponse.access_token

# Validate Token
if ($null -eq $accessToken) {
    Write-Host "Error: Failed to retrieve access token"
    exit 1
} else {
    Write-Host "Successfully retrieved access token"
}

# Deploy the Power BI Report (Modify as needed)
$workspaceId = "your_powerbi_workspace_id"
$reportFilePath = "Reports/your_report.pbix"

$headers = @{
    "Authorization" = "Bearer $accessToken"
    "Content-Type"  = "multipart/form-data"
}

# Upload Report to Power BI
Invoke-RestMethod -Uri "https://api.powerbi.com/v1.0/myorg/groups/$workspaceId/imports?datasetDisplayName=Report&nameConflict=Overwrite"
