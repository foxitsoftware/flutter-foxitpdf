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

  String _sn = 'l5uLRkyIIDIyKJQZBChK2tXW/BikAnJozYEi1ApEyOR7i8W3U0ZlKQ==';
  String _key = 'ezJvjl8mvB539NviuavWvpsxZwdMWZ2hvkmJNQZ8S/CwnxmS4c9F6U69I385uOe2wT4Fg2fJksQtXtnFsJ6lZR6RmsquC9T+GuC1YcZfAx/DRZivPTAkOaYoOwHQhGkkeTytiGg4KlolOVjyyRy5ZjzBBuwgODp1AcJAdTSvFlZnl+iCoYbPEKxUo/2+grZrhLICAXhrEioM4AwgIp1FxhQGlTLdv6OmuczqP0jt4IAEEJ1VhL5rh8X1fTGpx8fR8i0o0Ez/X307CCLaHBYLVXWMaZRn0XCsA1cOtcnD7XME1T4rHm4e4F+leLLPeylUoAMA/x1LwHj2yky9b2IclJxYcXRVdZOjCZsNPLpUDZS/UvAdTNrbkDl8fS/Vx75QOW+2z8//pjK4UR23WMi9yuvhXpfyi5Etv0aZDe969Pmc1vt2zK2Ddz2EAO5BslqcPDw2eBfCMBQL+iz3p9xg0XI9pAI6DnRDuqHkqHh6EVZ6zN20BupuDOdTg+PemU739fedBXY7TQz7ORE6BtzvPIlpyG1mNKC7A3bOIzyTDbVfSq3bPj5qoas7brtGTce1j0EHfzF3rzyFsKbvxcTcBRKzV+bAvtNofD4qPtqz7edHNbJKVcugoARzikVFW3dD7d14p7QUV+d6QkQf12KvzocGRfY1cHC/+Cey25k0+UtFQ/KdhaU/EVOfprWqeJLUyqX/GV9WX7I3A3OF8nTqeh7UpaOin8pA3T5k3tzAcnzFf9jFXjZeT1cRhClLSbWR4fGn+rxeLr2lwTOa9kBR1BY/iwItyY7uxCj1LcxtLKNC+BFRK4tXTsFlCjQPJOreF0oBxAhSp8dTmeXsdb/QVJMlR1iuJwqIWoxfg9+zHBNPUHpK33weRQ/j2gRPGBV2eW3+Wqcx+5VyB3PtCxaheJ3jMgXD2/1UBh24JVUVwgL0oQ3fi7EhleoALwQaulCWP5TTCOioPJFjVGBMo5BfH4o4rU1JNDse/QIauw1EkQQHlzfazCpU9gHnP4nBNKAgn+fNc+hwDBEP0dmlIEeHvy4kGEQQCwtMuV6Ezam1BAUwjKp8Lw5d2B/8d65mUCj1kZl2cXLEAnrwFCyZ8+RHe4XK+DZGCbwjzcyzJdQ+3qUrVgf9iseJm9XpOZp1azqo5nfOThl4lJAcEty7lsbXRpldNiFb8VE/hMkm/cFR9PNj40N4Zq+EvdiSO1ZwaEyM67OHwgo6i0QtGhp1SNA6Enq6OVNEy9J0QF5e2XT4UoZNN7roRKkP1ADvQA==';
  String _path = '/mnt/sdcard/FoxitSDK/complete_pdf_viewer_guide_android.pdf';

  @override
  void initState() {
    super.initState();
    initPlatformState();

    init(_sn, _key);

    openDocument(_path, '');
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
}
