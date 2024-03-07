import 'package:flutter/services.dart';

class SystemSettingsLauncher {
  static const MethodChannel _channel = MethodChannel('com.example.systemsettings/launcher');

  static Future<void> openSystemSettings() async {
    try {
      print('test123');
      await _channel.invokeMethod('openSystemSettings');
    } on PlatformException catch (e) {
      print("Failed to open system settings: '${e.message}'.");
    }
  }
}