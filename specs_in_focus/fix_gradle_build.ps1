# Fix Gradle Build Script for Flutter
Write-Host "Starting Gradle build fix process..." -ForegroundColor Cyan

# Step 1: Clean Flutter project completely
Write-Host "Step 1: Cleaning Flutter project..." -ForegroundColor Green
flutter clean

# Step 2: Delete Gradle cache
Write-Host "Step 2: Deleting Gradle cache..." -ForegroundColor Green
$gradleCachePath = "$env:USERPROFILE\.gradle\caches"
if (Test-Path $gradleCachePath) {
    Remove-Item -Path $gradleCachePath -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Gradle cache deleted." -ForegroundColor Green
} else {
    Write-Host "Gradle cache not found." -ForegroundColor Yellow
}

# Step 3: Stop running Gradle daemons
Write-Host "Step 3: Stopping Gradle daemons..." -ForegroundColor Green
try {
    cd android
    ./gradlew --stop
    cd ..
    Write-Host "Gradle daemons stopped." -ForegroundColor Green
} catch {
    Write-Host "Failed to stop Gradle daemons. Continuing anyway." -ForegroundColor Yellow
}

# Step 4: Get packages
Write-Host "Step 4: Getting Flutter packages..." -ForegroundColor Green
flutter pub get

# Step 5: Run in debug mode with optimizations
Write-Host "Step 5: Building with optimizations..." -ForegroundColor Green
Write-Host "Starting Flutter run with minimal overhead..." -ForegroundColor Cyan
Write-Host "This will take a few minutes but should be faster than before" -ForegroundColor Cyan

# Run with optimizations
flutter run --debug --no-sound-null-safety --no-pub

Write-Host "Process completed!" -ForegroundColor Cyan
Write-Host "If the build is still slow, try restarting your computer and running this script again." -ForegroundColor Yellow 