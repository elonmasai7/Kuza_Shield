import 'package:flutter/material.dart';
import 'scanner_screen.dart';
import 'education_screen.dart';
import 'settings_screen.dart';
import 'file_scan_screen.dart';
import 'analytics_screen.dart';
import '../services/notification_service.dart';  // New import

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    NotificationService.initialize(context);  // Added: Init notifications on home load
  }

  @override
  Widget build(BuildContext context) {
    // (Same as previous)
    return Scaffold(
      // ... rest unchanged
    );
  }
}