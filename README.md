# SmokeTests

A set of Pester tests to perform some basic health checks for one or more URLs. 

> Requires Pester v5.

Current checks: 

- Checks the URLs specified via `-URL` respond on the ports specified via `-TcpPort`.
- Checks the SSL certificate has more than 30 days until it expires.
- Checks the status code returned is 200.
- Checks the page loads in less than 5 seconds.

## Usage

```powershell
Invoke-SmokeTests -URL 'google.com','amazon.com' -TcpPort 80,443
```