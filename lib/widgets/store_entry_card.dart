import 'dart:io'; // ✅ استيراد dart:io لاستخدام File
import 'package:flutter/material.dart';
import 'package:carton_pro/models/store_entry_model.dart';
import 'package:carton_pro/screens/full_screen_image_screen.dart'; // ✅ استيراد الشاشة

class StoreEntryCard extends StatelessWidget {
  final StoreEntry record;
  final dynamic recordKey; // مفتاح الـ record في Hive
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const StoreEntryCard({
    super.key,
    required this.record,
    required this.recordKey,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text("📅 ${record.date}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📦 الصنف: ${record.product}"),
            Text("📏 الوحدة: ${record.unit}"),
            Text("🔢 الكمية: ${record.quantity}"),
            Text("📥 المورد: ${record.supplier}"),
            if (record.notes != null && record.notes!.isNotEmpty)
              Text("📝 ملاحظات: ${record.notes}"),
            // ✅ تعديل عرض الصور (إذا وُجدت) - صور محلية مع نقر لفتح بملء الشاشة
            if (record.imageUrls.isNotEmpty)
              SizedBox(
                height: 80, // ارتفاع أكبر قليلًا
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: record.imageUrls.length,
                  itemBuilder: (context, i) {
                    final imagePath = record.imageUrls[i];
                    final file = File(imagePath); // ✅ تحويل المسار إلى File

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ClipRRect(
                        // ✅ استخدام ClipRRect لجعل الزوايا مربعة
                        // borderRadius: BorderRadius.circular(8), // ❌ أزل هذا السطر
                        child: GestureDetector(
                          // ✅ إضافة GestureDetector
                          onTap: () {
                            // ✅ Navigate لشاشة العرض الكامل
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImageScreen(
                                  imagePaths:
                                      record.imageUrls, // مرر قائمة الصور
                                  initialIndex: i, // مرر مؤشر الصورة الحالية
                                ),
                              ),
                            );
                          },
                          child: Image.file(
                            // ✅ استخدام Image.file للصور المحلية
                            file,
                            width: 70, // عرض الصورة
                            height: 70, // ارتفاع الصورة
                            fit: BoxFit.cover, // ✅ ملء المساحة المحددة (متكسرة)
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 70,
                              height: 70,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: onEdit),
            IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
