import 'package:flutter/material.dart';
import './homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Зубы',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: const ColorScheme(
              brightness: Brightness.light,
              primary: Color.fromARGB(255, 24, 151, 143),
              onPrimary: Color.fromRGBO(255, 255, 255, 1),
              secondary: Color.fromARGB(255, 158, 158, 158),
              onSecondary: Color.fromARGB(255, 66, 66, 66),
              error: Color.fromARGB(255, 255, 23, 68),
              onError: Color.fromARGB(255, 0, 0, 0),
              background: Color.fromARGB(255, 211, 47, 47),
              onBackground: Color.fromARGB(255, 245, 242, 237),
              surface: Color.fromARGB(255, 0, 0, 0),
              onSurface: Color.fromARGB(255, 0, 0, 0)),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(fontSize: 18.0),
              bodyMedium: TextStyle(fontSize: 18.0),
              bodySmall: TextStyle(fontSize: 18.0),
              displayLarge: TextStyle(fontSize: 18.0),
              titleLarge: TextStyle(fontSize: 18.0),
              labelLarge: TextStyle(fontSize: 18.0)
            ),
            scaffoldBackgroundColor: Color.fromARGB(255, 248, 243, 235)
        ),
        home: const HomePage());
  }
}
