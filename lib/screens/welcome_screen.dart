import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_3d/components/responsive_center_layout.dart';

class WelcomeScreen extends StatelessWidget {
  static const String name = 'welcome_screen';
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFD4AF37);

    return Scaffold(
      body: SafeArea(
        child: ResponsiveCenterLayout(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.65),
              borderRadius: BorderRadius.circular(35.0),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final height = constraints.maxHeight;
                // Para evitar que el texto sea demasiado pequeño en alturas extremas
                final textScaleFactor = (height / 600).clamp(0.8, 1.5);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: height * 0.03),
                      Icon(
                        Icons.restaurant_menu_sharp,
                        color: goldColor,
                        size: height * 0.08, // Responsivo
                      ),
                      SizedBox(height: height * 0.01),
                      Text(
                        'La Cabaña Steak House',
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(
                          color: goldColor,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          fontSize: 30 * textScaleFactor, // Responsivo
                        ),
                      ),
                      const Spacer(flex: 2),
                      Text(
                        '¡Bienvenido!',
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 40 * textScaleFactor, // Responsivo
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Text(
                        'Gracias por su Visita',
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: Colors.white70,
                          fontSize: 18 * textScaleFactor, // Responsivo
                        ),
                      ),
                      SizedBox(height: height * 0.05),
                      Center(
                        child: SizedBox(
                          width: 150 * textScaleFactor, // Responsivo
                          child: _EnterButton(
                            onPressed: () => context.go('/menu'),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Registrar Ahora',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 16 * textScaleFactor, // Responsivo
                          ),
                        ),
                      ),
                      const Spacer(flex: 3),
                      Text(
                        'RIF: J-12345678-9\nDirección: Av. Principal, Local 10, Ciudad',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white60,
                          fontSize: 12 * textScaleFactor, // Responsivo
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      TextButton(
                        onPressed: () {},
                        child: Column(
                          children: [
                            Icon(
                              Icons.keyboard_arrow_up,
                              color: goldColor,
                              size: 24 * textScaleFactor,
                            ),
                            SizedBox(height: 2 * textScaleFactor),
                            Text(
                              'Login',
                              style: TextStyle(
                                color: goldColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14 * textScaleFactor, // Responsivo
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget privado para el botón "Entrar".
class _EnterButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _EnterButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE3C378), Color(0xFFB38B40)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              'Entrar',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
