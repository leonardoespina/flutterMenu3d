import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFD4AF37);

    // CAMBIO 1: Eliminamos el padding horizontal.
    // ResponsiveCenterLayout ya se encarga de centrar y aplicar los márgenes
    // necesarios. Solo dejamos un padding inferior para el efecto flotante.
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          backgroundColor: Colors.black.withOpacity(0.85),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: goldColor,
          unselectedItemColor: Colors.white70,
          showUnselectedLabels: true,
          selectedFontSize: 12.0,
          unselectedFontSize: 12.0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu_outlined),
              activeIcon: Icon(Icons.restaurant_menu),
              label: 'Menu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Ordenes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star_border),
              activeIcon: Icon(Icons.star),
              label: 'Favoritos',
            ),
          ],
        ),
      ),
    );
  }
}
