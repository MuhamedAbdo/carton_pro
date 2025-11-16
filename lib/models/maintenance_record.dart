// lib/models/maintenance_record.dart
import 'package:hive/hive.dart';

part 'maintenance_record.g.dart';

@HiveType(typeId: 5)
class MaintenanceRecord extends HiveObject {
  @HiveField(0)
  final String date;

  @HiveField(1)
  final String machine;

  @HiveField(2)
  final String issue;

  @HiveField(3)
  final String technician;

  @HiveField(4)
  final String action;

  @HiveField(5)
  final String? notes;

  @HiveField(6)
  final String reportDate;

  @HiveField(7)
  final String actionDate;

  @HiveField(8)
  final bool isFixed;

  @HiveField(9)
  final String repairLocation;

  @HiveField(10)
  final String? repairedBy;

  @HiveField(11)
  final List<String> imageUrls;

  MaintenanceRecord({
    required this.date,
    required this.machine,
    required this.issue,
    required this.technician,
    required this.action,
    this.notes,
    required this.reportDate,
    required this.actionDate,
    required this.isFixed,
    required this.repairLocation,
    this.repairedBy,
    required this.imageUrls,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'machine': machine,
      'issue': issue,
      'technician': technician,
      'action': action,
      'notes': notes,
      'reportDate': reportDate,
      'actionDate': actionDate,
      'isFixed': isFixed,
      'repairLocation': repairLocation,
      'repairedBy': repairedBy,
      'image_urls': imageUrls,
    };
  }

  factory MaintenanceRecord.fromJson(Map<String, dynamic> map) {
    // ✅ معالجة image_urls بشكل آمن
    List<String> parsedImages = [];

    if (map['image_urls'] != null) {
      if (map['image_urls'] is List) {
        try {
          parsedImages = List<String>.from(map['image_urls']);
        } catch (e) {
          // إذا فشل التحويل، نحاول تحويل كل عنصر إلى string
          parsedImages =
              (map['image_urls'] as List).map((e) => e.toString()).toList();
        }
      }
    }

    // ✅ قيم افتراضية آمنة لجميع الحقول
    return MaintenanceRecord(
      date: map['date']?.toString() ?? '',
      machine: map['machine']?.toString() ?? '',
      issue: map['issue']?.toString() ?? '',
      technician: map['technician']?.toString() ?? '',
      action: map['action']?.toString() ?? '',
      notes: map['notes']?.toString(),
      reportDate: map['reportDate']?.toString() ?? '',
      actionDate: map['actionDate']?.toString() ?? '',
      isFixed: map['isFixed'] == true,
      repairLocation: map['repairLocation']?.toString() ?? 'في المصنع',
      repairedBy: map['repairedBy']?.toString(),
      imageUrls: parsedImages, // ✅ دائماً قائمة وليست null
    );
  }

  // ✅ إنشاء نسخة جديدة مع تحديث بعض الحقول
  MaintenanceRecord copyWith({
    String? date,
    String? machine,
    String? issue,
    String? technician,
    String? action,
    String? notes,
    String? reportDate,
    String? actionDate,
    bool? isFixed,
    String? repairLocation,
    String? repairedBy,
    List<String>? imageUrls,
  }) {
    return MaintenanceRecord(
      date: date ?? this.date,
      machine: machine ?? this.machine,
      issue: issue ?? this.issue,
      technician: technician ?? this.technician,
      action: action ?? this.action,
      notes: notes ?? this.notes,
      reportDate: reportDate ?? this.reportDate,
      actionDate: actionDate ?? this.actionDate,
      isFixed: isFixed ?? this.isFixed,
      repairLocation: repairLocation ?? this.repairLocation,
      repairedBy: repairedBy ?? this.repairedBy,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }
}
