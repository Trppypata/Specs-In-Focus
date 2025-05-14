# Creating Transparent PNG Images for Virtual Try-On

This guide explains how to create transparent PNG images for the virtual try-on feature in the Specs In Focus app.

## What You Need

- Image editing software (Photoshop, GIMP, remove.bg, etc.)
- Source images of eyeglasses (front-facing view)

## Method 1: Using Online Tools (Easiest)

1. Go to [remove.bg](https://www.remove.bg/)
2. Upload your eyeglasses image
3. The tool will automatically remove the background
4. Download the transparent PNG
5. Rename it to match the naming convention in the code (e.g., `andy_transparent.png`)
6. Place it in the `assets/images/` directory

## Method 2: Using Photoshop

1. Open your eyeglasses image in Photoshop
2. Use the Magic Wand tool or Select Subject feature to select the glasses
3. Refine the selection to ensure clean edges
4. Invert the selection (Select > Inverse)
5. Delete the background
6. Save as PNG with transparency enabled
7. Place in the `assets/images/` directory

## Method 3: Using GIMP (Free Alternative)

1. Open your eyeglasses image in GIMP
2. Use the Fuzzy Select tool or Scissors Select tool to select the glasses
3. Invert the selection (Select > Invert)
4. Delete the background
5. Export as PNG with transparency enabled
6. Place in the `assets/images/` directory

## Tips for Best Results

1. **Use High-Resolution Images**: Start with high-quality images to get clean edges.
2. **Front-Facing View**: Make sure the glasses are photographed from a direct front view.
3. **Consistent Sizing**: Try to maintain similar dimensions for all eyeglasses images.
4. **Clean Edges**: Pay special attention to cleaning up the edges for a realistic look.
5. **Proper Placement**: The bridge of the glasses should be centered horizontally.

## Naming Convention

Name your transparent PNG files using this format:
- Original image: `glasses_name.png`
- Transparent version: `glasses_name_transparent.png`

For example:
- andy1.png → andy_transparent.png
- astrid1.png → astrid_transparent.png

## Testing Your Images

After adding your transparent PNG images to the assets directory:

1. Update the Glasses model in `glasses_model.dart` to include the transparent image path
2. Run the app and test the virtual try-on feature
3. Adjust the position and size using the sliders

## Troubleshooting

- **White Edges**: If your transparent PNG has white edges, revisit your editing software and refine the selection.
- **Image Too Small/Large**: Resize the image while maintaining aspect ratio.
- **Poor Alignment**: Ensure the glasses are properly centered in the image. 