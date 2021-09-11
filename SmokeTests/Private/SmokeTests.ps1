Param(
    [string[]]
    $URL,

    [int[]]
    $TcpPort = @(80, 443)
)

Describe 'SmokeTests' {
    BeforeAll {
        $ProgressPreference = 'SilentlyContinue'
        . $PSScriptRoot\Get-SSLCertificate.ps1
    }
    
    Context "Port Checks" {
            
        BeforeEach {
            $PortTest = Test-Connection $URL -TcpPort $TcpPort
        }

        $TestCases = foreach ($TestURL in $URL) {
            foreach ($TestPort in $TcpPort) {
                @{ 
                    URL     = $TestURL 
                    TcpPort = $TestPort
                }
            }
        }

        It "<URL> responds on Port <TcpPort>" -TestCases $TestCases {
            $PortTest | Should -BeTrue
        }          
    }

    Context "Certificate Checks" {

        BeforeEach {
            $Cert = Get-SSLCertificate -ComputerName $URL
        }
            
        $TestCases = foreach ($TestURL in $URL) {
            @{ 
                URL = $TestURL 
            }
        }

        It '<URL> SSL Certificate expiry is > 30 days' -TestCases $TestCases {
            ($Cert.NotAfter - (Get-Date)).Days | Should -BeGreaterThan 30
        }
    }

    Context "Status Code Checks" {

        BeforeEach {
            try {
                $TimeTaken = Measure-Command {
                    $Response = Invoke-WebRequest -Uri $URL
                    $StatusCode = $Response.StatusCode
                }
            }
            catch {
                $StatusCode = $_.Exception.Response.StatusCode.value__
            }
        }

        $TestCases = foreach ($TestURL in $URL) {
            @{ 
                URL = $TestURL 
            }
        }

        It '<URL> returns a Status Code of 200' -TestCases $TestCases {
            $StatusCode | Should -Be 200
        }
        It '<URL> load time should be less than 5 seconds' -TestCases $TestCases {
            $TimeTaken.TotalSeconds | Should -BeLessThan 5
        }
    }
}