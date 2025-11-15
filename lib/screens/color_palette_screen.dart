import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_drawer.dart';

// ✅ نسخة من موديل CMYK
class CMYK {
  final int c, m, y, k;

  CMYK(this.c, this.m, this.y, this.k);

  // تحويل CMYK إلى RGB (0-255)
  List<int> toRGB() {
    double c = this.c / 100.0;
    double m = this.m / 100.0;
    double y = this.y / 100.0;
    double k = this.k / 100.0;

    double r = 255 * (1 - c) * (1 - k);
    double g = 255 * (1 - m) * (1 - k);
    double b = 255 * (1 - y) * (1 - k);

    return [
      r.round().clamp(0, 255).toInt(),
      g.round().clamp(0, 255).toInt(),
      b.round().clamp(0, 255).toInt(),
    ];
  }

  String toHex() {
    List<int> rgb = toRGB();
    return '#${rgb[0].toRadixString(16).padLeft(2, '0')}'
            '${rgb[1].toRadixString(16).padLeft(2, '0')}'
            '${rgb[2].toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();
  }

  @override
  String toString() => 'C:$c% M:$m% Y:$y% K:$k%';
}

// ✅ نسخة من normalizeTo100
CMYK normalizeTo100(CMYK original) {
  int total = original.c + original.m + original.y + original.k;
  if (total == 0) return CMYK(0, 0, 0, 0);
  double factor = 100.0 / total;
  return CMYK(
    (original.c * factor).round().clamp(0, 100).toInt(),
    (original.m * factor).round().clamp(0, 100).toInt(),
    (original.y * factor).round().clamp(0, 100).toInt(),
    (original.k * factor).round().clamp(0, 100).toInt(),
  );
}

class ColorPaletteScreen extends StatelessWidget {
  const ColorPaletteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // إنشاء ألوان CMYK
    final colors = _generateCMYKColors();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'بالتة ألوان',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 1,
        actions: [
          // أيقونة الكاميرا
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () {
              // TODO: Navigate to Camera Screen
              _showSnackBar(context, 'الكاميرا');
            },
          ),
          // أيقونة التركيب اليدوي
          IconButton(
            icon: const Icon(Icons.opacity),
            onPressed: () {
              // TODO: Navigate to Manual Mix Screen
              _showSnackBar(context, 'التركيب اليدوي');
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 0.8,
          ),
          itemCount: colors.length,
          itemBuilder: (context, index) {
            final color = colors[index];
            final rgb = color.toRGB();
            final displayColor = Color.fromRGBO(rgb[0], rgb[1], rgb[2], 1.0);

            return GestureDetector(
              onTap: () {
                // TODO: Navigate to Color Detail Screen
                _showSnackBar(context, color.toString());
              },
              child: Container(
                decoration: BoxDecoration(
                  color: displayColor,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                    width: 0.5,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<CMYK> _generateCMYKColors() {
    // إنشاء 200 لون (كما في الكود الأصلي)
    final List<CMYK> colors = [];
    final Random rand = Random();

    for (int i = 0; i < 200; i++) {
      // إنشاء لون عشوائي
      int c = rand.nextInt(101); // 0-100
      int m = rand.nextInt(101); // 0-100
      int y = rand.nextInt(101); // 0-100
      int k = rand.nextInt(101); // 0-100

      // ضمان المجموع = 100%
      int sum = c + m + y + k;
      if (sum != 100) {
        k = 100 - c - m - y;
        k = k.clamp(0, 100).toInt(); // تأمين القيمة
      }

      colors.add(CMYK(c, m, y, k));
    }

    return colors;
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
