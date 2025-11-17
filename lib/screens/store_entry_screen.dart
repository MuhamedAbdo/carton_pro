import 'package:carton_pro/services/theme_service.dart';
import 'package:carton_pro/widgets/store_entry_form.dart';
import 'package:flutter/material.dart';
import 'package:carton_pro/widgets/app_drawer.dart';
import 'package:carton_pro/widgets/store_entry_list.dart';
import 'package:provider/provider.dart'; // ✅ استيراد provider

class StoreEntryScreen extends StatelessWidget {
  const StoreEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("📄 تقارير وارد المخزن"),
        centerTitle: true,
      ),
      body: const StoreEntryList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => StoreEntryForm.show(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
