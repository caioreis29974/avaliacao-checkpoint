import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../services/cart_service.dart';
import '../widgets/custom_app_bar_widget.dart';
import '../widgets/footer_widget.dart';

class CartScreen extends StatelessWidget {
  final CartService _cartService = CartService();
  final AuthService _authService = AuthService();

  CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(),
      body: ListenableBuilder(
        listenable: _cartService,
        builder: (context, _) {
          final itens = _cartService.itens;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Breadcrumb
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        const Icon(Icons.arrow_back_ios, size: 16),
                        Text(
                          'Carrinho de Compras',
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Banner de aviso
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F4FD),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF2196F3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Color(0xFF2196F3),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Atenção, os produtos no carrinho não ficam reservados. Finalize a compra para garantir! :)',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            color: const Color(0xFF1565C0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Título
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Detalhes da compra',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Lista de itens
                if (itens.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Text(
                        'Seu carrinho está vazio.',
                        style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: itens.length,
                    itemBuilder: (context, index) {
                      final item = itens[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Imagem
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.produto.imagem,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.produto.titulo,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    item.produto.descricao,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'R\$ ${item.produto.preco.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF780BF7),
                                      fontFamily:
                                          GoogleFonts.orbitron().fontFamily,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Controles de quantidade
                                  Row(
                                    children: [
                                      Text(
                                        'Quantidade:',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      _botaoQuantidade(
                                        icon: Icons.remove,
                                        onTap: () => _cartService.decrementar(
                                          item.produto.id,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Text(
                                          '${item.quantidade}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: GoogleFonts.poppins()
                                                .fontFamily,
                                          ),
                                        ),
                                      ),
                                      _botaoQuantidade(
                                        icon: Icons.add,
                                        onTap: () => _cartService.incrementar(
                                          item.produto.id,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Excluir
                                  GestureDetector(
                                    onTap: () => _cartService.removerProduto(
                                      item.produto.id,
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.delete_outline,
                                          size: 18,
                                          color: Colors.red,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Excluir',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                            fontFamily: GoogleFonts.poppins()
                                                .fontFamily,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                // Sumário
                if (itens.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sumário',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Cupom
                        _campoComBotao('Cupom de desconto'),
                        const SizedBox(height: 8),

                        // Frete
                        _campoComBotao('Frete'),
                        const SizedBox(height: 16),

                        // Totais
                        _linhaSumario(
                          '${itens.length} Produto${itens.length > 1 ? 's' : ''}',
                          'R\$ ${_cartService.totalPreco.toStringAsFixed(2)}',
                        ),
                        const SizedBox(height: 4),
                        _linhaSumario('Frete', 'R\$ 8,00'),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                            Text(
                              'R\$ ${(_cartService.totalPreco + 8).toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF780BF7),
                                fontFamily: GoogleFonts.orbitron().fontFamily,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Botão continuar comprando
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Color(0xFF780BF7),
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Continuar comprando',
                              style: TextStyle(
                                color: const Color(0xFF780BF7),
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Botão ir para pagamento
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF780BF7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              final logado = await _authService.isLoggedIn();
                              if (!context.mounted) return;
                              if (logado) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Pedido realizado com sucesso!',
                                      style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                      ),
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text(
                                      'Login necessário',
                                      style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.orbitron().fontFamily,
                                      ),
                                    ),
                                    content: Text(
                                      'Você precisa estar logado para finalizar a compra.',
                                      style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text('Cancelar'),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF780BF7,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                          Navigator.pushNamed(
                                            context,
                                            '/login',
                                          );
                                        },
                                        child: const Text(
                                          'Fazer Login',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            child: Text(
                              'Ir para pagamento',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],

                const FooterWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _botaoQuantidade({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }

  Widget _campoComBotao(String hint) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 13,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF780BF7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {},
          child: const Text('Ok', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _linhaSumario(String label, String valor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily),
        ),
        Text(
          valor,
          style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily),
        ),
      ],
    );
  }
}