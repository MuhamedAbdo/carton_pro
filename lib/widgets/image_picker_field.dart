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
  CameraController? _cameraController; // ✅ غير late إلى عادي مع ?
  Future<void>? _initializeControllerFuture; // ✅ غير late إلى عادي مع ?
  List<CameraDescription>? _cameras;
  bool _isCameraReady = false;
  bool _cameraError = false; // ✅ متغير جديد لتحديد وجود خطأ

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
        if (mounted) {
          setState(() {
            _cameraError = true; // ✅ علم على وجود خطأ
          });
        }
        return;
      }

      final camera = _cameras!.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras![0],
      );

      _cameraController = CameraController(
        // ✅ حط القيمة في _cameraController
        camera,
        ResolutionPreset.medium,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      _initializeControllerFuture = _cameraController!
          .initialize(); // ✅ استخدم ! علشانك متأكد إن _cameraController م-initialized
      await _initializeControllerFuture; // ✅ انتظر التهيئة
      if (mounted) {
        setState(() {
          _isCameraReady = true; // ✅ عدل الحالة بعد التهيئة
        });
      }
    } catch (e) {
      debugPrint('Camera init error: $e');
      if (mounted) {
        setState(() {
          _cameraError = true; // ✅ علم على وجود خطأ
        });
      }
    }
  }

  Future<void> _takePicture() async {
    if (!_isCameraReady || _cameraController == null)
      return; // ✅ تأكد من التهيئة
    try {
      final XFile file = await _cameraController!.takePicture(); // ✅ استخدم !
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
    _cameraController?.dispose(); // ✅ استخدم ?.dispose()
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ✅ عرض رسالة الخطأ أو الكاميرا
        if (_cameraError)
          const Center(child: Text('❌ خطأ في تهيئة الكاميرا'))
        else if (_isCameraReady &&
            _cameraController != null) // ✅ تأكد من _cameraController
          SizedBox(
            height: 150, // ارتفاع كافٍ للكاميرا
            child: Stack(
              fit: StackFit.expand,
              children: [
                // كاميرا
                CameraPreview(_cameraController!), // ✅ استخدم !
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
