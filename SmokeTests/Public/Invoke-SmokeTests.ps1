Function Invoke-SmokeTests {
    <#
    .SYNOPSIS
        Executes the automated Smoke Tests for one or more specified URLs.
    #>
    param(
        [string[]]
        $URL,
        
        [int[]]
        $TcpPort
    )

    $TestPath = "$PSScriptRoot\..\Private\SmokeTests.ps1"

    $Container = New-PesterContainer -Path $TestPath -Data @{ 
        URL = $URL 
        TcpPort = $TcpPort
    }

    Invoke-Pester -Container $Container -Output Detailed
}