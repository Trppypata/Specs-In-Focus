# Specs In Focus

A Flutter application for virtual eyewear try-on.

## Features

- Login and registration system
- Browse glasses catalog
- Virtual try-on with camera
- 3D model viewer for glasses
- Face detection for accurate glasses placement
- User profile management

## AR Glasses Try-On Setup

To use the AR glasses try-on feature:

1. Make sure you have the following 3D model files in the `assets/models/` directory:
   - `glasses1.glb` - First glasses model
   - `glasses2.glb` - Second glasses model

2. You can create or download .GLB files from:
   - [Sketchfab](https://sketchfab.com/3d-models/categories/fashion-beauty?features=downloadable&sort_by=-likeCount) (Filter for downloadable models)
   - [TurboSquid](https://www.turbosquid.com/Search/3D-Models/free/glasses/glb)
   - [CGTrader](https://www.cgtrader.com/free-3d-models/character/clothing/glasses)
   - Or create your own using [Blender](https://www.blender.org/)

3. Make sure your .GLB files are optimized for mobile:
   - Keep file size under 10MB
   - Reduce polygon count where possible
   - Use simple materials

4. Place the .GLB files in the assets/models/ directory and ensure they match the filenames referenced in the glasses_model.dart file.

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Add .GLB files to the assets/models directory
4. Run the app using `flutter run`

## Required Permissions

- Camera - For virtual try-on and face detection
- Internet - For API communication

## Dependencies

- camera: For camera access
- google_ml_kit: For face detection
- model_viewer_plus: For 3D model viewing
- permission_handler: For handling permissions
- and more (see pubspec.yaml)

## License

This project is licensed under the MIT License.
