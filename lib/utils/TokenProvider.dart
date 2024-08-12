import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenProvider with ChangeNotifier {
  String _token = '';
  Map<String, dynamic> _decodedToken = {};

  Future<String> get token async => _token;
  Map<String, dynamic> get decodedToken => _decodedToken;

  void setToken(String token) {
    _token = token;
    _decodedToken = JwtDecoder.decode(token);
    notifyListeners();
  }

  bool isTokenExpired() {
    return JwtDecoder.isExpired(_token);
  }

  bool isLogged() {
    return token != '' && !isTokenExpired();
  }

  DateTime getTokenExpirationDate() {
    return JwtDecoder.getExpirationDate(_token);
  }
}
