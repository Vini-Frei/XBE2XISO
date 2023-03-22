#-- Created by u/monsterico --#

<#####SET VARIABLE TO RUN EXTRACT-XISO#####>
$RunEXISO = '"G:\Emulators\Xbox\exiso.exe" -c'

<#####PROMPT USER FOR GAME PATH#####>
$PromptedGamePath = read-host -prompt "
Please specify the path in which your game directories are currently stored. Without a \ at the end.

such as G:\Emulators\Xbox\Games

Path"

<#####PROMPT USER FOR XISO EXPORT PATH#####>
$PromptedExportPath = read-host -prompt "
Please specify the path in which your XISO files will be exported to. Without a \ at the end.

such as G:\Emulators\Xbox\Games

Path"

<#####PROMPT USER TO IMPORT CSV#####>
[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop'); Filter = 'CSV files (*.CSV)|*.CSV|All files (*.*)|*.*' }
$FileBrowser.ShowDialog() | Out-Null; $FilePath = $FileBrowser.FileName
$CSV = Import-CSV $FileBrowser.FileName

<#####SET TOTAL NUMBER OF DIRECTORIES FOR PROGRESS BAR#####>
$counter1 = 0
$counter2 = 0
foreach ($Game in $CSV.Games) {
    $counter1++
}

<#####RUN XISO CREATION LOOP#####>
foreach ($Game in $CSV.Games) {

    <#####SHOW PROGRESS FOR ALL GAMES#####>
    $counter2++
    Write-Progress -Activity "Creating XISO for $Game" -CurrentOperation "$counter2 out of $counter1 XISO(s) Completed" -PercentComplete (($counter2 / $counter1) * 100)

    <#####SET XISO FILE NAME#####>
    $Iso = '.iso'
    $XISOFileName = (-join($Game, $Iso))
    
    <#####SET THE XISO GAME PATH#####>
    $GamePath = """$PromptedGamePath\$Game"""

    <#####SET THE XISO EXPORT PATH#####>
    $ExportPath = """$PromptedExportPath\$XISOFileName"""  

    <#####SET ALL VARIABLES TO ONE#####>
    $CreateXISO = (-join("$RunEXISO ", "$GamePath ", "$ExportPath"))

    <#####RUN COMMAND IN CMD#####>
    cmd /c $CreateXISO | Out-Null

    Write-Host "Creation of XISO for $Game COMPLETED"
     
    }

    Write-Host "All XISOs have been created."
    Read-Host -Prompt "Press Enter to exit"