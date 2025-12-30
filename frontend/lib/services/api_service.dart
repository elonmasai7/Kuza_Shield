import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api'; // Replace with production URL

  static Future<Map<String, dynamic>> scanPhishing(String text) async {
    final response = await http.post(
      Uri.parse('$baseUrl/scan'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'text': text}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to scan: ${response.reasonPhrase}');
  }

  static Future<List<dynamic>> getLessons(String sector) async {
    final response = await http.get(Uri.parse('$baseUrl/educate?sector=$sector'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to fetch lessons: ${response.reasonPhrase}');
  }

  static Future<void> saveProgress(String lessonId, double score) async {
    final response = await http.post(
      Uri.parse('$baseUrl/progress'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'lesson_id': lessonId, 'score': score}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to save progress: ${response.reasonPhrase}');
    }
  }

  static Future<Map<String, dynamic>> initiateAirtelPayment(int userId, String amount, String phone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/payment/initiate_airtel'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId, 'amount': amount, 'phone_number': phone}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to initiate Airtel payment: ${response.reasonPhrase}');
  }

  static Future<Map<String, dynamic>> checkPaymentStatus(int userId, String transactionId, String method) async {
    final endpoint = '/payment/check_airtel_status';
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId, 'transaction_id': transactionId}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to check status: ${response.reasonPhrase}');
  }

  static Future<Map<String, dynamic>> uploadFileForScan(String filePath, String fileName) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/scan_file'));
    request.files.add(await http.MultipartFile.fromPath('file', filePath, filename: fileName));
    var response = await request.send();
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    }
    throw Exception('Failed to upload file: ${response.reasonPhrase}');
  }
}