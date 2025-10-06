import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_3d/providers/cart_provider.dart';
import 'package:proyecto_3d/models/cart_item_model.dart';
import 'payment_management_bottom_sheet.dart';

class CartBottomSheet extends ConsumerWidget {
  const CartBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final theme = Theme.of(context);

    final currencyFormat = NumberFormat.currency(
      symbol: cartState.currency == Currency.usd ? '\$' : 'VES ',
      decimalDigits: 2,
    );

    final double totalInSelectedCurrency =
        cartState.currency == Currency.usd
            ? cartState.total
            : cartState.total * cartState.usdToVesRate;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, controller) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24.0),
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(context, theme),
                  const SizedBox(height: 16),

                  // Content
                  cartState.items.isEmpty
                      ? _buildEmptyCart(context)
                      : _buildCartContent(
                        controller,
                        cartState,
                        cartNotifier,
                        currencyFormat,
                      ),

                  // Footer
                  if (cartState.items.isNotEmpty)
                    _buildFooter(
                      context,
                      theme,
                      cartState,
                      cartNotifier,
                      currencyFormat,
                      totalInSelectedCurrency,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tu Pedido', style: theme.textTheme.headlineMedium),
            Text('Para: Cames Rojas', style: theme.textTheme.bodySmall),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Tu carrito está vacío.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '¡Agrega algo delicioso para empezar!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the sheet
                // Optional: Navigate to menu screen
                // GoRouter.of(context).go('/menu');
              },
              child: const Text('Ver Menú'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartContent(
    ScrollController controller,
    CartState cartState,
    CartNotifier cartNotifier,
    NumberFormat currencyFormat,
  ) {
    return Expanded(
      child: ListView.separated(
        controller: controller,
        itemCount: cartState.items.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final item = cartState.items[index];
          return _buildCartItemTile(item, cartNotifier, currencyFormat);
        },
      ),
    );
  }

  Widget _buildCartItemTile(
    CartItem item,
    CartNotifier cartNotifier,
    NumberFormat currencyFormat,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        // Se elimina Image.network para evitar el error con URLs de modelos 3D.
        // Se muestra un ícono de marcador de posición en su lugar.
        child: const SizedBox(
          width: 50,
          height: 50,
          child: Icon(Icons.restaurant, size: 40),
        ),
      ),
      title: Text(
        item.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(currencyFormat.format(item.price)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuantitySelector(item, cartNotifier),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red, size: 20),
            onPressed: () => cartNotifier.removeItem(item.productId),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(CartItem item, CartNotifier cartNotifier) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline, size: 22),
          onPressed:
              () => cartNotifier.updateQuantity(
                item.productId,
                item.quantity - 1,
              ),
        ),
        Text(
          '${item.quantity}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline, size: 22),
          onPressed:
              () => cartNotifier.updateQuantity(
                item.productId,
                item.quantity + 1,
              ),
        ),
      ],
    );
  }

  Widget _buildFooter(
    BuildContext context,
    ThemeData theme,
    CartState cartState,
    CartNotifier cartNotifier,
    NumberFormat currencyFormat,
    double total,
  ) {
    return Column(
      children: [
        const Divider(),
        _buildCurrencyToggle(cartState, cartNotifier),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total:', style: theme.textTheme.titleLarge),
            Text(
              currencyFormat.format(total),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => _showClearCartDialog(context, cartNotifier),
                child: const Text('Limpiar Pedido'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  // Close the cart sheet first
                  Navigator.of(context).pop();
                  // Then, show the new payment management sheet
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24.0),
                      ),
                    ),
                    builder:
                        (context) => PaymentManagementBottomSheet(
                          totalAmount: total,
                          currency:
                              cartState.currency == Currency.usd
                                  ? 'USD'
                                  : 'VES',
                        ),
                  );
                },
                child: const Text('Realizar Pedido'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrencyToggle(CartState cartState, CartNotifier cartNotifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Moneda:'),
        const SizedBox(width: 8),
        FilterChip(
          label: const Text('USD'),
          selected: cartState.currency == Currency.usd,
          onSelected: (_) => cartNotifier.toggleCurrency(),
        ),
        const SizedBox(width: 8),
        FilterChip(
          label: const Text('VES'),
          selected: cartState.currency == Currency.ves,
          onSelected: (_) => cartNotifier.toggleCurrency(),
        ),
      ],
    );
  }

  void _showClearCartDialog(BuildContext context, CartNotifier cartNotifier) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text(
            '¿Estás seguro de que quieres vaciar tu carrito?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('Limpiar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                cartNotifier.clearCart();
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Carrito vaciado')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
