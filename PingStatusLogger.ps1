<#
.SYNOPSIS
    This script pings a list of servers and logs the ping status and response time to a CSV file.

.DESCRIPTION
    The script takes two mandatory parameters: $FilePath and $OutputPath. 
    $FilePath should be the path to a CSV file containing a list of server names.
    $OutputPath should be the path where the ping results will be saved as a CSV file.

.PARAMETER FilePath
    The path to the CSV file containing a list of server names.

.PARAMETER OutputPath
    The path where the ping results will be saved as a CSV file.

.EXAMPLE
    .\PingStatusLogger.ps1 -FilePath "C:\servers.csv" -OutputPath "C:\ping_results.csv"
    This example runs the script with the specified input and output paths.

.NOTES
    - The script requires the Test-Connection cmdlet to be available.
    - The CSV file should have a "Name" column containing the server names.
    - If a server cannot be pinged, it will be marked as "Down" in the ping results.
    - The ping results will include the response time for each server that was successfully pinged.
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
            $Server | Add-Member -NotePropertyName Status -NotePropertyValue "Up"
            $Server | Add-Member -NotePropertyName ResponseTime -NotePropertyValue $PingResult.ResponseTime
            $PingResults.Add($Server)
            Write-Host "Successfully pinged $serverName" -ForegroundColor Green
        }
        catch {
            Write-Host "Error pinging ${serverName}: $_"
            $Server | Add-Member -NotePropertyName Status -NotePropertyValue "Down"
            $Server | Add-Member -NotePropertyName ResponseTime -NotePropertyValue "N/A"
            $PingResults.Add($Server)
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