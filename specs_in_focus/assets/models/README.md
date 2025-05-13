# 3D Models Directory

This directory is reserved for 3D model files that could be used for AR features in future versions.

## Current Implementation
The app currently uses a simulated AR experience with image overlays instead of 3D models.
This provides compatibility across devices without requiring AR-specific hardware support.

## Future Implementation
When implementing full AR functionality:

1. Add GLB model files to this directory:
   - `glasses1.glb`
   - `glasses2.glb`

2. Update the `VirtualTryOnScreen` component to use AR packages like:
   - `ar_flutter_plugin`
   - `arcore_flutter_plugin` 
   - `model_viewer_plus`

3. Implement face detection to properly place the 3D models on the user's face

Currently, there are sample GLB files in the `assets/images/` directory that can be moved here when implementing the 3D functionality. 