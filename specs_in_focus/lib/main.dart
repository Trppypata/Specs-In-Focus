import 'package:specs_in_focus/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:specs_in_focus/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' if (dart.library.html) 'package:specs_in_focus/config/web_platform_stub.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Create ApiService here to start loading data during splash screen
  final ApiService apiService = ApiService();
  
  // Start seeding data in background
  apiService.seedSampleData();
  
  runApp(MyApp(apiService: apiService));
}

class MyApp extends StatefulWidget {
  final ApiService apiService;
  
  const MyApp({super.key, required this.apiService});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print('Running on platform: ${kIsWeb ? 'Web' : Platform.operatingSystem}');
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Specs In Focus',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

