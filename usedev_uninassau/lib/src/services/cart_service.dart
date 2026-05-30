import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/produto_model.dart';

class CartService extends ChangeNotifier {
  // Singleton
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> _itens = [];

  List<CartItem> get itens => List.unmodifiable(_itens);

  int get totalItens => _itens.fold(0, (sum, item) => sum + item.quantidade);

  double get totalPreco => _itens.fold(0.0, (sum, item) => sum + item.subtotal);

  void adicionarProduto(Produto produto) {
    final index = _itens.indexWhere((i) => i.produto.id == produto.id);
    if (index >= 0) {
      _itens[index].quantidade++;
    } else {
      _itens.add(CartItem(produto: produto));
    }
    notifyListeners();
  }

  void removerProduto(int produtoId) {
    _itens.removeWhere((i) => i.produto.id == produtoId);
    notifyListeners();
  }

  void incrementar(int produtoId) {
    final index = _itens.indexWhere((i) => i.produto.id == produtoId);
    if (index >= 0) {
      _itens[index].quantidade++;
      notifyListeners();
    }
  }

  void decrementar(int produtoId) {
    final index = _itens.indexWhere((i) => i.produto.id == produtoId);
    if (index >= 0) {
      if (_itens[index].quantidade > 1) {
        _itens[index].quantidade--;
      } else {
        _itens.removeAt(index);
      }
      notifyListeners();
    }
  }

  void limpar() {
    _itens.clear();
    notifyListeners();
  }
}