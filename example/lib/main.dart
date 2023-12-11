import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_foxitpdf/flutter_foxitpdf.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  int _error = -1;

  String _sn = 'YOUR_RDK_SN';
  String _key = 'YOUR_RDK_KEY';
  String _path = 'YOUR_PDF_FILE  or  YOUR_URL';

  @override
  void initState() {
    super.initState();
    initPlatformState();

    init(_sn, _key);

    openDocument(_path, '');      //1. open doc from local path
    //openDocFromUrl(_path, '');  //2. open doc from url.
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterFoxitpdf.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }

  Future<void> init(String sn, String key) async {
    int error;
    try {
      error = await FlutterFoxitpdf.initialize(sn, key);
    } on PlatformException {
      error = -1;
    }
    setState(() {
      _error = error;
    });
  }

  Future<void> openDocument(String path, String password) async {
    await FlutterFoxitpdf.openDocument(path, password);
  }

  Future<void> openDocFromUrl(String url, String password) async {
    await FlutterFoxitpdf.openDocFromUrl(url, password);
  }

}
