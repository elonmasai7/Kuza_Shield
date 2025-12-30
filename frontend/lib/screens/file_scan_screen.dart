import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../providers/threat_provider.dart';
import '../services/api_service.dart';

class FileScanScreen extends StatefulWidget {
  @override
  _FileScanScreenState createState() => _FileScanScreenState();
}

class _FileScanScreenState extends State<FileScanScreen> {
  String _result = '';
  String _filePath = '';
  bool _isLoading = false;

  void _pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['txt', 'pdf']);
    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() => _filePath = file.name);
      setState(() => _isLoading = true);
      try {
        var response = await ApiService.uploadFileForScan(file.path!, file.name);
        setState(() {
          _result = response['is_threat'] ? 'Threat Detected in File! Confidence: ${response['confidence']}' : 'File is Safe. Confidence: ${response['confidence']}';
        });
        Provider.of<ThreatProvider>(context, listen: false).addThreat(response);
      } catch (e) {
        setState(() => _result = 'Error: $e');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('File Threat Scanner')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(onPressed: _pickAndUploadFile, child: Text('Pick File to Scan (TXT/PDF)')),
            SizedBox(height: 16),
            Text(_filePath.isNotEmpty ? 'Selected: $_filePath' : 'No file selected'),
            SizedBox(height: 16),
            _isLoading ? CircularProgressIndicator() : Text(_result, style: TextStyle(fontSize: 18, color: _result.contains('Threat') ? Colors.red : Colors.green, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}