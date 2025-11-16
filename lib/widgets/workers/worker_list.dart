// lib/widgets/worker_list.dart
import 'package:carton_pro/widgets/workers/worker_card.dart';
import 'package:carton_pro/widgets/workers/worker_form.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:carton_pro/models/worker_model.dart';
import 'package:carton_pro/screens/worker_details_screen.dart'; // ✅ استيراد الشاشة

class WorkerList extends StatefulWidget {
  const WorkerList({super.key});

  @override
  State<WorkerList> createState() => _WorkerListState();
}

class _WorkerListState extends State<WorkerList> {
  // Search
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ✅ TextField للبحث في الـ Column مباشرة تحت AppBar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocus,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) {
              setState(() {
                _searchQuery = _searchController.text.trim();
              });
              _searchFocus.unfocus();
            },
            decoration: InputDecoration(
              hintText: 'ابحث بالاسم أو الوظيفة',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Theme.of(context).cardColor,
              prefixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    _searchQuery = _searchController.text.trim();
                  });
                  _searchFocus.unfocus();
                },
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            style: const TextStyle(),
          ),
        ),
        const SizedBox(height: 8),
        // القائمة
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: Hive.box<Worker>('workers').listenable(),
            builder: (context, Box<Worker> box, _) {
              if (box.isEmpty) {
                return const Center(child: Text("🚫 لا يوجد عمال بعد"));
              }

              // ✅ تصفية البيانات حسب البحث
              var filteredWorkers = box.values.toList();
              if (_searchQuery.isNotEmpty) {
                filteredWorkers = filteredWorkers
                    .where((worker) =>
                        worker.name
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()) ||
                        worker.job
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()))
                    .toList();
              }

              // ✅ ترتيب حسب الاسم
              filteredWorkers.sort((a, b) => a.name.compareTo(b.name));

              return ListView.builder(
                itemCount: filteredWorkers.length,
                itemBuilder: (context, index) {
                  final worker = filteredWorkers[index];
                  final dynamic hiveKey = box
                      .toMap()
                      .entries
                      .firstWhere((entry) => entry.value == worker)
                      .key;

                  return WorkerCard(
                    worker: worker,
                    recordKey: hiveKey,
                    onEdit: () => WorkerForm.show(
                      context,
                      recordKey: hiveKey,
                      existingData: _convertWorkerToMap(worker),
                    ),
                    onDelete: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('تأكيد الحذف'),
                          content: const Text(
                              'هل أنت متأكد أنك تريد حذف هذا العامل؟'),
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
                          const SnackBar(content: Text("🗑️ تم حذف العامل")),
                        );
                      }
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WorkerDetailsScreen(worker: worker),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Map<String, dynamic> _convertWorkerToMap(Worker worker) {
    return {
      'name': worker.name,
      'phone': worker.phone,
      'job': worker.job,
      'has_medical_insurance': worker.hasMedicalInsurance,
      'actions': worker.actions.map((action) => action.toJson()).toList(),
    };
  }
}
