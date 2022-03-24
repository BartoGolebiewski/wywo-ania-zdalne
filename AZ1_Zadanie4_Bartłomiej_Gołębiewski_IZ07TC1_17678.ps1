#Bartłomiej Gołębiewski IZ07TC1 17678 AZ1_Zadanie4

$domain = Get-ADDomain
$Computers = Get-ADComputer -Filter * -SearchBase $domain | Select-Object -ExpandProperty name

function menu {

    Write-Host "1: Get-service"
    Write-Host "2: Invoke-command"
    Write-Host "3: Jobs"
    Write-Host "4: Zdefiniowana sesja"
    Write-Host "5: Wyjscie"

    return Read-Host "Wybierz :"	
}

function getService_17678 {
    $Folderpath = "C:\WIT\17678\cmdlet_17678\"

    if (!(Test-Path -Path $Folderpath )) {
      New-Item -ItemType "directory" -Path $Folderpath 
      Write-Host "Utworzono $Folderpath "
    }

    foreach ($computer in $Computers) {
       try {
          $response = Get-Service -ComputerName $computer | Where-Object {$_.status -eq "running"} | Select Name, DisplayName, status, startType
          $response | Export-Csv -Path $Folderpath\$computer.csv    
       } catch {
          Write-Host "Nie utworzono pliku"
       } } }
function invoke_17678 {
    $Folderpath = "C:\WIT\17678\invoke_17678\"

    if (!(Test-Path -Path $Folderpath )) {
      New-Item -ItemType "directory" -Path $Folderpath 
      Write-Host "Utworzono $Folderpath "
    }
    
    foreach ($computer in $Computers) {
        try {
            $response = Invoke-Command -ComputerName $computer  -ScriptBlock { Get-Service | Select Name, DisplayName, status, startType }
            $response | Export-Csv -Path $Folderpath\$computer.csv 
        } catch {
            Write-Host "Nie utworzono pliku"
        } } }
function jobs_17678 {
    $Folderpath = "C:\WIT\17678\jobs_17678\"

    if (!(Test-Path -Path $Folderpath )) {
      New-Item -ItemType "directory" -Path $Folderpath 
      Write-Host "Utworzono $Folderpath "
    }

    foreach ($computer in $Computers) {
       try {
          $job = Invoke-Command -ComputerName $computer -ScriptBlock { Get-Service | Select Name, DisplayName, status, startType } -AsJob
          $job | Wait-Job
          $response = $job | Receive-Job
          $response | Export-Csv -Path $Folderpath\$computer.csv
       } catch {
          Write-Host "Nie utworzono pliku"
       } } }
function sesja_17678 {
    $Folderpath = "C:\WIT\17678\sesja_17678\"

    if (!(Test-Path -Path $Folderpath)) {
      New-Item -ItemType "directory" -Path $Folderpath
      Write-Host "Utworzono $Folderpath"
    }

    foreach ($computer in $Computers) {
        try {
            $psSession = New-PSSession -ComputerName $computer
            $response = Invoke-Command -Session $psSession -ScriptBlock { Get-Service | Select Name, DisplayName, status, startType }
            $response | Export-Csv -Path $Folderpath\$computer.csv
        } catch {
            Write-Host "Nie utworzono pliku"
        } } }

do { $selection = menu 

    switch ($selection) {
        '1' {
           getService_17678 }
        '2' {  
           invoke_17678 }
        '3' {
           jobs_17678 }
        '4' {
           sesja_17678 } } } until ($selection -eq '5') 