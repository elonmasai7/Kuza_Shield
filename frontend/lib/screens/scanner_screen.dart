import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/threat_provider.dart';
import '../services/api_service.dart';

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final TextEditingController _textController = TextEditingController();
  String _result = '';
  bool _isLoading = false;

  void _scanText() async {
    String text = _textController.text.trim();
    if (text.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      var response = await ApiService.scanPhishing(text);
      setState(() {
        _result = response['is_phishing'] ? 'Threat Detected! Confidence: ${response['confidence']}' : 'Safe. Confidence: ${response['confidence']}';
      });
      Provider.of<ThreatProvider>(context, listen: false).addThreat(response);
    } catch (e) {
      setState(() => _result = 'Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Threat Scanner')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(labelText: 'Enter SMS/Email Text', border: OutlineInputBorder()),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            _isLoading ? CircularProgressIndicator() : ElevatedButton(onPressed: _scanText, child: Text('Scan for Threats')),
            SizedBox(height: 16),
            Text(_result, style: TextStyle(fontSize: 18, color: _result.contains('Threat') ? Colors.red : Colors.green, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}