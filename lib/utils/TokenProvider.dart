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
    print(_decodedToken);
    notifyListeners();
  }

  void clear(){
    _token = '';
    _decodedToken = {};
  }

  bool isArtist() {
    var artist = _decodedToken['tatuador'];
    if (artist != null) return true;
    return false;
  }

  bool isTokenExpired() {
    return JwtDecoder.isExpired(_token);
  }

  bool isLogged() {
    return _token != '' && !isTokenExpired();
  }

  DateTime getTokenExpirationDate() {
    return JwtDecoder.getExpirationDate(_token);
  }
}
