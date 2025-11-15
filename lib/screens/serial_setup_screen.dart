// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../widgets/app_drawer.dart';

class SerialSetupScreen extends StatefulWidget {
  const SerialSetupScreen({super.key});

  @override
  _SerialSetupScreenState createState() => _SerialSetupScreenState();
}

class _SerialSetupScreenState extends State<SerialSetupScreen> {
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController bladeController = TextEditingController();

  bool isWidthActive = true;

  double? a1, t1, a2, t2;

  // Hive box للحالة
  late Box _stateBox;

  String convertToWesternNumbers(String input) {
    const arabicToWestern = {
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9'
    };
    return input.split('').map((char) => arabicToWestern[char] ?? char).join();
  }

  void calculateValues() {
    final double length =
        double.tryParse(convertToWesternNumbers(lengthController.text)) ?? 0.0;
    final double width =
        double.tryParse(convertToWesternNumbers(widthController.text)) ?? 0.0;
    final double blade =
        double.tryParse(convertToWesternNumbers(bladeController.text)) ?? 0.0;

    if (isWidthActive) {
      a1 = blade + (width / 2);
      t1 = blade + width + (length / 2);
      a2 = blade + width + length + (width / 2);
      t2 = blade + width + length + width + (length / 2);
    } else {
      t1 = blade + (length / 2);
      a1 = blade + length + (width / 2);
      t2 = blade + length + width + (length / 2);
      a2 = blade + length + width + length + (width / 2);
    }

    setState(() {});
    saveState(); // حفظ الحالة بعد الحساب
  }

  void toggleCheckbox(bool? value) {
    setState(() {
      isWidthActive = value ?? true;
      calculateValues();
    });
  }

  void clearFields() {
    setState(() {
      lengthController.clear();
      widthController.clear();
      bladeController.clear();
      a1 = null;
      t1 = null;
      a2 = null;
      t2 = null;
      isWidthActive = true;
    });
    saveState();
  }

  void hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    super.initState();
    // تهيئة صندوق Hive
    _initHive();
  }

  Future<void> _initHive() async {
    if (!Hive.isBoxOpen('serial_setup_state')) {
      await Hive.openBox('serial_setup_state');
    }
    _stateBox = Hive.box('serial_setup_state');
    restoreState();
  }

  void restoreState() {
    final state = _stateBox.get('state');
    if (state != null) {
      setState(() {
        lengthController.text = state['length'] ?? '';
        widthController.text = state['width'] ?? '';
        bladeController.text = state['blade'] ?? '';
        a1 = state['a1'];
        t1 = state['t1'];
        a2 = state['a2'];
        t2 = state['t2'];
        isWidthActive = state['isWidthActive'] ?? true;
      });
    }
  }

  void saveState() {
    final state = {
      'length': lengthController.text,
      'width': widthController.text,
      'blade': bladeController.text,
      'a1': a1,
      't1': t1,
      'a2': a2,
      't2': t2,
      'isWidthActive': isWidthActive,
    };
    _stateBox.put('state', state);
  }

  @override
  void dispose() {
    saveState();
    lengthController.dispose();
    widthController.dispose();
    bladeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(), // ✅ الـ Drawer متاح
      appBar: AppBar(
        title: const Text("ضبط تركيب السيريل"),
        centerTitle: true,
        elevation: 1,
      ),
      body: GestureDetector(
        onTap: hideKeyboard,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: lengthController,
                decoration: const InputDecoration(
                  labelText: 'أدخل الطول',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onSubmitted: (_) => calculateValues(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: widthController,
                decoration: const InputDecoration(
                  labelText: 'أدخل العرض',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onSubmitted: (_) => calculateValues(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: bladeController,
                decoration: const InputDecoration(
                  labelText: 'أدخل السلاح الأول',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onSubmitted: (_) => calculateValues(),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: isWidthActive,
                    onChanged: toggleCheckbox,
                  ),
                  const Text('اللسان في العرض'),
                  const SizedBox(width: 20),
                  Checkbox(
                    value: !isWidthActive,
                    onChanged: (value) => toggleCheckbox(!value!),
                  ),
                  const Text('اللسان في الطول'),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: calculateValues,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'حساب',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: clearFields,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'مسح الحقول',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26.withOpacity(0.1),
                      offset: const Offset(0, 4),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: ResultsWidget(
                  a1: isWidthActive ? a1 : t1,
                  t1: isWidthActive ? t1 : a1,
                  a2: isWidthActive ? a2 : t2,
                  t2: isWidthActive ? t2 : a2,
                  isWidthActive: isWidthActive,
                  labels: isWidthActive
                      ? ["ع1", "ط1", "ع2", "ط2"]
                      : ["ط1", "ع1", "ط2", "ع2"],
                  context: context, // ✅ تمرير context
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ✅ Widget لعرض النتائج
class ResultsWidget extends StatelessWidget {
  final double? a1, t1, a2, t2;
  final bool isWidthActive;
  final List<String> labels;
  final BuildContext context; // ✅ استقبال context

  const ResultsWidget({
    super.key,
    required this.a1,
    required this.t1,
    required this.a2,
    required this.t2,
    required this.isWidthActive,
    required this.labels,
    required this.context, // ✅ استقبال context
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildResultRow(labels[0], a1?.toStringAsFixed(2)),
        const SizedBox(height: 12),
        _buildResultRow(labels[1], t1?.toStringAsFixed(2)),
        const SizedBox(height: 12),
        _buildResultRow(labels[2], a2?.toStringAsFixed(2)),
        const SizedBox(height: 12),
        _buildResultRow(labels[3], t2?.toStringAsFixed(2)),
      ],
    );
  }

  Widget _buildResultRow(String label, String? value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .primaryColor
            .withOpacity(0.1), // ✅ استخدام context هنا
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value ?? '--',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
