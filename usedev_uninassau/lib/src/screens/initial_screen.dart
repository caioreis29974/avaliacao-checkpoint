import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/produto_model.dart';
import '../services/product_service.dart';
import '../widgets/custom_app_bar_widget.dart';
import '../widgets/footer_widget.dart';
import '../widgets/hero_section_widget.dart';
import '../widgets/product_card_widget.dart';
import '../widgets/subscription_section_widget.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  final ProductService _productService = ProductService();
  late Future<List<Produto>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = _productService.getProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const HeroSectionWidget(),
            const SizedBox(height: 20),
            Text(
              'Promos Especiais',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.orbitron().fontFamily,
              ),
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<Produto>>(
              future: _futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(
                        color: Color(0xFF780BF7),
                      ),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Text(
                        'Falha na conexão. Tente novamente.',
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    ),
                  );
                }
                final produtos = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: produtos.length,
                  itemBuilder: (context, index) {
                    final produto = produtos[index];
                    return ProductCardWidget(
                      nome: produto.titulo,
                      url: produto.imagem,
                      preco: 'R\$ ${produto.preco.toStringAsFixed(2)}',
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/product',
                          arguments: produto,
                        );
                      },
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            const SubscriptionSectionWidget(),
            const FooterWidget(),
          ],
        ),
      ),
    );
  }
}