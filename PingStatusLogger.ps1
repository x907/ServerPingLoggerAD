<#
.SYNOPSIS
    This script pings a list of servers by their names and logs the results to a CSV file.

.DESCRIPTION
    The script imports a CSV file containing server names. It then pings each server by name, records the ping results, including the server name, status (up or down), and response time. The ping results are stored in a generic list. The script handles exceptions for servers that are down or unreachable. Finally, the ping results are exported to a CSV file.

.PARAMETER FilePath
    The file path of the CSV file containing server names.

.PARAMETER OutputPath
    The file path where the ping results will be saved.

.INPUTS
    None. The script reads server names from a CSV file.

.OUTPUTS
    A CSV file containing the ping results.

.EXAMPLE
    .\serverpinglogger.ps1 -FilePath "c:\source\servers.csv" -OutputPath "c:\output\pingresults.csv"
    - This command runs the script and pings the servers listed in the CSV file.

.NOTES
    Author: David Dias
    Date: 01/30/2024
    Version: 1.0.4
#>

param (
    [Parameter(Mandatory=$true)]
    [ValidateScript({
        if (-Not ($_ | Test-Path)) {
            throw "File path `"$($_)`" does not exist."
        } 
        if (-Not ($_ | Test-Path -PathType Leaf)) {
            throw "File path `"$($_)`" does not point to a file."
        }
        return $true
    })]
    [string]$FilePath,
    
    [Parameter(Mandatory=$true)]
    [ValidateScript({
        $dir = Split-Path $_
        if (-Not ($dir | Test-Path)) {
            throw "Directory `"$dir`" does not exist."
        }
        return $true
    })]
    [string]$OutputPath
)

try {
    # Import the CSV file with server names
    $Servers = Import-Csv -Path $FilePath
}
catch {
    Write-Error "Failed to import CSV file: $_"
    exit 1
}

# Initialize a list to store the ping results
$PingResults = New-Object System.Collections.Generic.List[object]

foreach ($Server in $Servers) {
    $serverName = $Server.Name
    if (![string]::IsNullOrEmpty($serverName)) {
        try {
            $PingResult = Test-Connection -ComputerName $serverName -Count 1 -ErrorAction Stop
            $PingResults.Add([PSCustomObject]@{
                Name = $serverName
                Status = "Up"
                ResponseTime = $PingResult.ResponseTime
            })
            Write-Host "Successfully pinged $serverName" -ForegroundColor Green
        }
        catch {
            Write-Host "Error pinging ${serverName}: $_"
            $PingResults.Add([PSCustomObject]@{
                Name = $serverName
                Status = "Down"
                ResponseTime = "N/A"
            })
        }
    }
    else {
        Write-Host "Warning: Server name is empty for one of the rows in the CSV file"
    }
}

# Export the ping results to a CSV file
try {
    $PingResults | Export-Csv -Path $OutputPath -NoTypeInformation
}
catch {
    Write-Error "Failed to export CSV file: $_"
    exit 1
}