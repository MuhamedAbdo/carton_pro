import 'package:flutter/material.dart';
import 'package:carton_pro/widgets/app_drawer.dart';
import 'package:carton_pro/widgets/store_entry_list.dart'; // ننقل الـ State لاحقًا

class StoreEntryScreen extends StatefulWidget {
  // ✅ جعلناه StatefulWidget
  const StoreEntryScreen({super.key});

  @override
  State<StoreEntryScreen> createState() => _StoreEntryScreenState();
}

class _StoreEntryScreenState extends State<StoreEntryScreen> {
  // Filter / Sort
  bool _sortDescending = true; // true => الأحدث فوق
  bool _onlyWithImages = false;

  // ✅ نقل دالة الفرز إلى هنا
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        bool tempOnlyWithImages = _onlyWithImages;
        bool tempSortDescending = _sortDescending;
        return StatefulBuilder(builder: (context, setStateSB) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('خيارات الفلترة والترتيب',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('ترتيب حسب التاريخ:'),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButton<bool>(
                        value: tempSortDescending,
                        items: const [
                          DropdownMenuItem(
                              value: true, child: Text('الأحدث أولاً')),
                          DropdownMenuItem(
                              value: false, child: Text('الأقدم أولاً')),
                        ],
                        onChanged: (v) {
                          if (v == null) return;
                          setStateSB(() => tempSortDescending = v);
                        },
                      ),
                    ),
                  ],
                ),
                CheckboxListTile(
                  value: tempOnlyWithImages,
                  onChanged: (v) {
                    setStateSB(() => tempOnlyWithImages = v ?? false);
                  },
                  title: const Text('إظهار التقارير التي تحتوي على صور فقط'),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('إلغاء'),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // ✅ تحديث الحالة في StoreEntryScreen
                            _onlyWithImages = tempOnlyWithImages;
                            _sortDescending = tempSortDescending;
                          });
                          Navigator.pop(ctx);
                        },
                        child: const Text('تطبيق'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("📄 تقارير وارد المخزن"),
        centerTitle: true,
        // ✅ زر الفرز في actions
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet, // ✅ استدعاء الدالة من هنا
          ),
        ],
      ),
      body: StoreEntryList(
        // ✅ تمرير المتغيرات إلى StoreEntryList
        sortDescending: _sortDescending,
        onlyWithImages: _onlyWithImages,
      ),
    );
  }
}
