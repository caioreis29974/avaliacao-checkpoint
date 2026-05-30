import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/produto_model.dart';

class ProductService {
  static const String _baseUrl = 'https://fakestoreapi.com';

  Future<List<Produto>> getProdutos() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/products'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Produto.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao buscar produtos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Falha na conexão. Verifique sua internet.');
    }
  }
}