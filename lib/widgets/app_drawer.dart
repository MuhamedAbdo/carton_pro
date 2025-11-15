import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header with app image and name
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/logo_light.png'),
                  backgroundColor: Colors.white,
                ),
                SizedBox(height: 8),
                Text(
                  'CartonPro',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Drawer items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('الرئيسية'),
                  onTap: () {
                    context.go('/'); // Navigate to home
                    Navigator.pop(context); // Close drawer
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('الإعدادات'),
                  onTap: () {
                    context.go('/settings'); // Navigate to settings
                    Navigator.pop(context); // Close drawer
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.login),
                  title: const Text('تسجيل الدخول'),
                  onTap: () {
                    // context.go('/login'); // Navigate to login
                    Navigator.pop(context);
                    // TODO: Add navigation logic
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('من نحن'),
                  onTap: () {
                    // context.go('/about'); // Navigate to about
                    Navigator.pop(context);
                    // TODO: Add navigation logic
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text('سياسة الخصوصية'),
                  onTap: () {
                    // context.go('/privacy'); // Navigate to privacy
                    Navigator.pop(context);
                    // TODO: Add navigation logic
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
