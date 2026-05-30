import 'produto_model.dart';

class CartItem {
  final Produto produto;
  int quantidade;

  CartItem({required this.produto, this.quantidade = 1});

  double get subtotal => produto.preco * quantidade;
}