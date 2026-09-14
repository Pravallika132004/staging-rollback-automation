$ErrorActionPreference = "Stop"

$Namespace = "staging"
$Deployment = "staging-app"

Write-Host "======================================"
Write-Host " Staging Rollback Automation"
Write-Host "======================================"

Write-Host ""
Write-Host "Checking current deployment..."

kubectl get deployment $Deployment -n $Namespace

Write-Host ""
Write-Host "Checking rollout status..."

kubectl rollout status deployment/$Deployment `
    -n $Namespace `
    --timeout=30s

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "Deployment is healthy."
    exit 0
}

Write-Host ""
Write-Host "Deployment failed."
Write-Host "Starting automatic rollback..."

kubectl rollout undo deployment/$Deployment -n $Namespace

Write-Host ""
Write-Host "Waiting for rollback to complete..."

kubectl rollout status deployment/$Deployment `
    -n $Namespace `
    --timeout=60s

if ($LASTEXITCODE -ne 0) {
    Write-Host "Rollback failed."
    exit 1
}

Write-Host ""
Write-Host "Rollback completed successfully."

Write-Host ""
Write-Host "Current Pods:"
kubectl get pods -n $Namespace

Write-Host ""
Write-Host "Current image:"
kubectl get deployment $Deployment `
    -n $Namespace `
    -o jsonpath="{.spec.template.spec.containers[0].image}"

Write-Host ""
Write-Host ""
Write-Host "======================================"
Write-Host " Rollback verification complete"
Write-Host "======================================"