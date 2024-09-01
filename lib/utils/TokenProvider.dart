import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenProvider with ChangeNotifier {
  String _token = '';
  Map<String, dynamic> _decodedToken = {};

  Future<String> get token async => _token;
  Map<String, dynamic> get decodedToken => _decodedToken;

  TokenProvider() {
    _loadToken(); // Carregar o token quando a classe for instanciada
  }

  Future<void> _loadToken() async {
    String? savedToken = await getToken();
    if (savedToken != null && savedToken.isNotEmpty) {
      _token = savedToken;
      notifyListeners(); // Notifica os listeners que o token foi atualizado
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token');
  }

  void setToken(String token) {
    _token = token;
    _decodedToken = JwtDecoder.decode(token);
    saveToken(token);
    print(_decodedToken);
    notifyListeners();
  }

  void clear() {
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
