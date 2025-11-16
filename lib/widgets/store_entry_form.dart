import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:carton_pro/models/store_entry_model.dart';
import 'package:carton_pro/widgets/image_picker_field.dart'; // استيراد ImagePickerField

class StoreEntryForm extends StatefulWidget {
  final dynamic recordKey; // مفتاح الـ record في Hive للتعديل
  final Map<String, dynamic>? existingData;

  const StoreEntryForm({super.key, this.recordKey, this.existingData});

  @override
  State<StoreEntryForm> createState() => _StoreEntryFormState();

  static void show(BuildContext context,
      {dynamic recordKey, Map<String, dynamic>? existingData}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // مهم لعرض الكاميرا
      builder: (context) =>
          StoreEntryForm(recordKey: recordKey, existingData: existingData),
    );
  }
}

class _StoreEntryFormState extends State<StoreEntryForm> {
  late TextEditingController dateController;
  late TextEditingController productController;
  late TextEditingController unitController;
  late TextEditingController quantityController;
  late TextEditingController supplierController;
  late TextEditingController notesController;

  List<String> _imagePaths = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    dateController = TextEditingController();
    productController = TextEditingController();
    unitController = TextEditingController();
    quantityController = TextEditingController();
    supplierController = TextEditingController();
    notesController = TextEditingController();

    if (widget.existingData != null) {
      _loadInitialData(widget.existingData!);
    } else {
      final now = DateTime.now();
      dateController.text =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    }
  }

  void _loadInitialData(Map<String, dynamic> data) {
    dateController.text = data['date'] ?? '';
    productController.text = data['product'] ?? '';
    unitController.text = data['unit'] ?? '';
    quantityController.text = data['quantity']?.toString() ?? '';
    supplierController.text = data['supplier'] ?? '';
    notesController.text = data['notes'] ?? '';

    if (data.containsKey('imagePaths') && data['imagePaths'] is List) {
      _imagePaths = List<String>.from(data['imagePaths']);
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(dateController.text) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      dateController.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  void _save() {
    final box = Hive.box<StoreEntry>('storeEntries');

    final record = StoreEntry(
      id: widget.recordKey?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      date: dateController.text,
      product: productController.text,
      unit: unitController.text,
      quantity: int.tryParse(quantityController.text.trim()) ?? 0,
      supplier: supplierController.text,
      notes: notesController.text.trim(),
      imageUrls: _imagePaths,
    );

    if (widget.recordKey == null) {
      box.add(record);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ تم إضافة تقرير وارد المخزن")),
        );
      }
    } else {
      box.put(widget.recordKey, record);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ تم تحديث تقرير وارد المخزن")),
        );
      }
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    dateController.dispose();
    productController.dispose();
    unitController.dispose();
    quantityController.dispose();
    supplierController.dispose();
    notesController.dispose();
    super.dispose();
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
                widget.recordKey == null ? "🆕 إضافة وارد" : "✏️ تعديل وارد",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: dateController,
                readOnly: true,
                onTap: _selectDate,
                decoration: const InputDecoration(
                    labelText: "📅 التاريخ", border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? "مطلوب" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: productController,
                decoration: const InputDecoration(
                    labelText: "📦 اسم الصنف", border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? "مطلوب" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: unitController,
                decoration: const InputDecoration(
                    labelText: "📏 وحدة القياس", border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? "مطلوب" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: "🔢 الكمية", border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? "مطلوب" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: supplierController,
                decoration: const InputDecoration(
                    labelText: "📥 اسم المورد", border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? "مطلوب" : null,
              ),
              const SizedBox(height: 16),
              // إضافة ImagePickerField
              const Text("📸 الصور (اختياري)",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ImagePickerField(
                imagePaths: _imagePaths,
                onImagesChanged: (paths) {
                  setState(() {
                    _imagePaths = paths;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                    labelText: "📝 ملاحظات", border: OutlineInputBorder()),
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
                          onPressed: _save,
                          child: const Text("💾 حفظ التقرير"))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
