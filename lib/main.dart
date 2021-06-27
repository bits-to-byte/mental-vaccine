import 'package:covid_help/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

void main() {
  runApp(MyApp());
}

final lightTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.white,
  brightness: Brightness.light,
  backgroundColor: const Color(0xFFE5E5E5),
  accentColor: Colors.orangeAccent,
  accentIconTheme: IconThemeData(color: Colors.white),
  dividerColor: Colors.white54,
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightTheme,
      home: SplashScreen(
        seconds: 2,
        imageBackground: AssetImage('images/3658058.jpg'),
        loadingText: Text('Stay Home, Stay Safe!',
            style:
                TextStyle(fontFamily: 'MyFont', fontWeight: FontWeight.bold)),
        loaderColor: Colors.orange,
        navigateAfterSeconds: Dashboard(),
      ),
    );
  }
}
