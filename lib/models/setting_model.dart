import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'setting_model.g.dart'; // سيتم إنشاؤه تلقائيًا

@HiveType(typeId: 0) // مطلوب لـ Hive
class SettingModel extends HiveObject {
  @HiveField(0)
  final bool darkMode;

  @HiveField(1)
  final String language;

  @HiveField(2)
  final double cameraQuality;

  @HiveField(3)
  final String loginType; // 'authenticated' or 'guest'

  SettingModel({
    required this.darkMode,
    required this.language,
    required this.cameraQuality,
    required this.loginType,
  });

  // CopyWith
  SettingModel copyWith({
    bool? darkMode,
    String? language,
    double? cameraQuality,
    String? loginType,
  }) {
    return SettingModel(
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
      cameraQuality: cameraQuality ?? this.cameraQuality,
      loginType: loginType ?? this.loginType,
    );
  }

  // من الـ JSON
  factory SettingModel.fromJson(Map<String, dynamic> json) => SettingModel(
        darkMode: json['darkMode'] ?? false,
        language: json['language'] ?? 'ar',
        cameraQuality: (json['cameraQuality'] as num?)?.toDouble() ?? 1.0,
        loginType: json['loginType'] ?? 'guest',
      );

  // للـ JSON
  Map<String, dynamic> toJson() => {
        'darkMode': darkMode,
        'language': language,
        'cameraQuality': cameraQuality,
        'loginType': loginType,
      };
}

// القيمة الافتراضية
SettingModel defaultSettings = SettingModel(
  darkMode: false,
  language: 'ar',
  cameraQuality: 1.0,
  loginType: 'guest',
);
