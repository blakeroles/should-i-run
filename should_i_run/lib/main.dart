import 'package:flutter/material.dart';
import 'package:should_i_run/theme.dart';
import 'package:should_i_run/screens/main_screen/main_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

Future main() async {
  await DotEnv.load(fileName: "app.env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Should I Run?',
      theme: theme(),
      home: MainScreen(),
    );
  }
}
