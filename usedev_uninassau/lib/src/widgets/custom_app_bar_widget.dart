import 'package:flutter/material.dart';

class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppBarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, size: 30, color: Colors.black),
        onPressed: () {},
      ),
      title: Image.asset('assets/logo_usedev.png', height: 40),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.person_outline, size: 30, color: Colors.black),
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.shopping_cart_outlined,
            size: 30,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}