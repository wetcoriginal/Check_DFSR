# @wetcoriginal
# /!\
# Définissez les variables au préalable ci dessous
# /!\
$groupName = "Groupe_IIS-01_IIS-02"
$sourceServer = "IIS-01"
$destinationServer = "IIS-02"
$replicatedFolderPath = "C:\temp"
$testFileName = "dfs_test_file.txt"
$testFileContent = "Test de réplication DFS"
#
#
$testFilePath = Join-Path $replicatedFolderPath $testFileName

# Création du fichier de test sur le serveur source
Invoke-Command -ComputerName $sourceServer -ScriptBlock {
    param($path, $content)
    Set-Content -Path $path -Value $content -Force
} -ArgumentList $testFilePath, $testFileContent

# Attendre un moment pour laisser le temps à la réplication (ajustez si nécessaire)
Start-Sleep -Seconds 30

# Vérifier si le fichier a été répliqué sur le serveur de destination
$fileExists = Invoke-Command -ComputerName $destinationServer -ScriptBlock {
    param($path)
    Test-Path $path
} -ArgumentList $testFilePath

# Résultat
if ($fileExists) {
    Write-Output "La réplication DFS est active et fonctionelle."
} else {
    Write-Output "La réplication DFS n'est pas active ou a échoué."
}

# Nettoyer le fichier de test
Invoke-Command -ComputerName $sourceServer -ScriptBlock {
    param($path)
    Remove-Item -Path $path -Force
} -ArgumentList $testFilePath

Invoke-Command -ComputerName $destinationServer -ScriptBlock {
    param($path)
    Remove-Item -Path $path -Force
} -ArgumentList $testFilePath
