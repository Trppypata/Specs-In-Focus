# Specs In Focus

A Flutter application for trying on glasses virtually using a simulated AR experience.

## Features

### Virtual Try-On
- Preview how glasses look on a model face
- Browse and select from a variety of frame styles
- Take screenshots to share with friends
- Simple and intuitive user interface

### Shopping Experience
- Browse glasses catalog
- View detailed information about each glasses model
- Add glasses to favorites
- Easy checkout process

## Setup Instructions

### Image Resources
1. The application uses images to simulate the AR experience:
   - Place model images in the `assets/images/` directory
   - Place glasses images in the `assets/images/` directory

### Running the App
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the application

## Future Enhancements
- Integration with real AR capabilities using ARKit (iOS) and ARCore (Android)
- Face detection to accurately place glasses on the user's face
- 3D model support with .glb files for more realistic rendering

## Requirements
- Flutter 3.0+
- Dart 2.17+
- Android or iOS device
