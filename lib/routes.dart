// lib/routes.dart

/// Contiene los nombres de las rutas de la aplicación como constantes estáticas.
///
/// El uso de esta clase en lugar de strings puros ("hard-coded") previene errores
/// de tipeo y permite un fácil refactorizado si una ruta necesita ser renombrada.
class AppRoutes {
  /// Constructor privado para prevenir que la clase sea instanciada.
  AppRoutes._();

  /// Ruta para la pantalla inicial de bienvenida.
  /// Corresponde a la raíz del sitio ('/').
  static const String welcome = '/';

  /// Ruta para la pantalla principal del menú de la aplicación.
  static const String menu = '/menu';

  // A medida que añadas más pantallas, las defines aquí:
  // static const String profile = '/profile';
  // static const String settings = '/settings';
  //
  // Para rutas con parámetros, puedes definir una función que construya la ruta:
  // static String itemDetails(String itemId) => '/items/$itemId';
}
