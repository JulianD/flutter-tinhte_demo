import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/screens/home.dart';
import 'src/api.dart';
import 'src/push_notification.dart';

// https://medium.com/@kr1uz/how-to-restrict-device-orientation-in-flutter-65431cd35113
void main() =>
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) => runApp(MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ApiApp(
        PushNotificationApp(
          MaterialApp(
            title: 'Tinh tế Demo',
            theme: ThemeData(
              accentColor: const Color(0xFF00BAD7),
              primaryColor: const Color(0xFF192533),
              brightness: Brightness.light,
            ),
            home: SafeArea(child: HomeScreen()),
          ),
        ),
      );
}
