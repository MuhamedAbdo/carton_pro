// lib/widgets/maintenance/maintenance_form.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; // ✅ استيراد hive_flutter
import 'package:carton_pro/models/maintenance_record.dart'; // ✅ استيراد النموذج
import 'package:carton_pro/widgets/image_picker_field.dart'; // ✅ استيراد ImagePickerField
import 'package:provider/provider.dart'; // ✅ استيراد provider لجلب ThemeService
import 'package:carton_pro/services/theme_service.dart'; // ✅ استيراد ThemeService

class MaintenanceForm extends StatefulWidget {
  final dynamic recordKey; // ✅ مفتاح الـ record في Hive للتعديل
  final Map<String, dynamic>? existingData; // ✅ بيانات موجودة (لتعديل)

  const MaintenanceForm({
    super.key,
    this.recordKey,
    this.existingData,
  });

  @override
  State<MaintenanceForm> createState() => _MaintenanceFormState();

  // ✅ دالة static لفتح النموذج
  static void show(BuildContext context,
      {dynamic recordKey, Map<String, dynamic>? existingData}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // مهم لعرض الكاميرا (إذا أضفت لاحقًا)
      builder: (context) =>
          MaintenanceForm(recordKey: recordKey, existingData: existingData),
    );
  }
}

class _MaintenanceFormState extends State<MaintenanceForm> {
  late TextEditingController issueDateController;
  late TextEditingController machineController;
  late TextEditingController issueDescController;
  late TextEditingController reportDateController;
  late TextEditingController reportedToTechnicianController;
  late TextEditingController actionController;
  late TextEditingController actionDateController;
  late TextEditingController repairedByController;
  late TextEditingController notesController;

  List<String> _imagePaths = []; // ✅ متغير لحفظ مسارات الصور

  // ✅ إضافة متغير لجودة الكاميرا
  late double _cameraQuality;

