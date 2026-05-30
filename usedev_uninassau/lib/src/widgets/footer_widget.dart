import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: const Color(0xFF090321),
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset('assets/logo_usedev_verde.png', height: 70),
                    const SizedBox(height: 12),
                    Text(
                      'Hora de abraçar seu lado geek!',
                      style: TextStyle(
                        color: const Color(0xFF8FFF24),
                        fontFamily: GoogleFonts.orbitron().fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 150,
                      height: 1.5,
                      color: const Color(0xFF8FFF24),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _buildSecao('Funcionamento', [
                'Segunda a Sexta - 8h às 18h',
                'sac@usedev.com.br',
                '0800 541 320',
              ]),
              const SizedBox(height: 30),
              _buildSecao('Institucional', [
                'Sobre nós',
                'Contato',
                'Política de Privacidade',
                'LGPD - Lei de proteção de dados',
              ]),
              const SizedBox(height: 30),
              _buildSecao('Informações', [
                'Entregas',
                'Garantia',
                'Trocas e devoluções',
              ]),
              const SizedBox(height: 30),
              Text(
                'Formas de Pagamento',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  _buildIconePagamento('assets/Ícones/ico-cartao-visa.png'),
                  _buildIconePagamento('assets/Ícones/ico-cartao-master.png'),
                  _buildIconePagamento('assets/Ícones/ico-cartao-elo.png'),
                  _buildIconePagamento('assets/Ícones/ico-cartao-diners.png'),
                  _buildIconePagamento('assets/Ícones/ico-pix.png'),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Siga nossas redes:',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialIcon('assets/Ícones/Whatsapp.png'),
                        const SizedBox(width: 20),
                        _buildSocialIcon('assets/Ícones/Instragam.png'),
                        const SizedBox(width: 20),
                        _buildSocialIcon('assets/Ícones/Tiktok.png'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: Text(
            'Desenvolvido por Alura. Projeto fictício sem fins comerciais.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecao(String titulo, List<String> itens) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 12),
        ...itens.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              item,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 15,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconePagamento(String path) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Image.asset(path, height: 25),
    );
  }

  Widget _buildSocialIcon(String path) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFFF00A0), width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Image.asset(
        path,
        height: 24,
        width: 24,
        color: const Color(0xFFFF00A0),
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(path, height: 24, width: 24);
        },
      ),
    );
  }
}