# iOS Development Guide for Specs In Focus

This guide will help you set up your environment for iOS development and run the Specs In Focus app on an iPhone or iOS simulator.

## Prerequisites

- A Mac computer with macOS (required for iOS development)
- Xcode installed (latest version recommended)
- Apple Developer account (free or paid)
- iPhone or iOS simulator for testing
- Flutter SDK installed

## Step 1: Set Up Your Mac

If you're developing on Windows, you'll need access to a Mac to build and run the app on iOS. Options include:

1. **Use a physical Mac**: MacBook, iMac, or Mac mini
2. **Cloud Mac service**: MacinCloud, MacStadium, or other cloud Mac providers
3. **Virtual Machine**: (Note: This violates Apple's EULA but is technically possible)

## Step 2: Install Xcode

1. Open the App Store on your Mac
2. Search for "Xcode" and install it
3. Open Xcode and complete the installation of additional components
4. Install Xcode Command Line Tools by running:
   ```
   xcode-select --install
   ```

## Step 3: Set Up Flutter for iOS Development

1. Install Flutter on your Mac if not already done:
   ```
   brew install flutter
   ```
   
2. Run Flutter doctor to verify your installation:
   ```
   flutter doctor
   ```
   
3. Accept the iOS licenses:
   ```
   flutter doctor --android-licenses
   ```

## Step 4: Configure iOS Project

1. Clone or copy your project to the Mac:
   ```
   git clone <your-repo-url>
   ```
   
2. Navigate to your project folder:
   ```
   cd specs_in_focus
   ```
   
3. Install dependencies:
   ```
   flutter pub get
   ```
   
4. Open the iOS project in Xcode:
   ```
   open ios/Runner.xcworkspace
   ```
   
5. In Xcode, select Runner > Runner in the project navigator
6. Select a Development Team in the Signing & Capabilities tab

## Step 5: Configure Info.plist for Camera and Model Viewer

1. Open `ios/Runner/Info.plist` in a text editor or Xcode
2. Add the following entries:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access for the virtual try-on feature</string>
<key>io.flutter.embedded_views_preview</key>
<true/>
```

## Step 6: Run on iOS Simulator

1. Start an iOS simulator:
   ```
   open -a Simulator
   ```
   
2. In your project directory, run:
   ```
   flutter run
   ```

## Step 7: Run on Physical iPhone

1. Connect your iPhone to your Mac with a USB cable
2. Unlock your iPhone and trust the computer if prompted
3. In Xcode, select your device from the device dropdown
4. Run the app by clicking the play button or via terminal:
   ```
   flutter run
   ```
   
Note: The first time you run on a physical device, you may need to go to Settings > General > Device Management on your iPhone and trust the developer certificate.

## Troubleshooting

- **Build fails with signing issues**: Make sure you've selected a development team in Xcode
- **Camera not working**: Check that you've added the NSCameraUsageDescription to Info.plist
- **ModelViewer not working**: Ensure io.flutter.embedded_views_preview is set to true in Info.plist
- **Package problems**: Try running `flutter clean` and then `flutter pub get`

## Creating an IPA for Distribution

When you're ready to distribute your app:

1. Update version in `pubspec.yaml`
2. Create a build:
   ```
   flutter build ios
   ```
3. Open Xcode and use Archive feature (Product > Archive)
4. Follow the Xcode distribution workflow

## Testing on Multiple iOS Devices

For testing on different iOS versions/devices without physical hardware:

1. Open Xcode > Window > Devices and Simulators
2. Create simulators for different iPhone models and iOS versions
3. Run on specific simulator with:
   ```
   flutter run -d "iPhone 14 Pro"
   ```
   (Replace with your simulator name)

## Additional Resources

- [Flutter iOS Setup Guide](https://docs.flutter.dev/get-started/install/macos#ios-setup)
- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [TestFlight Beta Testing](https://developer.apple.com/testflight/) 