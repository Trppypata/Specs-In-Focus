@echo off
echo Cleaning Flutter project...
call flutter clean

echo Deleting Gradle caches...
rmdir /s /q %USERPROFILE%\.gradle\caches

echo Deleting build directory...
rmdir /s /q build
rmdir /s /q .dart_tool
rmdir /s /q android\.gradle
rmdir /s /q android\app\build

echo Getting dependencies...
call flutter pub get

echo Building Android app...
call flutter build apk --debug --no-shrink

echo Done! 