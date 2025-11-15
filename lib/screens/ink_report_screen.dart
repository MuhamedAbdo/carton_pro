import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../widgets/app_drawer.dart';
import '../models/ink_report_model.dart'; // استيراد النموذج

class InkReportScreen extends StatefulWidget {
  const InkReportScreen({super.key});

  @override
  State<InkReportScreen> createState() => _InkReportScreenState();
}

class _InkReportScreenState extends State<InkReportScreen> {
  Box<InkReport>? _inkReportBox;

  // Search
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  String _searchQuery = '';

  // Filter / Sort
  bool _sortDescending = true; // true => الأحدث فوق
  bool _onlyWithImages = false;

  @override
  void initState() {
    super.initState();
    _openBox();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _openBox() async {
    if (!Hive.isBoxOpen('inkReports')) {
      _inkReportBox = await Hive.openBox<InkReport>('inkReports');
    } else {
      _inkReportBox = Hive.box<InkReport>('inkReports');
    }
    setState(() {});
  }

  void _showAddReportDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return InkReportForm(
          onSave: (report) {
            _inkReportBox?.add(report);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("✅ تم إضافة التقرير")),
              );
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }

  void _showEditReportDialog(InkReport report, dynamic key) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return InkReportForm(
          initialData: _convertInkReportToMap(report),
          reportKey: key,
          onSave: (updatedReport) {
            _inkReportBox?.put(key, updatedReport);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("✅ تم تحديث التقرير")),
              );
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }

  Map<String, dynamic> _convertInkReportToMap(InkReport report) {
    return {
      'id': report.id,
      'date': report.date,
      'clientName': report.clientName,
      'product': report.product,
      'productCode': report.productCode,
      'dimensions': report.dimensions,
      'colors': report.colors,
      'quantity': report.quantity,
      'notes': report.notes,
      'imagePaths': report.imageUrls,
    };
  }

  InkReport _convertMapToInkReport(Map<String, dynamic> map) {
    return InkReport(
      id: map['id'] ?? '',
      date: map['date'] ?? '',
      clientName: map['clientName'] ?? '',
      product: map['product'] ?? '',
      productCode: map['productCode'] ?? '',
      dimensions: Map<String, dynamic>.from(map['dimensions'] ?? {}),
      colors: List<Map<String, double>>.from(map['colors'] ?? []),
      quantity: map['quantity'] ?? 0,
      notes: map['notes'],
      imageUrls: List<String>.from(map['imagePaths'] ?? []),
    );
  }

  String _formatDimensions(Map? dims) {
    if (dims == null || dims.isEmpty) return '';
    final l = dims['length']?.toString() ?? '';
    final w = dims['width']?.toString() ?? '';
    final h = dims['height']?.toString() ?? '';

    final parts = <String>[];
    if (l.isNotEmpty) parts.add(l);
    if (w.isNotEmpty) parts.add(w);
    if (h.isNotEmpty) parts.add(h);

    return parts.isNotEmpty ? parts.join(' × ') : '';
  }

  DateTime _parseDateSafe(String dateStr) {
    if (dateStr.isEmpty) return DateTime.fromMillisecondsSinceEpoch(0);
    DateTime? dt = DateTime.tryParse(dateStr);
    if (dt != null) return dt;
    try {
      final parts = dateStr.split(RegExp(r'[-/]'));
      if (parts.length >= 3) {
        if (parts[0].length == 4) {
          final y = int.parse(parts[0]);
          final m = int.parse(parts[1]);
          final d = int.parse(parts[2]);
          return DateTime(y, m, d);
        } else {
          final d = int.parse(parts[0]);
          final m = int.parse(parts[1]);
          final y = int.parse(parts[2]);
          return DateTime(y, m, d);
        }
      }
    } catch (_) {}
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  bool _matchesSearch(InkReport report, String q) {
    if (q.isEmpty) return true;
    final lower = q.toLowerCase();
    final code = (report.productCode ?? '').toString().toLowerCase();
    final product = (report.product ?? '').toString().toLowerCase();
    final client = (report.clientName ?? '').toString().toLowerCase();
    return code.contains(lower) ||
        product.contains(lower) ||
        client.contains(lower);
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        bool tempOnlyWithImages = _onlyWithImages;
        bool tempSortDescending = _sortDescending;
        return StatefulBuilder(builder: (context, setStateSB) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('خيارات الفلترة والترتيب',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('ترتيب حسب التاريخ:'),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButton<bool>(
                        value: tempSortDescending,
                        items: const [
                          DropdownMenuItem(
                              value: true, child: Text('الأحدث أولاً')),
                          DropdownMenuItem(
                              value: false, child: Text('الأقدم أولاً')),
                        ],
                        onChanged: (v) {
                          if (v == null) return;
                          setStateSB(() => tempSortDescending = v);
                        },
                      ),
                    ),
                  ],
                ),
                CheckboxListTile(
                  value: tempOnlyWithImages,
                  onChanged: (v) {
                    setStateSB(() => tempOnlyWithImages = v ?? false);
                  },
                  title: const Text('إظهار التقارير التي تحتوي على صور فقط'),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('إلغاء'),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _onlyWithImages = tempOnlyWithImages;
                            _sortDescending = tempSortDescending;
                          });
                          Navigator.pop(ctx);
                        },
                        child: const Text('تطبيق'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        });
      },
    );
  }

  List<MapEntry<dynamic, InkReport>> _prepareRecords(Box<InkReport> box) {
    var entries = box.toMap().entries.toList();

    entries.sort((a, b) {
      final da = _parseDateSafe(a.value.date);
      final db = _parseDateSafe(b.value.date);
      return db.compareTo(da);
    });

    if (!_sortDescending) {
      entries = entries.reversed.toList();
    }

    var filtered = entries;
    if (_onlyWithImages) {
      filtered = filtered.where((e) => e.value.imageUrls.isNotEmpty).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered.where((e) => _matchesSearch(e.value, _searchQuery)).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    if (_inkReportBox == null || !_inkReportBox!.isOpen) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: SizedBox(
          height: 40,
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocus,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) {
              setState(() {
                _searchQuery = _searchController.text.trim();
              });
              _searchFocus.unfocus();
            },
            decoration: InputDecoration(
              hintText: 'ابحث بكود الصنف، الصنف أو اسم العميل',
              hintStyle: const TextStyle(color: Colors.white70),
              filled: false,
              prefixIcon: IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _searchQuery = _searchController.text.trim();
                  });
                  _searchFocus.unfocus();
                },
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
            ),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<InkReport>>(
        valueListenable: _inkReportBox!.listenable(),
        builder: (context, Box<InkReport> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text("🚫 لا يوجد تقارير"));
          }

          final prepared = _prepareRecords(box);

          if (prepared.isEmpty) {
            return Center(
              child: Text(_searchQuery.isNotEmpty
                  ? 'لا توجد نتائج مطابقة لـ "$_searchQuery"'
                  : 'لا توجد تقارير تطابق الفلاتر'),
            );
          }

          return ListView.builder(
            itemCount: prepared.length,
            itemBuilder: (context, index) {
              final entry = prepared[index];
              final dynamic key = entry.key;
              final report = entry.value;

              final dimsText = _formatDimensions(report.dimensions);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text("📅 ${report.date}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("👤 ${report.clientName}"),
                      Text("📦 ${report.product}"),
                      if (dimsText.isNotEmpty) Text("📏 $dimsText"),
                      if ((report.productCode ?? '').toString().isNotEmpty)
                        Text("🔢 كود: ${report.productCode}"),
                      if (report.colors.isNotEmpty)
                        ...report.colors.map<Widget>((c) {
                          final colorName = c.keys.first;
                          final quantity = c.values.first;
                          return Text("🎨 $colorName - $quantity لتر");
                        }),
                      if (report.imageUrls.isNotEmpty)
                        SizedBox(
                          height: 60,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: report.imageUrls.length,
                            itemBuilder: (context, i) {
                              final path = report.imageUrls[i];
                              final file = File(path);
                              if (!file.existsSync()) {
                                return Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image),
                                );
                              }
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Image.file(
                                  file,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showEditReportDialog(report, key);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('تأكيد الحذف'),
                              content: const Text(
                                  'هل أنت متأكد أنك تريد حذف هذا التقرير؟'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('إلغاء'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('حذف',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            _inkReportBox?.delete(key);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("🗑️ تم حذف التقرير")),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddReportDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// InkReportForm and ColorField (kept inline for convenience)
class InkReportForm extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final dynamic reportKey;
  final void Function(InkReport) onSave;

  const InkReportForm({
    super.key,
    this.initialData,
    this.reportKey,
    required this.onSave,
  });

  @override
  State<InkReportForm> createState() => _InkReportFormState();
}

class _InkReportFormState extends State<InkReportForm> {
  late TextEditingController dateController;
  late TextEditingController clientNameController;
  late TextEditingController productController;
  late TextEditingController productCodeController;
  late TextEditingController lengthController;
  late TextEditingController widthController;
  late TextEditingController heightController;
  late TextEditingController quantityController;
  late TextEditingController notesController;

  List<ColorField> colors = [];
  List<String> _imagePaths = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    dateController = TextEditingController();
    clientNameController = TextEditingController();
    productController = TextEditingController();
    productCodeController = TextEditingController();
    lengthController = TextEditingController();
    widthController = TextEditingController();
    heightController = TextEditingController();
    quantityController = TextEditingController();
    notesController = TextEditingController();

    if (widget.initialData != null) {
      _loadInitialData(widget.initialData!);
    } else {
      final now = DateTime.now();
      dateController.text =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    }
  }

  void _loadInitialData(Map<String, dynamic> data) {
    dateController.text = data['date'] ?? '';
    clientNameController.text = data['clientName'] ?? '';
    productController.text = data['product'] ?? '';
    productCodeController.text = data['productCode']?.toString() ?? '';

    final dimensions = Map<String, dynamic>.from(data['dimensions'] ?? {});
    lengthController.text = dimensions['length']?.toString() ?? '';
    widthController.text = dimensions['width']?.toString() ?? '';
    heightController.text = dimensions['height']?.toString() ?? '';

    quantityController.text = data['quantity']?.toString() ?? '';
    notesController.text = data['notes'] ?? '';

    colors.clear();
    if (data.containsKey('colors') && data['colors'] is List) {
      List<dynamic> colorsList = data['colors'];
      for (var c in colorsList) {
        if (c is Map<String, dynamic>) {
          for (var entry in c.entries) {
            colors.add(ColorField(
              colorController: TextEditingController(text: entry.key),
              quantityController:
                  TextEditingController(text: (entry.value as num).toString()),
            ));
          }
        } else if (c is Map<String, double>) {
          for (var entry in c.entries) {
            colors.add(ColorField(
              colorController: TextEditingController(text: entry.key),
              quantityController:
                  TextEditingController(text: (entry.value).toString()),
            ));
          }
        }
      }
    }

    if (data.containsKey('imagePaths') && data['imagePaths'] is List) {
      _imagePaths = List<String>.from(data['imagePaths']);
    }
  }

  void _addColorField() {
    setState(() {
      colors.add(ColorField(
        colorController: TextEditingController(),
        quantityController: TextEditingController(),
      ));
    });
  }

  void _removeColorField(int index) {
    if (index < 0 || index >= colors.length) return;
    setState(() {
      colors[index].colorController.dispose();
      colors[index].quantityController.dispose();
      colors.removeAt(index);
    });
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

  void _saveReport() {
    if (!_formKey.currentState!.validate()) return;

    List<Map<String, double>> colorsList = [];
    for (var c in colors) {
      String colorName = c.colorController.text.trim();
      double quantity =
          double.tryParse(c.quantityController.text.trim()) ?? 0.0;
      if (colorName.isNotEmpty) {
        colorsList.add({colorName: quantity});
      }
    }

    final report = InkReport(
      id: widget.reportKey?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      date: dateController.text,
      clientName: clientNameController.text,
      product: productController.text,
      productCode: productCodeController.text,
      dimensions: {
        'length': lengthController.text,
        'width': widthController.text,
        'height': heightController.text,
      },
      colors: colorsList,
      quantity: int.tryParse(quantityController.text.trim()) ?? 0,
      notes: notesController.text.trim(),
      imageUrls: _imagePaths,
    );

    widget.onSave(report);
  }

  @override
  void dispose() {
    dateController.dispose();
    clientNameController.dispose();
    productController.dispose();
    productCodeController.dispose();
    lengthController.dispose();
    widthController.dispose();
    heightController.dispose();
    quantityController.dispose();
    notesController.dispose();
    for (var c in colors) {
      c.colorController.dispose();
      c.quantityController.dispose();
    }
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
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.reportKey == null
                      ? "🆕 إضافة تقرير"
                      : "✏️ تعديل تقرير",
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
                  controller: clientNameController,
                  decoration: const InputDecoration(
                      labelText: "👤 اسم العميل", border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? "مطلوب" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: productController,
                  decoration: const InputDecoration(
                      labelText: "📦 الصنف", border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? "مطلوب" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: productCodeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: "🔢 كود الصنف", border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? "مطلوب" : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: lengthController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: "📏 الطول",
                            border: OutlineInputBorder()),
                        validator: (v) => v!.isEmpty ? "مطلوب" : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: widthController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: "📏 العرض",
                            border: OutlineInputBorder()),
                        validator: (v) => v!.isEmpty ? "مطلوب" : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: heightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: "📏 الارتفاع",
                            border: OutlineInputBorder()),
                        validator: (v) => v!.isEmpty ? "مطلوب" : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text("🎨 الألوان",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...colors.map((c) {
                  final index = colors.indexOf(c);
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: TextFormField(
                                  controller: c.colorController,
                                  decoration: const InputDecoration(
                                      labelText: "اللون",
                                      border: OutlineInputBorder()))),
                          const SizedBox(width: 8),
                          Expanded(
                              flex: 2,
                              child: TextFormField(
                                  controller: c.quantityController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      labelText: "الكمية (لتر)",
                                      border: OutlineInputBorder()))),
                          IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeColorField(index)),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                }),
                ElevatedButton.icon(
                    onPressed: _addColorField,
                    icon: const Icon(Icons.add),
                    label: const Text("إضافة لون")),
                const SizedBox(height: 16),
                TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: "🔢 عدد الشيتات",
                      border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? "مطلوب" : null,
                ),
                const SizedBox(height: 12),
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
                            onPressed: _saveReport,
                            child: const Text("💾 حفظ التقرير"))),
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

class ColorField {
  final TextEditingController colorController;
  final TextEditingController quantityController;

  ColorField({
    required this.colorController,
    required this.quantityController,
  });
}
