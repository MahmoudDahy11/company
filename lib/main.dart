import 'package:flutter/material.dart';

import 'bootstrap.dart';
import 'core/ui/splash_screen.dart';

bool _bootstrapComplete = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
        onSplashComplete: () {
          if (!_bootstrapComplete) {
            bootstrap();
          }
        },
      ),
    ),
  );

  // Initialize the app in the background
  _bootstrapComplete = true;
  await bootstrap();
}
