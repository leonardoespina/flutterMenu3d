import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_3d/presentation/dish_providers.dart';
import 'package:badges/badges.dart' as badges;
import 'package:proyecto_3d/providers/cart_provider.dart';
import 'package:proyecto_3d/widgets/cart_bottom_sheet.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class GlassAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final double height;
  final double iconSize;
  final double buttonSpacing;
  final double horizontalPadding;
  final ValueChanged<String>? onSearch;

  const GlassAppBar({
    super.key,
    this.height = kToolbarHeight + 10,
    this.iconSize = 18.0,
    this.buttonSpacing = 8.0,
    this.horizontalPadding = 16.0,
    this.onSearch,
  });

  @override
  ConsumerState<GlassAppBar> createState() => _GlassAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _GlassAppBarState extends ConsumerState<GlassAppBar> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _showSearchIcons = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    setState(() {
      // Mostrar los íconos solo cuando hay texto
      _showSearchIcons = _searchController.text.isNotEmpty;
    });
    if (_searchController.text.isEmpty) {
      ref.read(menuProvider.notifier).setSearchQuery('');
    }
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _showSearchIcons = false;
    });
    ref.read(menuProvider.notifier).setSearchQuery('');
  }

  void _performSearch() {
    // Realizar la búsqueda con el texto actual
    if (_searchController.text.isNotEmpty) {
      ref.read(menuProvider.notifier).setSearchQuery(_searchController.text);
    }
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          _searchFocusNode.requestFocus();
        }
      });
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _showSearchIcons = false;
      _searchFocusNode.unfocus();
    });
    ref.read(menuProvider.notifier).setSearchQuery('');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.black.withOpacity(0.2),
            padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child:
                  _isSearching
                      ? _buildSearchLayout(context)
                      : _buildDefaultLayout(context),
            ),
          ),
        ),
      ),
    );
  }

  // Layout por defecto
  Widget _buildDefaultLayout(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final cartState = ref.watch(cartProvider);
        final totalItems = cartState.totalItems;

        return Row(
          key: const ValueKey('default'),
          children: [
            _buildPillButton(icon: Icons.arrow_back, onPressed: () {}),
            SizedBox(width: widget.buttonSpacing),
            _buildPillButton(icon: Icons.menu, onPressed: () {}),
            const Spacer(),
            _buildPillButton(icon: Icons.search, onPressed: _startSearch),
            SizedBox(width: widget.buttonSpacing),
            badges.Badge(
              showBadge: totalItems > 0,
              badgeContent: Text(
                '$totalItems',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
              position: badges.BadgePosition.topEnd(top: -5, end: -7),
              child: _buildPillButton(
                icon: Icons.shopping_cart_outlined,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    constraints:
                        kIsWeb ? const BoxConstraints(maxWidth: 600) : null,
                    builder: (context) => const CartBottomSheet(),
                  );
                },
              ),
            ),
            SizedBox(width: widget.buttonSpacing),
            _buildPillButton(icon: Icons.person_outline, onPressed: () {}),
          ],
        );
      },
    );
  }

  // Layout de búsqueda
  Widget _buildSearchLayout(BuildContext context) {
    return Row(
      key: const ValueKey('search'),
      children: [
        _buildPillButton(icon: Icons.arrow_back, onPressed: _stopSearch),
        SizedBox(width: widget.buttonSpacing * 2),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(25),
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Buscar...",
                hintStyle: const TextStyle(color: Colors.white70),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                filled: false,
                // Mostrar ambos íconos cuando hay texto
                suffixIcon: _showSearchIcons ? _buildSearchIcons() : null,
              ),
              style: const TextStyle(color: Colors.white),
              onSubmitted: (_) {
                _performSearch();
              },
            ),
          ),
        ),
      ],
    );
  }

  // Widget para los íconos de búsqueda y borrar
  Widget _buildSearchIcons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Ícono de búsqueda (lupa) - PRIMERO
        GestureDetector(
          onTap: _performSearch,
          child: Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search, color: Colors.white70, size: 16),
          ),
        ),
        // Ícono de borrar (X) - SEGUNDO
        GestureDetector(
          onTap: _clearSearch,
          child: Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.clear, color: Colors.white70, size: 16),
          ),
        ),
      ],
    );
  }

  // Helper para crear los botones circulares
  Widget _buildPillButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ClipOval(
      child: Material(
        color: Colors.white.withOpacity(0.1),
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(icon, color: Colors.white, size: widget.iconSize),
          ),
        ),
      ),
    );
  }
}
