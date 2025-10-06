import 'package:flutter/material.dart';
import 'notification_form_sheet.dart';

class NotifyPaymentSheet extends StatefulWidget {
  final double totalAmount;
  final String currency;

  const NotifyPaymentSheet({
    super.key,
    required this.totalAmount,
    required this.currency,
  });

  @override
  State<NotifyPaymentSheet> createState() => _NotifyPaymentSheetState();
}

class _NotifyPaymentSheetState extends State<NotifyPaymentSheet> {
  @override
  void initState() {
    super.initState();
    // If the currency from the cart is USD, skip the selection and go directly to the USD form.
    if (widget.currency == 'USD') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder:
                (context) => NotificationFormSheet(
                  currency: 'Dólares',
                  totalAmount: widget.totalAmount,
                ),
          ),
        );
      });
    }
  }

  void _navigateToForm(BuildContext context, String selectedCurrency) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => NotificationFormSheet(
              currency: selectedCurrency,
              totalAmount: widget.totalAmount,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // This view will only be shown if the cart currency is not USD.
    if (widget.currency == 'USD') {
      // Show a loader while the navigation happens.
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificar un Pago'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              '¿En qué moneda realizaste el pago?',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.account_balance_wallet),
                      label: const Text('Bolívares (Bs.)'),
                      onPressed: () => _navigateToForm(context, 'Bolívares'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.attach_money),
                      label: const Text('Dólares (\$)'),
                      onPressed: () => _navigateToForm(context, 'Dólares'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                        foregroundColor: theme.colorScheme.onSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
