import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:proyecto_3d/screens/dish_detail_screen.dart';
import '../models/dish_model.dart';

class EmptyDishInfoCard extends StatelessWidget {
  final Dish dish;
  final bool isDetailView;
  final String? categoryName;

  const EmptyDishInfoCard({
    super.key,
    required this.dish,
    this.isDetailView = false,
    this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dish.nombre,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                dish.descripcion ?? 'Sin descripción.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
                maxLines: isDetailView ? 10 : 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              if (isDetailView) ...[
                Text(
                  '\$${dish.precio.toStringAsFixed(2)}',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: Colors.amber),
                ),
                const SizedBox(height: 10),
                if (categoryName != null)
                  Chip(
                    label: Text(categoryName!),
                    backgroundColor: Colors.grey[800],
                  ),
              ] else
                _buildViewDetailsButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewDetailsButton(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.blueAccent, Colors.greenAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DishDetailScreen(dish: dish),
              ),
            );
          },
          icon: const Icon(Icons.visibility, color: Colors.white),
          label: const Text(
            'Ver detalles',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
