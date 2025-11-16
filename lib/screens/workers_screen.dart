// lib/screens/workers_screen.dart (غير اسم الملف من workers_screen.dart)
import 'package:carton_pro/widgets/workers/worker_form.dart';
import 'package:carton_pro/widgets/workers/worker_list.dart';
import 'package:flutter/material.dart';
import 'package:carton_pro/widgets/app_drawer.dart';

class WorkersScreen extends StatelessWidget {
  const WorkersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("👷‍♂️ طاقم العمال"),
        centerTitle: true,
      ),
      body: const WorkerList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => WorkerForm.show(context), // ✅ تم التصحيح
        child: const Icon(Icons.add),
      ),
    );
  }
}
