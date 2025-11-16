import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:carton_pro/models/store_entry_model.dart';
import 'package:carton_pro/widgets/store_entry_card.dart';
import 'package:carton_pro/widgets/store_entry_form.dart';

class StoreEntryList extends StatefulWidget {
  final bool sortDescending; // ✅ استقبال المتغيرات من StoreEntryScreen
  final bool onlyWithImages;

  const StoreEntryList({
    super.key,
    required this.sortDescending,
    required this.onlyWithImages,
  });

  @override
  State<StoreEntryList> createState() => _StoreEntryListState();
}

class _StoreEntryListState extends State<StoreEntryList> {
  DateTime _parseDateSafe(String dateStr) {
    if (dateStr.isEmpty) return DateTime.fromMillisecondsSinceEpoch(0);
    DateTime? dt = DateTime.tryParse(dateStr);
    if (dt != null) return dt;
    try {
      final parts = dateStr.split(RegExp(r'[-/]'));
      if (parts.length >= 3) {
        if (parts[0].length == 4) {
          final y = int.parse(parts[0]);
          final m = int.parse(parts[1]);
          final d = int.parse(parts[2]);
          return DateTime(y, m, d);
        } else {
          final d = int.parse(parts[0]);
          final m = int.parse(parts[1]);
          final y = int.parse(parts[2]);
          return DateTime(y, m, d);
        }
      }
    } catch (_) {}
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  List<MapEntry<dynamic, StoreEntry>> _prepareRecords(Box<StoreEntry> box) {
    var entries = box.toMap().entries.toList();

    entries.sort((a, b) {
      final da = _parseDateSafe(a.value.date);
      final db = _parseDateSafe(b.value.date);
      return db.compareTo(
          da); // ترتيب تصاعدي أو تنازلي حسب widget.sortDescending لاحقًا
    });

    if (!widget.sortDescending) {
      // ✅ استخدام المتغير من widget
      entries = entries.reversed.toList();
    }

    var filtered = entries;
    if (widget.onlyWithImages) {
      // ✅ استخدام المتغير من widget
      filtered = filtered.where((e) => e.value.imageUrls.isNotEmpty).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      // ✅ استخدام Stack لوضع الزر في الأسفل
      children: [
        ValueListenableBuilder(
          valueListenable: Hive.box<StoreEntry>('storeEntries').listenable(),
          builder: (context, Box<StoreEntry> box, _) {
            if (box.isEmpty) {
              return const Center(
                  child: Text("🚫 لا يوجد تقارير وارد المخزن بعد"));
            }

            final prepared = _prepareRecords(box);

            if (prepared.isEmpty) {
              return const Center(
                child: Text('لا توجد تقارير تطابق الفلاتر'),
              );
            }

            return ListView.builder(
              itemCount: prepared.length,
              itemBuilder: (context, index) {
                final entry = prepared[index];
                final dynamic hiveKey = entry.key;
                final record = entry.value;
                return StoreEntryCard(
                  record: record,
                  recordKey: hiveKey,
                  onEdit: () => StoreEntryForm.show(
                    context,
                    recordKey: hiveKey,
                    existingData: _convertStoreEntryToMap(record),
                  ),
                  onDelete: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('تأكيد الحذف'),
                        content: const Text(
                            'هل أنت متأكد أنك تريد حذف هذا التقرير؟'),
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
                      box.delete(hiveKey);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("🗑️ تم حذف التقرير")),
                      );
                    }
                  },
                );
              },
            );
          },
        ),
        // ✅ Floating Action Button في أسفل اليمين
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: () => StoreEntryForm.show(context),
            child: const Icon(Icons.add),
          ),
        ),
      ],
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
