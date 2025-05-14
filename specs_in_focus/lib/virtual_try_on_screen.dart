import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:specs_in_focus/models/glasses_model.dart';

class VirtualTryOnScreen extends StatefulWidget {
  final Glasses? selectedGlasses;

  const VirtualTryOnScreen({Key? key, this.selectedGlasses}) : super(key: key);

  @override
  _VirtualTryOnScreenState createState() => _VirtualTryOnScreenState();
}

class _VirtualTryOnScreenState extends State<VirtualTryOnScreen>
    with WidgetsBindingObserver {
  List<Glasses> availableGlasses = GlassesRepository.getAllGlasses();
  Glasses? currentGlasses;

  // Camera-related variables
  CameraController? _controller;
  List<CameraDescription>? cameras;
  bool _isCameraInitialized = false;
  bool _isCameraPermissionGranted = false;
  bool _showImageViewerOnly = false;

  // Virtual glasses position
  double _glassesPositionY = 0.3; // Default position from top (0.0 to 1.0)
  double _glassesSize = 0.7; // Default size (relative to screen width)

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    currentGlasses = widget.selectedGlasses ?? availableGlasses.first;
    _getCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disposeCamera();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _disposeCamera();
    } else if (state == AppLifecycleState.resumed &&
        _controller != null &&
        !_controller!.value.isInitialized) {
      _initializeCamera();
    }
  }

  // Request camera permission
  Future<void> _getCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _isCameraPermissionGranted = status.isGranted;
    });

    if (_isCameraPermissionGranted) {
      _initializeCamera();
    }
  }

  // Initialize the camera
  Future<void> _initializeCamera() async {
    cameras = await availableCameras();

    if (cameras != null && cameras!.isNotEmpty) {
      // Use front camera for selfie mode
      final frontCamera = cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras!.first,
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();

      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  // Dispose camera resources
  void _disposeCamera() {
    if (_controller != null) {
      _controller!.dispose();
      _controller = null;
      _isCameraInitialized = false;
    }
  }

  // Toggle between camera+image view and image only viewer
  void _toggleImageViewerOnly() {
    setState(() {
      _showImageViewerOnly = !_showImageViewerOnly;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'specs',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              'in',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'focus',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _showImageViewerOnly ? Icons.camera_alt : Icons.image,
              color: Colors.black,
            ),
            onPressed: _toggleImageViewerOnly,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            'Virtual Try-On',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Instantly preview eyewear with lifelike accuracy',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),

          // Virtual try-on preview area
          Expanded(
            child: _showImageViewerOnly
                ? _buildImageViewerOnly()
                : _buildCameraWithGlassesOverlay(),
          ),

          // Glasses position and size controls
          if (!_showImageViewerOnly)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Text('Position:'),
                  Expanded(
                    child: Slider(
                      value: _glassesPositionY,
                      min: 0.1,
                      max: 0.5,
                      onChanged: (value) {
                        setState(() {
                          _glassesPositionY = value;
                        });
                      },
                    ),
                  ),
                  const Text('Size:'),
                  Expanded(
                    child: Slider(
                      value: _glassesSize,
                      min: 0.3,
                      max: 1.0,
                      onChanged: (value) {
                        setState(() {
                          _glassesSize = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

          // Glasses selector
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: availableGlasses.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final glasses = availableGlasses[index];
                final isSelected = currentGlasses?.id == glasses.id;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentGlasses = glasses;
                    });
                  },
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.transparent,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        glasses.imageAssets
                            .first, // Use regular image for thumbnail
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Selected glasses info
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentGlasses?.name ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        currentGlasses?.description ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build camera preview with glasses overlay
  Widget _buildCameraWithGlassesOverlay() {
    if (!_isCameraPermissionGranted) {
      // Show permission request UI
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.camera_alt, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Camera permission is required',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getCameraPermission,
              child: const Text('Grant Permission'),
            ),
          ],
        ),
      );
    }

    if (!_isCameraInitialized) {
      // Show loading indicator
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Return camera preview with glasses overlay image
    return Stack(
      fit: StackFit.expand,
      children: [
        // Camera preview
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CameraPreview(_controller!),
        ),

        // Glasses overlay with ColorFiltered for transparency
        Center(
          child: Align(
            alignment: Alignment(
                0, _glassesPositionY * 2 - 1), // Convert from 0-1 to -1 to 1
            child: ColorFiltered(
              // Apply a color filter that preserves black frames and makes white parts transparent
              colorFilter: const ColorFilter.matrix([
                1, 0, 0, 0, 0,
                0, 1, 0, 0, 0,
                0, 0, 1, 0, 0,
                0, 0, 0, 1,
                -160, // Adjust the last value to control transparency threshold
              ]),
              child: Image.asset(
                currentGlasses!.imageAssets.first,
                width: MediaQuery.of(context).size.width * _glassesSize,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),

        // Controls
        Positioned(
          bottom: 16,
          right: 16,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.image, color: Colors.white),
              onPressed: _toggleImageViewerOnly,
            ),
          ),
        ),
      ],
    );
  }

  // Build image viewer only for glasses without camera
  Widget _buildImageViewerOnly() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: ColorFiltered(
          // Apply a color filter that preserves black frames and makes white parts transparent
          colorFilter: const ColorFilter.matrix([
            1, 0, 0, 0, 0,
            0, 1, 0, 0, 0,
            0, 0, 1, 0, 0,
            0, 0, 0, 1,
            -160, // Adjust the last value to control transparency threshold
          ]),
          child: Image.asset(
            currentGlasses!.imageAssets.first,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
