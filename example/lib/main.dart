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

  String _sn = 'Fu8yheC/oCxkbT2pouHUENUTDXWKLiHppKRziXCt5ZdHpT6XnshZmA==';
  String _key = 'ezJvjl8mvB539PsXZqXcImlssh9qveZTXws5NuYVPpyTgJ1qz4F0lwleIbZghw4S59+RR7ShR0UltvoUSp4TysQT6Ucy4DXcbz1oy7ZmZJs+5Bm3TRCEaeOKikhTNWhhmJD2b4nJHO1pTWuvrea7dVNbmDoz4hqC5EMgs16YClN4Navw8PO1CaQ0YqKxIEz1okdg6WHWRAIsZwQ4oPpZPl8ymJ3wQ8+rY/LJBe0O2xeGUViK5Lul1hKSSfi4186E6RBUO0iAzh/r4v9eiPCl3Ki9RLW255R11aleBCS8JwnqjWLu62hDVe/nUnmuHpKz3YN80LiSCja4Nxwv2Yq96S8eGr2gqwKXt4itJs2uBU477yfTKgKRqikdyAIVXJqF3nPmEG2PKCGVDBpm8ov/HLfqmXfHVic//HetDblejmXp9gDtY4H/t1cNY9cG2K9IywVMx+fhDnk5O6MgPQSXziyTc6VaFvrFj4TeuAUe6cMDurPkVWvqknARiRqtXekfxAeERx2SX4dteHO2EXGDLNdlaqCJYF56Bv+JdhR5wz9/WzKDgymOwP4fYRYix3DJSBYXjyZeBilIOEFOnkRhft9QuOZprW9qN0I0PeVGh5wSUScSLvqKJE6UOnvHAqc1GI442X9boWrvUkCPR9yL/MgjUev2O34gajED8jOKzoLLb6QsB9u4O1jQUl265CtEvZyWXeqKwPA/gWQRGX918syZhyR9GtBeUsRhLuSlYagHwaf5BQP+phsepStgn2Dh6897jZ5XcZFZtSAiLedZbvzUJPl0oPqVu2CukIzGHp3lMHFMFwdivtbonGiZ+JLDeuvyA2PqtCn3gHorGmhEWoaSVNiqGFkxP+MMHbZH8z8YLUk1EoMlJqecDWOS4i4w6KwCfvU+BEcyLQvdVsKZunFd4hVi5dx8kZYmGKi7BK6EqqBIpZPdcBHGy92uXBbQOft7XZtA2boHif9GxfCgV77Yb9r0PZ6h8fakIyKXHVf8xiCQhhakc0Mz3nThE2Qbvq2aZJhpu4JRVi6BySJr2BaUPI3cdgyzqJPbFJ0m1TINZDCRiEoBD3Ihk0E1E7PLXWxhlIfWpBJHDeSPNhm6Zm+k6EFaeadf+RR5nGn/lVC7lvMdYRtn9lBC/7shJE7VhKt6v1WTkrAo5CRS1VGWIZteoHqUWFzzBPAYm6Oz4ViEPV+142ymut9oXIPOKXOzebpyoDJmUMkv8TyHnmdQZF5lCkjW485NUbei';
  String _path = '/mnt/sdcard/FoxitSDK/complete_pdf_viewer_guide_android.pdf';

  @override
  void initState() {
    super.initState();
    initPlatformState();

    init(_sn, _key);

    openDocument(_path, null);
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

  Future<void> openDocument(String path, Uint8List password) async {
    await FlutterFoxitpdf.openDocument(path, password);
  }
}
