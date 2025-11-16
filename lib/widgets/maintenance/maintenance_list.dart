import 'dart:io'; // ✅ استيراد dart:io لاستخدام File
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:carton_pro/models/maintenance_record.dart';
import 'package:carton_pro/widgets/maintenance/maintenance_form.dart';
import 'package:carton_pro/screens/full_screen_image_screen.dart'; // ✅ استيراد الشاشة

class MaintenanceList extends StatelessWidget {
  final Box<MaintenanceRecord> box;

  const MaintenanceList({
    super.key,
    required this.box,
  });

  Future<void> _confirmDelete(BuildContext context, dynamic key) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف سجل'),
        content: const Text('هل أنت متأكد من حذف سجل الصيانة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      box.delete(key);
      if (ScaffoldMessenger.maybeOf(context) != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ تم حذف السجل')),
        );
      }
    }
  }

  Map<String, dynamic> _recordToMap(MaintenanceRecord r) {
    // Attempt to map common fields used in the form. If your model uses other names, adapt here.
    return {
      'date': r.date,
      'machine': r.machine,
      'issue': r.issue,
      'reportDate': r.reportDate,
      'technician': r.technician,
      'action': r.action,
      'actionDate': r.actionDate,
      'repairedBy': r.repairedBy,
      'notes': r.notes,
      'isFixed': r.isFixed,
      'repairLocation': r.repairLocation,
      'image_urls': r.imageUrls, // ✅ إضافة مسارات الصور
    };
  }

  @override
  Widget build(BuildContext context) {
    // Use ValueListenableBuilder so the list updates automatically on box changes
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<MaintenanceRecord> b, _) {
          final entries = b.toMap().entries.toList();
          if (entries.isEmpty) {
            return const Center(child: Text('لا توجد سجلات صيانة'));
          }

          // Optionally sort by date or insertion order. Keep insertion order here.
          return ListView.separated(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: entries.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final entry = entries[index];
              final key = entry.key;
              final record = entry.value;

              // ✅ بناء قائمة الـ Widgets لعرضها في Column
              List<Widget> recordDetails = [
                // التاريخ
                if (record.date.isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.date_range,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text("📅 ${record.date}"),
                    ],
                  ),
                // اسم الماكينة
                if (record.machine.isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.factory, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text("🏭 ${record.machine}"),
                    ],
                  ),
                // وصف العطل
                if (record.issue.isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.warning, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text("⚠️ ${record.issue}"),
                    ],
                  ),
                // تاريخ التبليغ
                if (record.reportDate.isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.report, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text("🗓️ ${record.reportDate}"),
                    ],
                  ),
                // تم التبليغ إلى
                if (record.technician.isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text("👷‍♂️ ${record.technician}"),
                    ],
                  ),
                // الإجراء المتخذ
                if (record.action.isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.build, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text("🔧 ${record.action}"),
                    ],
                  ),
                // تاريخ التنفيذ
                if (record.actionDate.isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.check_circle,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text("📆 ${record.actionDate}"),
                    ],
                  ),
                // تم الإصلاح
                Row(
                  children: [
                    const Icon(Icons.done, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text("✅ تم الإصلاح: ${record.isFixed ? 'نعم' : 'لا'}"),
                  ],
                ),
                // مكان الإصلاح
                if (record.repairLocation.isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text("🏠 مكان الإصلاح: ${record.repairLocation}"),
                    ],
                  ),
                // تم الإصلاح بواسطة
                if (record.repairedBy != null && record.repairedBy!.isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.engineering,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text("🛠️ تم الإصلاح بواسطة: ${record.repairedBy}"),
                    ],
                  ),
                // الملاحظات
                if (record.notes != null && record.notes!.isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.note, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text("📝 ${record.notes}"),
                    ],
                  ),
                // ✅ عرض الصور
                if (record.imageUrls.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      height: 80, // ارتفاع أكبر قليلًا
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: record.imageUrls.length,
                        itemBuilder: (context, i) {
                          final imagePath = record.imageUrls[i];
                          final file =
                              File(imagePath); // ✅ تحويل المسار إلى File

                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
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
                                      builder: (context) =>
                                          FullScreenImageScreen(
                                        imagePaths:
                                            record.imageUrls, // مرر قائمة الصور
                                        initialIndex:
                                            i, // مرر مؤشر الصورة الحالية
                                      ),
                                    ),
                                  );
                                },
                                child: Image.file(
                                  // ✅ استخدام Image.file للصور المحلية
                                  file,
                                  width: 70, // عرض الصورة
                                  height: 70, // ارتفاع الصورة
                                  fit: BoxFit
                                      .cover, // ✅ ملء المساحة المحددة (متكسرة)
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
                  ),
              ];

              return Dismissible(
                key: ValueKey(key),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (_) async {
                  await _confirmDelete(context, key);
                  // Return false because _confirmDelete already deleted when confirmed.
                  // Returning true would try to delete again via Dismissible's default behaviour.
                  return false;
                },
                child: ListTile(
                  title: Text(record.machine.isNotEmpty
                      ? record.machine
                      : 'سجل صيانة'), // ✅ استخدام اسم الماكينة كعنوان
                  // ✅ استخدام Column لعرض التفاصيل
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: recordDetails,
                  ),
                  // ✅ إزالة isThreeLine لأن التفاصيل في Column
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        MaintenanceForm.show(
                          context,
                          recordKey: key,
                          existingData: _recordToMap(record),
                        );
                      } else if (value == 'delete') {
                        _confirmDelete(context, key);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('تعديل')),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('حذف', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                  onTap: () {
                    MaintenanceForm.show(
                      context,
                      recordKey: key,
                      existingData: _recordToMap(record),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      // ✅ Floating Action Button في أسفل اليمين باستخدام Scaffold
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            MaintenanceForm.show(context), // ✅ استدعاء النموذج لإضافة سجل جديد
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // ✅ تحديد الموقع أسفل اليمين
    );
  }
}
