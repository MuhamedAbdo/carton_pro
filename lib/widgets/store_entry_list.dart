// lib/widgets/store_entry_list.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:carton_pro/models/store_entry_model.dart';
import 'package:carton_pro/widgets/store_entry_card.dart';
import 'package:carton_pro/widgets/store_entry_form.dart';

class StoreEntryList extends StatelessWidget {
  const StoreEntryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<StoreEntry>('storeEntries').listenable(),
      builder: (context, Box<StoreEntry> box, _) {
        if (box.isEmpty) {
          return const Center(child: Text("🚫 لا يوجد تقارير وارد المخزن بعد"));
        }

        // جلب وفرز البيانات حسب التاريخ (من الأحدث للأقدم)
        var entries = box.toMap().entries.toList();
        entries.sort((a, b) {
          final dateA = DateTime.tryParse(a.value.date) ?? DateTime(0);
          final dateB = DateTime.tryParse(b.value.date) ?? DateTime(0);
          return dateB.compareTo(dateA); // ترتيب تنازلي
        });

        return ListView.builder(
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            final dynamic key = entry.key;
            final record = entry.value;
            return StoreEntryCard(
              record: record,
              recordKey: key,
              onEdit: () => StoreEntryForm.show(
                context,
                recordKey: key,
                existingData: _convertStoreEntryToMap(record),
              ),
              onDelete: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('تأكيد الحذف'),
                    content:
                        const Text('هل أنت متأكد أنك تريد حذف هذا التقرير؟'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('إلغاء'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('حذف',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  box.delete(key);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("🗑️ تم حذف التقرير")),
                  );
                }
              },
            );
          },
        );
      },
    );
  }

  Map<String, dynamic> _convertStoreEntryToMap(StoreEntry entry) {
    return {
      'id': entry.id,
      'date': entry.date,
      'product': entry.product,
      'unit': entry.unit,
      'quantity': entry.quantity,
      'supplier': entry.supplier,
      'notes': entry.notes,
      'imagePaths': entry.imageUrls, // استخدم نفس التسمية لتوافق InkReport
    };
  }
}
