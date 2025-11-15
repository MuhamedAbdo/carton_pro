import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:hive_flutter/hive_flutter.dart'; // عطلها مؤقتًا
import 'app.dart';
// import 'services/hive_service.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized(); // عطلها مؤقتًا
  // await Hive.initFlutter(); // عطلها مؤقتًا

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  runApp(const MyApp());
}
