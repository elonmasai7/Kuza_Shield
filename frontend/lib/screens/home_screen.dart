import 'package:flutter/material.dart';
import 'scanner_screen.dart';
import 'education_screen.dart';
import 'settings_screen.dart';
import 'file_scan_screen.dart';
import 'analytics_screen.dart';  // New import

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('KuzaShield Dashboard')),
      body: Center(child: Text('Welcome to KuzaShield - Protect Your Digital Life')),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.security), label: 'Scan'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Education'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Analytics'),  // New
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.file_copy), label: 'File Scan'),
        ],
        onTap: (index) {
          Widget screen;
          switch (index) {
            case 0:
              screen = ScannerScreen();
              break;
            case 1:
              screen = EducationScreen();
              break;
            case 2:
              screen = AnalyticsScreen();  // New
              break;
            case 3:
              screen = SettingsScreen();
              break;
            case 4:
              screen = FileScanScreen();
              break;
            default:
              return;
          }
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        },
      ),
    );
  }
}