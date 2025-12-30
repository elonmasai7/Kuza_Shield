import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'file_scan_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String _paymentStatus = '';
  Timer? _pollTimer;

  void _upgradeToPremium() async {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    String phone = _phoneController.text.isNotEmpty ? _phoneController.text : user.phone ?? '';
    if (phone.isEmpty) {
      setState(() => _paymentStatus = 'Enter phone number');
      return;
    }
    try {
      var response = await ApiService.initiateAirtelPayment(user.id, '500', phone.replaceFirst('254', '0'));
      String transactionId = response['transactionId'];
      setState(() => _paymentStatus = 'Payment initiated. Check your phone for USSD prompt.');
      _startPolling(user.id, transactionId, 'airtel');
    } catch (e) {
      setState(() => _paymentStatus = 'Error: $e');
    }
  }

  void _startPolling(int userId, String transactionId, String method) {
    _pollTimer = Timer.periodic(Duration(seconds: 10), (timer) async {
      try {
        var status = await ApiService.checkPaymentStatus(userId, transactionId, method);
        if (status['success']) {
          setState(() => _paymentStatus = 'Payment successful! Premium activated.');
          timer.cancel();
        } else if (status['failed']) {
          setState(() => _paymentStatus = 'Payment failed. Please try again.');
          timer.cancel();
        }
      } catch (e) {
        setState(() => _paymentStatus = 'Polling error: $e');
        timer.cancel();
      }
    });
    Future.delayed(Duration(minutes: 1), () {
      _pollTimer?.cancel();
      if (_paymentStatus.contains('initiated')) setState(() => _paymentStatus = 'Timeout. Check Airtel app or dial *222#.');
    });
  }

  void _applyForTalaLoan() async {
    const talaUrl = 'tala://app';
    const playStoreUrl = 'https://play.google.com/store/apps/details?id=ke.co.tala';
    Uri uri = Uri.parse(talaUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      await launchUrl(Uri.parse(playStoreUrl));
    }
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number (07xxxxxxxx for Airtel)', border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _upgradeToPremium, child: Text('Upgrade to Premium (KSh 500/month via Airtel)')),
            SizedBox(height: 16),
            Text(_paymentStatus, style: TextStyle(color: _paymentStatus.contains('successful') ? Colors.green : Colors.red)),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _applyForTalaLoan, child: Text('Apply for Loan via Tala')),
            SizedBox(height: 16),
            ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FileScanScreen())), child: Text('Scan File for Threats')),
          ],
        ),
      ),
    );
  }
}