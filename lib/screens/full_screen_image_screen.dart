import 'dart:io';
import 'package:flutter/material.dart';

class FullScreenImageScreen extends StatefulWidget {
  final List<String> imagePaths;
  final int initialIndex;

  const FullScreenImageScreen({
    super.key,
    required this.imagePaths,
    required this.initialIndex,
  });

  @override
  State<FullScreenImageScreen> createState() => _FullScreenImageScreenState();
}

class _FullScreenImageScreenState extends State<FullScreenImageScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          // ✅ تم التعديل على هذا السطر لتجنب الخطأ
          '${_pageController.hasClients && _pageController.page != null ? (_pageController.page!.round() + 1) : (widget.initialIndex + 1)} / ${widget.imagePaths.length}',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.imagePaths.length,
        onPageChanged: (index) {
          setState(() {}); // لتحديث العنوان عند التبديل
        },
        itemBuilder: (context, index) {
          final imagePath = widget.imagePaths[index];
          return InteractiveViewer(
            child: Image.file(
              File(imagePath),
              fit: BoxFit.contain,
            ),
          );
        },
      ),
    );
  }
}
