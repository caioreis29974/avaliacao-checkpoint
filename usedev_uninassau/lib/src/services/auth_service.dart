import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String _baseUrl = 'https://fakestoreapi.com';
  static const String _tokenKey = 'auth_token';

  final _storage = const FlutterSecureStorage();

  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final token = json['token'] as String;
        await _storage.write(key: _tokenKey, value: token);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Falha na conexão. Verifique sua internet.');
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
  }
}