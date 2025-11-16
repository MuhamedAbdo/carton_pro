// lib/widgets/worker_form.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:carton_pro/models/worker_model.dart';

class WorkerForm extends StatefulWidget {
  final dynamic recordKey; // ✅ مفتاح الـ record في Hive للتعديل
  final Map<String, dynamic>? existingData; // ✅ بيانات موجودة (لتعديل)

  const WorkerForm({super.key, this.recordKey, this.existingData});

  @override
  State<WorkerForm> createState() => _WorkerFormState();

  // ✅ الدالة الثابتة لفتح الـ Dialog
  static void show(BuildContext context,
      {dynamic recordKey, Map<String, dynamic>? existingData}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          WorkerForm(recordKey: recordKey, existingData: existingData),
    );
  }
}

class _WorkerFormState extends State<WorkerForm> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late String job;

  final jobOptions = ['رئيس القسم', 'مشرف', 'فني', 'عامل', 'مساعد'];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    job = 'عامل';

    if (widget.existingData != null) {
      _loadInitialData(widget.existingData!);
    }
  }

  void _loadInitialData(Map<String, dynamic> data) {
    nameController.text = data['name'] ?? '';
    phoneController.text = data['phone'] ?? '';
    job = data['job'] ?? 'عامل';
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _saveWorker() {
    final record = Worker(
      name: nameController.text,
      phone: phoneController.text,
      job: job,
      actions: [], // actions فارغة عند الإضافة
      hasMedicalInsurance: false, // افتراضي
    );

    final box = Hive.box<Worker>('workers');
    if (widget.recordKey == null) {
      box.add(record);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ تم إضافة العامل")),
        );
      }
    } else {
      box.put(widget.recordKey, record);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ تم تحديث بيانات العامل")),
        );
      }
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.recordKey == null ? "🆕 إضافة عامل" : "✏️ تعديل العامل",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: "👤 الاسم", border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                      labelText: "📞 الهاتف", border: OutlineInputBorder()),
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: job,
                items: jobOptions
                    .map((j) => DropdownMenuItem(value: j, child: Text(j)))
                    .toList(),
                onChanged: (v) => setState(() => job = v ?? 'عامل'),
                decoration: const InputDecoration(
                    labelText: "🛠 الوظيفة", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                      child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("❌ إلغاء"))),
                  const SizedBox(width: 8),
                  Expanded(
                      child: ElevatedButton(
                          onPressed: _saveWorker, child: const Text("💾 حفظ"))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
