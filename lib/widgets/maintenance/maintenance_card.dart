// lib/widgets/maintenance/maintenance_card.dart
import 'package:flutter/material.dart';
import 'package:carton_pro/models/maintenance_record.dart'; // ✅ استيراد النموذج

class MaintenanceCard extends StatelessWidget {
  final MaintenanceRecord record; // ✅ تغيير من Map إلى MaintenanceRecord
  final dynamic recordKey; // ✅ مفتاح الـ record في Hive
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MaintenanceCard({
    super.key,
    required this.record,
    required this.recordKey, // ✅ مفتاح الـ record في Hive
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text("📅 ${record.date}"), // ✅ استخدام الحقل مباشرة
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🏭 ${record.machine}"),
            Text("⚠️ ${record.issue}"),
            Text("🗓️ ${record.reportDate}"), // ✅ حقل جديد
            Text("👷‍♂️ ${record.technician}"),
            Text("🔧 ${record.action}"),
            Text("📆 ${record.actionDate}"), // ✅ حقل جديد
            Text(
                "✅ تم الإصلاح: ${record.isFixed ? 'نعم' : 'لا'}"), // ✅ حقل جديد
            Text("🏠 مكان الإصلاح: ${record.repairLocation}"), // ✅ حقل جديد
            if (record.repairedBy != null &&
                record.repairedBy!.isNotEmpty) // ✅ حقل جديد
              Text("🛠 تم الإصلاح بواسطة: ${record.repairedBy}"),
            if (record.notes != null && record.notes!.isNotEmpty)
              Text("📝 ملاحظات: ${record.notes}"),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: onEdit),
            IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
