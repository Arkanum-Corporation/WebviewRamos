import 'package:binder/binder.dart';
import 'package:flutter/material.dart';
import 'package:ramos_webview/webview/webview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const BinderScope(
      child: MaterialApp(
        title: 'Premium Content',
        home: KWebviewWidget(),
      ),
    );
  }
}