  bool isFixed = false;
  String repairLocation = 'في المصنع';

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    // ✅ جلب جودة الكاميرا من ThemeService
    _cameraQuality = context.read<ThemeService>().settings.cameraQuality;
  }

  void _initializeControllers() {
    issueDateController = TextEditingController();
    machineController = TextEditingController();
    issueDescController = TextEditingController();
    reportDateController = TextEditingController();
    reportedToTechnicianController = TextEditingController();
    actionController = TextEditingController();
    actionDateController = TextEditingController();
    repairedByController = TextEditingController();
    notesController = TextEditingController();

    if (widget.existingData != null) {
      _loadInitialData(widget.existingData!);
    } else {
      final now = DateTime.now();
      issueDateController.text =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      reportDateController.text =
          issueDateController.text; // ✅ افتراض نفس التاريخ
      actionDateController.text =
          issueDateController.text; // ✅ افتراض نفس التاريخ
    }
  }

  void _loadInitialData(Map<String, dynamic> data) {
    issueDateController.text = data['date'] ?? '';
    machineController.text = data['machine'] ?? '';
    issueDescController.text = data['issue'] ?? '';
    reportDateController.text = data['reportDate'] ?? '';
    reportedToTechnicianController.text = data['technician'] ?? '';
    actionController.text = data['action'] ?? '';
    actionDateController.text = data['actionDate'] ?? '';
    repairedByController.text = data['repairedBy'] ?? '';
    notesController.text = data['notes'] ?? '';

    isFixed = data['isFixed'] == true; // ✅ حقل جديد
    repairLocation = data['repairLocation'] ?? 'في المصنع'; // ✅ حقل جديد

    // ✅ تحميل مسارات الصور من البيانات الحالية
    if (data.containsKey('image_urls') && data['image_urls'] is List) {
      _imagePaths = List<String>.from(data['image_urls']);
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.text.isNotEmpty
          ? DateTime.tryParse(controller.text) ?? DateTime.now()
          : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    // ✅ تحقق من أن picked مش null قبل استخدامه
    if (picked != null) {
      controller.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
    // إذا كان picked == null، فده معناه إن المستخدم مش فاتح على اختيار تاريخ، فمفيش حاجة تتعمل
  }

  void _saveRecord() {
    final record = MaintenanceRecord(
      date: issueDateController.text,
      machine: machineController.text,
      issue: issueDescController.text,
      technician: reportedToTechnicianController.text,
      action: actionController.text,
      notes: notesController.text,
      reportDate: reportDateController.text, // ✅ حقل جديد
      actionDate: actionDateController.text, // ✅ حقل جديد
      isFixed: isFixed, // ✅ حقل جديد
      repairLocation: repairLocation, // ✅ حقل جديد
      repairedBy: repairedByController.text.isNotEmpty
          ? repairedByController.text
          : null, // ✅ حقل جديد
      imageUrls: _imagePaths, // ✅ حقل جديد
    );

    // ✅ استخدام Hive لحفظ السجل
    final box = Hive.box<MaintenanceRecord>('maintenanceRecords');
    if (widget.recordKey == null) {
      box.add(record);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ تم إضافة سجل الصيانة")),
        );
      }
    } else {
      box.put(widget.recordKey, record);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ تم تحديث سجل الصيانة")),
        );
      }
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    issueDateController.dispose();
    machineController.dispose();
    issueDescController.dispose();
    reportDateController.dispose();
    reportedToTechnicianController.dispose();
    actionController.dispose();
    actionDateController.dispose();
    repairedByController.dispose();
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
          child: Form(
            // ✅ Form لدعم ImagePickerField
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.recordKey == null ? "🆕 إضافة سجل" : "✏️ تعديل سجل",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                    controller: issueDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                        labelText: "📅 تاريخ ظهور العطل",
                        border: OutlineInputBorder()),
                    onTap: () => _selectDate(context, issueDateController)),
                const SizedBox(height: 12),
                TextFormField(
                    controller: machineController,
                    decoration: const InputDecoration(
                        labelText: "🏭 اسم الماكينة",
                        border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextFormField(
                    controller: issueDescController,
                    decoration: const InputDecoration(
                        labelText: "⚠️ وصف العطل",
                        border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextFormField(
                    controller: reportDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                        labelText: "🗓️ تاريخ التبليغ",
                        border: OutlineInputBorder()),
                    onTap: () => _selectDate(context, reportDateController)),
                const SizedBox(height: 12),
                TextFormField(
                    controller: reportedToTechnicianController,
                    decoration: const InputDecoration(
                        labelText: "👷‍♂️ تم التبليغ إلى",
                        border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextFormField(
                    controller: actionController,
                    decoration: const InputDecoration(
                        labelText: "🔧 الإجراء المتخذ",
                        border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextFormField(
                    controller: actionDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                        labelText: "📆 تاريخ التنفيذ",
                        border: OutlineInputBorder()),
                    onTap: () => _selectDate(context, actionDateController)),
                const SizedBox(height: 12),
                Row(children: [
                  const Text("✅ تم الإصلاح؟"),
                  Checkbox(
                      value: isFixed,
                      onChanged: (v) => setState(() => isFixed = v ?? false)),
                ]),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: repairLocation,
                  items: const [
                    DropdownMenuItem(
                        value: 'في المصنع', child: Text('في المصنع')),
                    DropdownMenuItem(
                        value: 'ورشة خارجية', child: Text('ورشة خارجية')),
                  ],
                  onChanged: (v) =>
                      setState(() => repairLocation = v ?? 'في المصنع'),
                  decoration: const InputDecoration(
                      labelText: "🏠 مكان الإصلاح",
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextFormField(
                    controller: repairedByController,
                    decoration: const InputDecoration(
                        labelText: "🛠 تم الإصلاح بواسطة",
                        border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextFormField(
                    controller: notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                        labelText: "📝 ملاحظات", border: OutlineInputBorder())),
                const SizedBox(height: 16),
                // ✅ إضافة ImagePickerField
                const Text("📸 صور العطل",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ImagePickerField(
                  imagePaths: _imagePaths,
                  onImagesChanged: (paths) {
                    setState(() {
                      _imagePaths = paths;
                    });
                  },
                  cameraQuality: _cameraQuality, // ✅ تمرير جودة الكاميرا
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
                            onPressed: _saveRecord,
                            child: const Text("💾 حفظ"))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
