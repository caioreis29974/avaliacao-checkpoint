import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../services/cart_service.dart';
import '../widgets/custom_app_bar_widget.dart';
import '../widgets/footer_widget.dart';

class CartScreen extends StatefulWidget {
  CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  final AuthService _authService = AuthService();

  final TextEditingController _cupomController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();

  static const Map<String, double> _cuponsValidos = {
    'USEDEV10': 0.10,
    'USEDEV20': 0.20,
    'DESCONTO15': 0.15,
  };

  static const double _freteFixo = 15.0;
  static const double _freteGratis = 299.0;

  double _desconto = 0.0;
  double _frete = 0.0;
  bool _freteCalculado = false;
  String? _cupomAplicado;
  String? _erroCupom;
  String? _erroFrete;

  @override
  void dispose() {
    _cupomController.dispose();
    _cepController.dispose();
    super.dispose();
  }

  void _aplicarCupom() {
    final codigo = _cupomController.text.trim().toUpperCase();
    if (codigo.isEmpty) {
      setState(() {
        _erroCupom = 'Digite um cupom.';
      });
      return;
    }
    if (_cuponsValidos.containsKey(codigo)) {
      setState(() {
        _cupomAplicado = codigo;
        _desconto = _cartService.totalPreco * _cuponsValidos[codigo]!;
        _erroCupom = null;
      });
    } else {
      setState(() {
        _cupomAplicado = null;
        _desconto = 0.0;
        _erroCupom = 'Cupom inválido ou expirado.';
      });
    }
  }

  void _calcularFrete() {
    final cep = _cepController.text.trim().replaceAll('-', '');
    if (cep.length != 8 || int.tryParse(cep) == null) {
      setState(() {
        _erroFrete = 'CEP inválido. Digite 8 dígitos.';
        _freteCalculado = false;
      });
      return;
    }
    setState(() {
      _erroFrete = null;
      _freteCalculado = true;
      _frete = _cartService.totalPreco >= _freteGratis ? 0.0 : _freteFixo;
    });
  }

  double get _totalFinal {
    final subtotal = _cartService.totalPreco;
    final freteAplicado = _freteCalculado ? _frete : 0.0;
    double descontoAtualizado = 0.0;
    if (_cupomAplicado != null && _cuponsValidos.containsKey(_cupomAplicado)) {
      descontoAtualizado = subtotal * _cuponsValidos[_cupomAplicado]!;
    }
    return subtotal - descontoAtualizado + freteAplicado;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(),
      body: ListenableBuilder(
        listenable: _cartService,
        builder: (context, _) {
          final itens = _cartService.itens;

          if (_cupomAplicado != null && _cuponsValidos.containsKey(_cupomAplicado)) {
            _desconto = _cartService.totalPreco * _cuponsValidos[_cupomAplicado]!;
          }
          if (_freteCalculado) {
            _frete = _cartService.totalPreco >= _freteGratis ? 0.0 : _freteFixo;
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                                      fontFamily: GoogleFonts.poppins().fontFamily,
                                      fontSize: 13,
                                    ),
                                  ),
                                  if (item.cor != null || item.tamanho != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Text(
                                        [
                                          if (item.cor != null) 'Cor: ${item.cor}',
                                          if (item.tamanho != null) 'Tamanho: ${item.tamanho}',
                                        ].join('  |  '),
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[600],
                                          fontFamily: GoogleFonts.poppins().fontFamily,
                                        ),
                                      ),
                                    ),
                                  Text(
                                    item.produto.descricao,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                      fontFamily: GoogleFonts.poppins().fontFamily,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'R\$ ${item.produto.preco.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF780BF7),
                                      fontFamily: GoogleFonts.orbitron().fontFamily,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        'Quantidade:',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: GoogleFonts.poppins().fontFamily,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      _botaoQuantidade(
                                        icon: Icons.remove,
                                        onTap: () => _cartService.decrementar(index),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          '${item.quantidade}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: GoogleFonts.poppins().fontFamily,
                                          ),
                                        ),
                                      ),
                                      _botaoQuantidade(
                                        icon: Icons.add,
                                        onTap: () => _cartService.incrementar(index),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () => _cartService.removerProduto(index),
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
                                            fontFamily: GoogleFonts.poppins().fontFamily,
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
                        _campoComBotao(
                          controller: _cupomController,
                          hint: 'Cupom de desconto',
                          onPressed: _aplicarCupom,
                          erro: _erroCupom,
                          sucesso: _cupomAplicado != null
                              ? 'Cupom aplicado: ${((_cuponsValidos[_cupomAplicado]! * 100).toStringAsFixed(0))}% de desconto'
                              : null,
                        ),
                        const SizedBox(height: 8),
                        _campoComBotao(
                          controller: _cepController,
                          hint: 'Digite seu CEP',
                          onPressed: _calcularFrete,
                          erro: _erroFrete,
                          sucesso: _freteCalculado
                              ? (_frete == 0.0 ? 'Frete grátis!' : 'Frete: R\$ ${_frete.toStringAsFixed(2)}')
                              : null,
                        ),
                        const SizedBox(height: 16),
                        _linhaSumario(
                          '${itens.length} Produto${itens.length > 1 ? 's' : ''}',
                          'R\$ ${_cartService.totalPreco.toStringAsFixed(2)}',
                        ),
                        if (_desconto > 0) ...[
                          const SizedBox(height: 4),
                          _linhaSumario(
                            'Desconto ($_cupomAplicado)',
                            '- R\$ ${_desconto.toStringAsFixed(2)}',
                            cor: Colors.green,
                          ),
                        ],
                        const SizedBox(height: 4),
                        _linhaSumario(
                          'Frete',
                          _freteCalculado
                              ? (_frete == 0.0 ? 'Grátis' : 'R\$ ${_frete.toStringAsFixed(2)}')
                              : 'A calcular',
                        ),
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
                              'R\$ ${_totalFinal.toStringAsFixed(2)}',
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
                                        fontFamily: GoogleFonts.poppins().fontFamily,
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
                                        fontFamily: GoogleFonts.orbitron().fontFamily,
                                      ),
                                    ),
                                    content: Text(
                                      'Você precisa estar logado para finalizar a compra.',
                                      style: TextStyle(
                                        fontFamily: GoogleFonts.poppins().fontFamily,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text('Cancelar'),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF780BF7),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                          Navigator.pushNamed(context, '/login');
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

  Widget _campoComBotao({
    required TextEditingController controller,
    required String hint,
    required VoidCallback onPressed,
    String? erro,
    String? sucesso,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
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
              onPressed: onPressed,
              child: const Text('Ok', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        if (erro != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              erro,
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
          ),
        if (sucesso != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              sucesso,
              style: TextStyle(
                color: Colors.green,
                fontSize: 12,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
          ),
      ],
    );
  }

  Widget _linhaSumario(String label, String valor, {Color? cor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: cor,
          ),
        ),
        Text(
          valor,
          style: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: cor,
          ),
        ),
      ],
    );
  }
}