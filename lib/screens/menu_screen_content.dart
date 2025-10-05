import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuScreenContent extends StatelessWidget {
  const MenuScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Este contenido se mostrará DENTRO del ResponsiveBody
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, color: Colors.white, size: 60),
          const SizedBox(height: 20),
          Text(
            'Menú Principal',
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Aquí se mostrará el contenido del menú.',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
