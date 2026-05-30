import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/produto_model.dart';

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> _itens = [];

  List<CartItem> get itens => List.unmodifiable(_itens);

  int get totalItens => _itens.fold(0, (sum, item) => sum + item.quantidade);

  double get totalPreco => _itens.fold(0.0, (sum, item) => sum + item.subtotal);

  void adicionarProduto(
    Produto produto, {
    int quantidade = 1,
    String? cor,
    String? tamanho,
  }) {
    final index = _itens.indexWhere(
      (i) =>
          i.produto.id == produto.id &&
          i.cor == cor &&
          i.tamanho == tamanho,
    );
    if (index >= 0) {
      _itens[index].quantidade += quantidade;
    } else {
      _itens.add(
        CartItem(
          produto: produto,
          quantidade: quantidade,
          cor: cor,
          tamanho: tamanho,
        ),
      );
    }
    notifyListeners();
  }

  void removerProduto(int index) {
    _itens.removeAt(index);
    notifyListeners();
  }

  void incrementar(int index) {
    if (index >= 0 && index < _itens.length) {
      _itens[index].quantidade++;
      notifyListeners();
    }
  }

  void decrementar(int index) {
    if (index >= 0 && index < _itens.length) {
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