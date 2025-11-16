// lib/screens/maintenance_screen.dart
import 'package:carton_pro/widgets/maintenance/maintenance_section.dart';
import 'package:flutter/material.dart';
import 'package:carton_pro/widgets/app_drawer.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("🛠 سجلات الصيانة"),
        centerTitle: true,
      ),
      body: const MaintenanceSection(
        boxName: 'maintenanceRecords', // ✅ اسم الـ box
        title:
            "سجلات الصيانة", // ✅ عنوان القسم (ممكن تستخدمه في MaintenanceSection)
      ),
    );
  }
}
