import 'produto_model.dart';
 
class CartItem {
  final Produto produto;
  int quantidade;
  final String? cor;
  final String? tamanho;
 
  CartItem({
    required this.produto,
    this.quantidade = 1,
    this.cor,
    this.tamanho,
  });
 
  double get subtotal => produto.preco * quantidade;
}