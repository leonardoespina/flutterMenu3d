import 'package:go_router/go_router.dart';
import 'package:proyecto_3d/screens/menu_screen.dart';
import 'package:proyecto_3d/screens/welcome_screen.dart';

// Configuración de GoRouter
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: WelcomeScreen.name,
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/menu',
      name: MenuScreen.name,
      builder: (context, state) => const MenuScreen(),
    ),
  ],
);
