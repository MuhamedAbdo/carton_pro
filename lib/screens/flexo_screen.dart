import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_drawer.dart';

class FlexoScreen extends StatelessWidget {
  const FlexoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الفلكسو',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 1,
      ),
      drawer: const AppDrawer(), // ✅ الـ Drawer متاح في كل الشاشات
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // عنوان فوق الأزرار
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: const Text(
                'اختر القسم الذي تريد العمل فيه:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildHomeButton(
                    context: context,
                    icon: Icons.build_circle,
                    label: 'تركيب السيريل',
                    onTap: () {
                      context.push(
                          '/serial_setup'); // ✅ Navigate to Serial Setup Screen
                    },
                  ),
                  _buildHomeButton(
                    context: context,
                    icon: Icons.palette, // ✅ أيقونة "بالتة ألوان"
                    label: 'بالتة ألوان',
                    onTap: () {
                      context.push(
                          '/color_palette'); // ✅ Navigate to Color Palette Screen
                    },
                  ),
                  _buildHomeButton(
                    context: context,
                    icon: Icons.receipt, // ✅ أيقونة "تقرير الأحبار"
                    label: 'تقرير الأحبار',
                    onTap: () {
                      context.push(
                          '/ink_report'); // ✅ Navigate to Ink Report Screen
                    },
                  ),
                  _buildHomeButton(
                    context: context,
                    icon: Icons.inventory,
                    label: 'وارد المخزن',
                    onTap: () {
                      context.push(
                          '/store_entry'); // ✅ Navigate to Store Entry Screen
                    },
                  ),
                  _buildHomeButton(
                    context: context,
                    icon: Icons.settings,
                    label: 'الصيانة',
                    onTap: () {
                      _showSnackBar(context, 'الصيانة');
                    },
                  ),
                  _buildHomeButton(
                    context: context,
                    icon: Icons.calculate,
                    label: 'الآلة الحاسبة',
                    onTap: () {
                      _showSnackBar(context, 'الآلة الحاسبة');
                    },
                  ),
                  _buildHomeButton(
                    context: context,
                    icon: Icons.group,
                    label: 'طاقم العمل',
                    onTap: () {
                      _showSnackBar(context, 'طاقم العمل');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Theme.of(context)
                  .colorScheme
                  .primary, // ✅ استخدم colorScheme.primary
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم الدخول إلى $message'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
