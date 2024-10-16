import 'dart:io';

import 'package:cookingapp/welcomePage.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

const kGoogleApiKey = "AIzaSyCv774tqTBhaXZ_xzac1N28CtlO0X3Uob4";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          appBarTheme: AppBarTheme(titleTextStyle: TextStyle(fontFamily: 'SukhumvitSet', fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold)),
          fontFamily: 'SukhumvitSet'),
      home: WelcomePage(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
