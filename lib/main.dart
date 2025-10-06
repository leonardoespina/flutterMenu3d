import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_3d/components/app_background.dart';
import 'package:proyecto_3d/config/router/app_router.dart';
import 'package:proyecto_3d/data/repositories/api_service_repository.dart';
import 'package:proyecto_3d/data/repositories/mock_data_repository.dart';
import 'package:proyecto_3d/presentation/category_providers.dart';
import 'package:proyecto_3d/presentation/dish_providers.dart';

//==============================================================================
// 1. PUNTO DE ENTRADA DE LA APLICACIÓN
//==============================================================================
void main() {
  // Cambia a `true` para usar datos mock, `false` para usar la API (por defecto).
  const bool useMockData = true;

  final apiService = ApiServiceRepository();
  final mockService = MockDataRepository();

  runApp(
    ProviderScope(
      overrides:
          useMockData
              ? [
                dishRepositoryProvider.overrideWithValue(mockService),
                categoryRepositoryProvider.overrideWithValue(mockService),
              ]
              : [
                dishRepositoryProvider.overrideWithValue(apiService),
                categoryRepositoryProvider.overrideWithValue(apiService),
              ],
      child: const MyApp(),
    ),
  );
}

//==============================================================================
// 2. WIDGET RAÍZ DE LA APLICACIÓN (MyApp)
//==============================================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'App de Bienvenida',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor:
            Colors.transparent, // Crucial para que el fondo sea visible
      ),
      builder: (context, child) {
        return AppBackground(child: child ?? const SizedBox());
      },
    );
  }
}
