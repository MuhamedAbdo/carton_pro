import 'package:flutter/material.dart';
import '../screens/settings_screen.dart';

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
              // Optional: Add gradient or shadow
            ),
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/logo_light.png'),
                  backgroundColor: Colors.white,
                  // Optional: Add a border
                  // foregroundColor: Theme.of(context).colorScheme.onSurface,
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
                    // Navigate to Home
                    Navigator.pop(context);
                    // TODO: Add navigation logic
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('الإعدادات'),
                  onTap: () {
                    // Navigate to Settings
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.login),
                  title: const Text('تسجيل الدخول'),
                  onTap: () {
                    // Navigate to Login
                    Navigator.pop(context);
                    // TODO: Add navigation logic
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('من نحن'),
                  onTap: () {
                    // Navigate to About Me
                    Navigator.pop(context);
                    // TODO: Add navigation logic
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text('سياسة الخصوصية'),
                  onTap: () {
                    // Navigate to Privacy Policy
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
