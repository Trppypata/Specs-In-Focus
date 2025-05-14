# How to Download and Use .GLB Glasses Models

This guide will help you obtain and use 3D glasses models for the Specs In Focus app's virtual try-on feature.

## Option 1: Download Ready-to-Use GLB Models

1. Visit [Sketchfab](https://sketchfab.com/search?q=glasses&type=models) and search for glasses models
2. Use the filter to show only downloadable models
3. Look for models with the following characteristics:
   - Low poly count (under 50k triangles)
   - Properly centered with origin point between lenses
   - Realistic materials/textures
   - CC Attribution license or better

### Recommended Free GLB Models:

- [Glasses 3D Model](https://sketchfab.com/3d-models/glasses-3d-model-74c1d202ac0249e39823e379e2b065e9) by nattsol
- [Three Banded Glasses](https://sketchfab.com/3d-models/three-banded-glasses-one-so-far-a3219c84c95a44ae97317e206e712056) by dansmath
- [Huge Eyeglasses](https://sketchfab.com/3d-models/huge-eyeglasses-8027af1dd6d0408596e2660f73ea3460) by richthejuggler

## Option 2: Convert Existing 3D Models to GLB

If you have 3D models in other formats (.obj, .fbx, etc.), you can convert them to GLB using:

1. **[Blender](https://www.blender.org/)** (Free):
   - Import your model (File > Import)
   - Ensure textures are properly applied
   - Export as GLB (File > Export > glTF 2.0)
   - Make sure to check "Export Materials" and "Include Textures"

2. **Online Converters**:
   - [Model Converter](https://modelconverter.com/)
   - [Online 3D Converter](https://www.online-convert.com/3d-converter)

## Placing Models in the App

1. Download the GLB files and place them in the `assets/models/` directory
2. Rename them to match the references in the code (glasses1.glb, glasses2.glb, etc.)
3. Ensure file size is optimized for mobile (ideally under 5MB per model)

## Tips for Optimal AR Experience

1. **Model Positioning**: 
   - The model's origin point (pivot) should be centered between the lenses
   - The model should face the positive Z direction

2. **Model Complexity**:
   - Keep triangle count under 50,000 for mobile performance
   - Use texture maps instead of complex geometry when possible

3. **Materials**:
   - Use PBR materials for realistic rendering
   - Include transparency for lenses

## Common Issues and Solutions

- **Model too large/small**: Scale the model in Blender before exporting
- **Textures missing**: Ensure textures are embedded in the GLB file
- **Poor performance**: Reduce polygon count or texture resolution
- **Model not positioned correctly**: Adjust the model's origin point in Blender

## Resources for Creating Custom Glasses Models

- [Blender Tutorials](https://www.youtube.com/results?search_query=blender+glasses+modeling)
- [Sketchfab Guidelines](https://help.sketchfab.com/hc/en-us/articles/202508396-Model-optimization-for-web) 