import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/core/shared_preferences/shared_preferences.dart';
import 'features/splash/presentation/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyAuhuxtYqkoZJXSZkjO7HWKXAcmGUvuH_I',
        appId: 'condo-5ad01',
        messagingSenderId: 'sendid',
        projectId: 'condo-5ad01',
        storageBucket: 'condo-5ad01.appspot.com',
      )
  );
  await AppSettingsPreferences.init();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CondoNexus',
      // theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
    );
  }
}