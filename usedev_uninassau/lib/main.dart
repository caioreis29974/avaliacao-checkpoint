import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'src/screens/initial_screen.dart';
import 'src/screens/product_detail_screen.dart';
import 'src/screens/cart_screen.dart';
import 'src/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UseDev',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF780BF7)),
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const InitialScreen(),
        '/product': (context) => const ProductDetailScreen(),
        '/cart': (context) => CartScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}