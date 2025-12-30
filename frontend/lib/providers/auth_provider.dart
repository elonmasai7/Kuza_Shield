import 'package:flutter/foundation.dart';

class User {
  final int id;
  final String phone;
  final String sector;

  User({required this.id, this.phone = '', this.sector = 'general'});
}

class AuthProvider extends ChangeNotifier {
  User _user = User(id: 1); // Mock for demo; replace with real auth in production

  User get user => _user;

  void updateUser({String? phone, String? sector}) {
    _user = User(id: _user.id, phone: phone ?? _user.phone, sector: sector ?? _user.sector);
    notifyListeners();
  }
}