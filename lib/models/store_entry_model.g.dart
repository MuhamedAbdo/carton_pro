// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_entry_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoreEntryAdapter extends TypeAdapter<StoreEntry> {
  @override
  final int typeId = 4;

  @override
  StoreEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StoreEntry(
      id: fields[0] as String,
      date: fields[1] as String,
      product: fields[2] as String,
      unit: fields[3] as String,
      quantity: fields[4] as int,
      supplier: fields[5] as String,
      notes: fields[6] as String?,
      imageUrls: (fields[7] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, StoreEntry obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.product)
      ..writeByte(3)
      ..write(obj.unit)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.supplier)
      ..writeByte(6)
      ..write(obj.notes)
      ..writeByte(7)
      ..write(obj.imageUrls);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
