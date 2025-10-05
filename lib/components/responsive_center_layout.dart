import 'package:flutter/material.dart';

/// Un widget que centra su contenido y le impone un ancho máximo para
/// mejorar la legibilidad en pantallas grandes.
class ResponsiveCenterLayout extends StatelessWidget {
  final Widget child;
  const ResponsiveCenterLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
          child: child,
        ),
      ),
    );
  }
}
