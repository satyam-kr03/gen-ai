import 'package:flutter/material.dart';
import 'package:gen_ai/routes/router.dart';

void main() {
  var navigationShell;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
      return MaterialApp.router(
        title: 'Institute App',
        routerConfig: router,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
      );
  }
}