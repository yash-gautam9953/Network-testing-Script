# Network Connection Monitor
# Press Ctrl+C to stop monitoring

Clear-Host
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "         NETWORK CONNECTION MONITOR" -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Started monitoring at: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Yellow
Write-Host "Press Ctrl+C to stop..." -ForegroundColor Gray
Write-Host ""

$testHosts = @("google.com", "cloudflare.com", "8.8.8.8")
$consecutiveFailures = 0
$totalTests = 0
$successfulTests = 0

while ($true) {
    $totalTests++
    $timestamp = Get-Date -Format 'HH:mm:ss'
    $connectionFound = $false
    
    foreach ($testHost in $testHosts) {
        $ping = Test-Connection -ComputerName $testHost -Count 1 -Quiet -ErrorAction SilentlyContinue
        if ($ping) {
            $connectionFound = $true
            $pingResult = Test-Connection -ComputerName $testHost -Count 1 -ErrorAction SilentlyContinue
            $responseTime = [math]::Round($pingResult.ResponseTime, 0)
            
            Write-Host "[$timestamp] " -NoNewline -ForegroundColor Gray
            Write-Host "[ONLINE] " -NoNewline -ForegroundColor Green
            Write-Host "Connected to $testHost (${responseTime}ms) " -NoNewline -ForegroundColor White
            Write-Host "| Success Rate: $([math]::Round(($successfulTests + 1) / $totalTests * 100, 1))%" -ForegroundColor Cyan
            
            $successfulTests++
            $consecutiveFailures = 0
            break
        }
    }
    
    if (-not $connectionFound) {
        $consecutiveFailures++
        Write-Host "[$timestamp] " -NoNewline -ForegroundColor Gray
        Write-Host "[OFFLINE] " -NoNewline -ForegroundColor Red
        Write-Host "No connection to any test host " -NoNewline -ForegroundColor White
        Write-Host "| Failures: $consecutiveFailures " -NoNewline -ForegroundColor Yellow
        Write-Host "| Success Rate: $([math]::Round($successfulTests / $totalTests * 100, 1))%" -ForegroundColor Cyan
        
        if ($consecutiveFailures -eq 5) {
            Write-Host "WARNING: 5 consecutive failures detected in your network!" -ForegroundColor Magenta
        }
    }
    
    Start-Sleep 3
}


