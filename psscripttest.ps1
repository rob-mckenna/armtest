param([string]$File)
$FileList = $File | Foreach-Object {$_.trim()}
$StorageAccount = Get-AzStorageAccount -ResourceGroupName $env:ResourceGroupName -Name $env:StorageAccountName -Verbose
$Count = 0
$DeploymentScriptOutputs = @{}
foreach ($FileName in $FileList) {
    Write-Host "Copying $FileName to $env:StorageContainerName in $env:StorageAccountName."
    #Invoke-RestMethod -Uri "https://raw.githubusercontent.com/Azure/azure-docs-json-samples/master/mslearn-arm-deploymentscripts-sample/$FileName" -outfile $FileName
    $Blob = Set-AzStorageBlobContent -File $FileName -Container $env:StorageContainerName -blob $FileName -context $StorageAccount.Context
    $DeploymentScriptOutputs[$FileName] = @{}
    $DeploymentScriptOutputs[$FileName]['Uri'] = $Blob.ICloudBlob.Uri
    $DeploymentScriptOutputs[$FileName]['StorageUri'] = $Blob.ICloudBlob.StorageUri
    $Count++
}
Write-Host "Finished copying $Count files."