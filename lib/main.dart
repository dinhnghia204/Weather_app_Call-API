import 'package:flutter/material.dart';
import 'screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Không sử dụng const vì Home() không phải const
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
