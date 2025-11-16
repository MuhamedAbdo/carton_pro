import 'package:hive/hive.dart';

part 'store_entry_model.g.dart'; // سيتم إنشاؤه تلقائيًا

@HiveType(typeId: 4) // استخدم typeId فريد
class StoreEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String date;

  @HiveField(2)
  final String product;

  @HiveField(3)
  final String unit; // وحدة القياس (كجم، قطعة، صندوق، إلخ)

  @HiveField(4)
  final int quantity;

  @HiveField(5)
  final String supplier; // مورد

  @HiveField(6)
  final String? notes; // ملاحظات اختيارية

  @HiveField(7)
  final List<String> imageUrls; // روابط الصور (اختياري)

  StoreEntry({
    required this.id,
    required this.date,
    required this.product,
    required this.unit,
    required this.quantity,
    required this.supplier,
    this.notes,
    required this.imageUrls,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'product': product,
      'unit': unit,
      'quantity': quantity,
      'supplier': supplier,
      'notes': notes,
      'image_urls': imageUrls,
    };
  }

  factory StoreEntry.fromJson(Map<String, dynamic> map) {
    List<dynamic> imagesList = map['image_urls'] ?? [];

    List<String> parsedImages =
        imagesList.map((item) => item.toString()).toList();

    return StoreEntry(
      id: map['id'] ?? '',
      date: map['date'] ?? '',
      product: map['product'] ?? '',
      unit: map['unit'] ?? '',
      quantity: map['quantity'] is int
          ? map['quantity']
          : int.tryParse(map['quantity'].toString()) ?? 0,
      supplier: map['supplier'] ?? '',
      notes: map['notes'],
      imageUrls: parsedImages,
    );
  }
}
