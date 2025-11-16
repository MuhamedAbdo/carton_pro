import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../screens/full_screen_image_screen.dart'; // استيراد الشاشة الجديدة

class ImagePickerField extends StatefulWidget {
  final List<String> imagePaths;
  final Function(List<String>) onImagesChanged;

  const ImagePickerField({
    super.key,
    required this.imagePaths,
    required this.onImagesChanged,
  });

  @override
  State<ImagePickerField> createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  List<CameraDescription>? _cameras;
  bool _isCameraReady = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        debugPrint('No cameras found.');
        return;
      }

      final camera = _cameras!.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras![0],
      );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.medium,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      _initializeControllerFuture = _cameraController.initialize();
      _initializeControllerFuture.then((_) {
        if (mounted) {
          setState(() {
            _isCameraReady = true;
          });
        }
      });
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  Future<void> _takePicture() async {
    if (!_isCameraReady) return;
    try {
      final XFile file = await _cameraController.takePicture();
      if (!mounted) return;

      setState(() {
        widget.imagePaths.add(file.path);
      });
      widget.onImagesChanged(widget.imagePaths);
    } catch (e) {
      debugPrint('Take picture error: $e');
    }
  }

  void _removeImage(String path) {
    setState(() {
      widget.imagePaths.remove(path);
    });
    widget.onImagesChanged(widget.imagePaths);
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_isCameraReady)
          SizedBox(
            height: 150, // ارتفاع كافٍ للكاميرا
            child: Stack(
              fit: StackFit.expand,
              children: [
                // كاميرا
                FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return CameraPreview(_cameraController);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                // زر التقاط
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: FloatingActionButton(
                      onPressed: _takePicture,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                      child: const Icon(Icons.camera, size: 28),
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          const Center(child: Text('جاري تهيئة الكاميرا...')),
        const SizedBox(height: 12),
        // عرض الصور الملتقطة
        if (widget.imagePaths.isNotEmpty)
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.imagePaths.length,
              itemBuilder: (context, index) {
                final path = widget.imagePaths[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigate لشاشة العرض الكامل
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenImageScreen(
                                imagePaths: widget.imagePaths,
                                initialIndex: index,
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(path),
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: -5,
                        right: -5,
                        child: GestureDetector(
                          onTap: () => _removeImage(path),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
