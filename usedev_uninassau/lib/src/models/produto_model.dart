class Produto {
  final int id;
  final String titulo;
  final double preco;
  final String descricao;
  final String categoria;
  final String imagem;

  const Produto({
    required this.id,
    required this.titulo,
    required this.preco,
    required this.descricao,
    required this.categoria,
    required this.imagem,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'] as int,
      titulo: json['title'] as String,
      preco: (json['price'] as num).toDouble(),
      descricao: json['description'] as String,
      categoria: json['category'] as String,
      imagem: json['image'] as String,
    );
  }
}