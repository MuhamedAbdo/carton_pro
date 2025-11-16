// lib/widgets/maintenance/maintenance_section.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:carton_pro/models/maintenance_record.dart'; // ✅ استيراد النموذج
import 'package:carton_pro/widgets/maintenance/maintenance_list.dart'; // ✅ استيراد القائمة

class MaintenanceSection extends StatefulWidget {
  final String boxName;
  final String? title;

  const MaintenanceSection({
    super.key,
    required this.boxName,
    this.title,
  });

  @override
  State<MaintenanceSection> createState() => _MaintenanceSectionState();
}

class _MaintenanceSectionState extends State<MaintenanceSection> {
  late Future<Box<MaintenanceRecord>> _boxFuture; // ✅ تغيير النوع

  @override
  void initState() {
    super.initState();
    _boxFuture = _openBox();
  }

  Future<Box<MaintenanceRecord>> _openBox() async {
    // ✅ تغيير النوع
    if (!Hive.isBoxOpen(widget.boxName)) {
      await Hive.openBox<MaintenanceRecord>(widget.boxName); // ✅ تغيير النوع
    }
    return Hive.box<MaintenanceRecord>(widget.boxName); // ✅ تغيير النوع
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box<MaintenanceRecord>>(
      // ✅ تغيير النوع
      future: _boxFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text("❌ خطأ: ${snapshot.error}"));
          }

          final box = snapshot.data!; // ✅ نوع الـ box مطابق

          return MaintenanceList(
            // ✅ تمرير الـ box مباشرة
            box: box,
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
