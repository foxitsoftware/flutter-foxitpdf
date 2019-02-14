import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class FlutterFoxitpdf {
  static const MethodChannel _channel =
      const MethodChannel('flutter_foxitpdf');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<int> initialize(String sn, String key) async {
    final int error = await _channel.invokeMethod("initialize", {
      "sn": sn,
      "key": key,
    });
    return error;
  }

  static Future<void> openDocument(String path, Uint8List password) async {
    _channel.invokeMethod('openDocument', {
      'path': path,
      'password': password,
    });
  }
}
