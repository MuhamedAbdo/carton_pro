// lib/models/maintenance_record.g.dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MaintenanceRecordAdapter extends TypeAdapter<MaintenanceRecord> {
  @override
  final int typeId = 5;

  @override
  MaintenanceRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    // ✅ معالجة آمنة لـ imageUrls - هذا هو الحل الرئيسي
    List<String> imageUrls = [];
    if (fields[11] != null && fields[11] is List) {
      try {
        imageUrls = (fields[11] as List).cast<String>();
      } catch (e) {
        imageUrls = [];
      }
    }

    return MaintenanceRecord(
      date: fields[0] as String,
      machine: fields[1] as String,
      issue: fields[2] as String,
      technician: fields[3] as String,
      action: fields[4] as String,
      notes: fields[5] as String?,
      reportDate: fields[6] as String,
      actionDate: fields[7] as String,
      isFixed: fields[8] as bool,
      repairLocation: fields[9] as String,
      repairedBy: fields[10] as String?,
      imageUrls:
          imageUrls, // ✅ استخدام القيمة المعالجة بدلاً من fields[11] مباشرة
    );
  }

  @override
  void write(BinaryWriter writer, MaintenanceRecord obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.machine)
      ..writeByte(2)
      ..write(obj.issue)
      ..writeByte(3)
      ..write(obj.technician)
      ..writeByte(4)
      ..write(obj.action)
      ..writeByte(5)
      ..write(obj.notes)
      ..writeByte(6)
      ..write(obj.reportDate)
      ..writeByte(7)
      ..write(obj.actionDate)
      ..writeByte(8)
      ..write(obj.isFixed)
      ..writeByte(9)
      ..write(obj.repairLocation)
      ..writeByte(10)
      ..write(obj.repairedBy)
      ..writeByte(11)
      ..write(obj.imageUrls);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaintenanceRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
