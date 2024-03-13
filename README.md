# Server Ping Status Logger

This PowerShell script (`PingStatusLogger.ps1`) is designed to ping a list of servers and log the ping status (Up/Down) and response time to a CSV file. It is useful for system administrators who need to quickly check the availability and response time of multiple servers.

## Prerequisites

To run this script, you need:
- PowerShell 5.1 or higher.
- The `Test-Connection` cmdlet available in your PowerShell environment.

## Input File Structure

The input file should be a CSV file containing a list of server names. The CSV file must have a header row with at least one column named `Name`. Each row under this column should contain the server name (or IP address) that you want to ping.

Example of the input CSV file structure:

```csv
Name
server1.domain.com
server2.domain.com
192.168.1.1
Parameters
FilePath: Mandatory. The path to the CSV file containing the list of server names.
OutputPath: Mandatory. The path where the ping results will be saved as a CSV file.
Usage
To use the script, open PowerShell, navigate to the directory containing the script, and run it with the required parameters.

Example:

.\PingStatusLogger.ps1 -FilePath "C:\servers.csv" -OutputPath "C:\ping_results.csv"
This will ping each server listed in C:\servers.csv and save the ping results to C:\ping_results.csv.

Output
The script outputs a CSV file containing the following columns:

Name: The server name/IP address.
Status: Indicates whether the server is Up or Down.
ResponseTime: The time in milliseconds it took for the server to respond. If the server is down, this will be "N/A".
Error Handling
If the input CSV file does not exist or the specified output directory does not exist, the script will terminate and display an error message.
If a server name is empty in the input CSV, the script will issue a warning but continue to process the rest of the list.
Notes
Ensure that the input CSV file is properly formatted as described in the Input File Structure section.
The script requires network connectivity to the servers being pinged.
The user running the script needs to have the necessary permissions to ping the servers and write to the output path.
License
This script is provided "as is", without warranty of any kind. You are free to use, modify, and distribute it as needed.

Contributing
Contributions to the script are welcome. Please ensure that any changes maintain compatibility with the existing parameters and functionality.


This README provides a comprehensive guide for users to understand and utilize the `PingStatusLogger.ps1` script effectively. It includes details on prerequisites, input file structure, usage instructions, output details, error handling, and notes for users to consider.