import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الرئيسية'),
        centerTitle: true,
        // Optional: Add actions like search or notifications
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'settings',
                child: Text('الإعدادات'),
              ),
              const PopupMenuItem(
                value: 'about',
                child: Text('من نحن'),
              ),
            ],
            onSelected: (value) {
              if (value == 'settings') {
                // TODO: Navigate to settings
              } else if (value == 'about') {
                // TODO: Navigate to about
              }
            },
          ),
        ],
      ),
      drawer: const AppDrawer(), // استخدام AppDrawer
      body: const Center(
        child: Text(
          'مرحبًا بك في تطبيق CartonPro',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
