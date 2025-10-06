import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'confirmation_sheet.dart';

class C2PFormSheet extends StatefulWidget {
  final double totalAmount;
  final String currency;

  const C2PFormSheet({
    super.key,
    required this.totalAmount,
    required this.currency,
  });

  @override
  State<C2PFormSheet> createState() => _C2PFormSheetState();
}

class _C2PFormSheetState extends State<C2PFormSheet> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _selectedBank;
  final List<String> _banks = [
    'Banco de Venezuela',
    'Banesco',
    'Mercantil',
    'Provincial',
  ];

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ConfirmationSheet()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, corrige los errores en el formulario.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Completa los datos del pago'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Text('Monto a Pagar:', style: theme.textTheme.titleMedium),
            Text(
              NumberFormat.currency(
                symbol: widget.currency == 'USD' ? '\$ ' : 'Bs. ',
                decimalDigits: 2,
              ).format(widget.totalAmount),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: _selectedBank,
              items:
                  _banks.map((bank) {
                    return DropdownMenuItem(value: bank, child: Text(bank));
                  }).toList(),
              onChanged: (value) => setState(() => _selectedBank = value),
              decoration: const InputDecoration(
                labelText: 'Banco desde el que pagas',
                border: OutlineInputBorder(),
                helperText: 'Selecciona el banco de origen de los fondos.',
              ),
              validator:
                  (value) =>
                      value == null ? 'Por favor, selecciona un banco' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Número de Teléfono',
                border: OutlineInputBorder(),
                helperText: 'Registrado para operaciones C2P.',
                prefixText: '+58 ',
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingresa tu número de teléfono';
                }
                // Simple validation for length
                if (value.length < 10) {
                  return 'El número de teléfono es muy corto';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Cédula de Identidad',
                border: OutlineInputBorder(),
                helperText: 'Sin puntos ni comas.',
              ),
              keyboardType: TextInputType.number,
              maxLength: 10,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingresa tu cédula';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Clave dinámica C2P',
                border: OutlineInputBorder(),
                helperText: 'El código que envía tu banco por SMS.',
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 6,
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'La clave debe tener 6 dígitos';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                          'Pagar ${NumberFormat.currency(symbol: widget.currency == 'USD' ? '\$ ' : 'Bs. ', decimalDigits: 2).format(widget.totalAmount)}',
                        ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Ayuda con C2P'),
                          content: const Text(
                            'El pago C2P (Comercio a Persona) es una transferencia inmediata que requiere una clave dinámica que tu banco te envía por SMS al momento de la operación.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Entendido'),
                            ),
                          ],
                        ),
                  );
                },
                child: const Text('¿Necesitas ayuda con C2P?'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
