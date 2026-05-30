import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../widgets/custom_app_bar_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _senhaVisivel = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _fazerLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Preencha todos os campos.',
            style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily),
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final sucesso = await _authService.login(username, password);
      if (!context.mounted) return;

      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Login realizado com sucesso!',
              style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily),
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Usuário ou senha incorretos.',
              style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Falha na conexão. Verifique sua internet.',
            style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),

            // Logo
            Center(child: Image.asset('assets/logo_usedev.png', height: 60)),
            const SizedBox(height: 32),

            // Título
            Text(
              'Entrar na conta',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.orbitron().fontFamily,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Use: mor_2314 / 83r5^_',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
            const SizedBox(height: 32),

            // Campo usuário
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Usuário',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF780BF7),
                    width: 2,
                  ),
                ),
              ),
              style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily),
            ),
            const SizedBox(height: 16),

            // Campo senha
            TextField(
              controller: _passwordController,
              obscureText: !_senhaVisivel,
              decoration: InputDecoration(
                labelText: 'Senha',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _senhaVisivel ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() => _senhaVisivel = !_senhaVisivel);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF780BF7),
                    width: 2,
                  ),
                ),
              ),
              style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily),
            ),
            const SizedBox(height: 32),

            // Botão login
            SizedBox(
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF780BF7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isLoading ? null : _fazerLogin,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Entrar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // Dica de credenciais
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E5FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '💡 Para testar, use as credenciais da FakeStore API:\nUsuário: mor_2314\nSenha: 83r5^_',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: const Color(0xFF780BF7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}