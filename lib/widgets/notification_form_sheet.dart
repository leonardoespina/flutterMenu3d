import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'confirmation_sheet.dart';

class NotificationFormSheet extends StatefulWidget {
  final String currency;
  final double totalAmount;
  const NotificationFormSheet({
    super.key,
    required this.currency,
    required this.totalAmount,
  });

  @override
  State<NotificationFormSheet> createState() => _NotificationFormSheetState();
}

class _NotificationFormSheetState extends State<NotificationFormSheet> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Common fields
  final TextEditingController _dateController = TextEditingController();
  String? _selectedBank;
  final List<String> _banks = [
    'Banco de Venezuela',
    'Banesco',
    'Mercantil',
    'Provincial',
  ];

  // USD specific fields
  String? _selectedUsdMethod;
  final List<String> _usdMethods = [
    'Zelle',
    'Efectivo',
    'Transferencia Bancaria',
  ];

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const ConfirmationSheet()),
          (Route<dynamic> route) => route.isFirst,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBolivares = widget.currency == 'Bolívares';

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifica tu pago en ${widget.currency}'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Text(
              'Monto a Notificar:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              NumberFormat.currency(
                symbol: isBolivares ? 'Bs. ' : '\$ ',
                decimalDigits: 2,
              ).format(widget.totalAmount),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            if (isBolivares)
              ..._buildBolivaresFields()
            else
              ..._buildDolaresFields(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                          'Notificar Pago en ${isBolivares ? "Bs." : "\$"}',
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBolivaresFields() {
    return [
      TextFormField(
        controller: _dateController,
        decoration: const InputDecoration(
          labelText: 'Fecha del pago',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        readOnly: true,
        onTap: _selectDate,
        validator:
            (value) =>
                (value == null || value.isEmpty)
                    ? 'Selecciona una fecha'
                    : null,
      ),
      const SizedBox(height: 16),
      DropdownButtonFormField<String>(
        value: _selectedBank,
        items:
            _banks
                .map((bank) => DropdownMenuItem(value: bank, child: Text(bank)))
                .toList(),
        onChanged: (value) => setState(() => _selectedBank = value),
        decoration: const InputDecoration(
          labelText: 'Banco de origen',
          border: OutlineInputBorder(),
        ),
        validator: (value) => value == null ? 'Selecciona un banco' : null,
      ),
      const SizedBox(height: 16),
      TextFormField(
        decoration: const InputDecoration(
          labelText: 'Número de referencia',
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.text,
        maxLength: 20,
        validator:
            (value) =>
                (value == null || value.isEmpty)
                    ? 'Ingresa la referencia'
                    : null,
      ),
    ];
  }

  List<Widget> _buildDolaresFields() {
    return [
      DropdownButtonFormField<String>(
        value: _selectedUsdMethod,
        items:
            _usdMethods
                .map(
                  (method) =>
                      DropdownMenuItem(value: method, child: Text(method)),
                )
                .toList(),
        onChanged: (value) => setState(() => _selectedUsdMethod = value),
        decoration: const InputDecoration(
          labelText: 'Método de pago',
          border: OutlineInputBorder(),
        ),
        validator: (value) => value == null ? 'Selecciona un método' : null,
      ),
      const SizedBox(height: 16),
      TextFormField(
        decoration: const InputDecoration(
          labelText: 'Referencia o email de confirmación',
          border: OutlineInputBorder(),
          helperText: 'Ej: Código de Zelle, nombre de quien envía, etc.',
        ),
        keyboardType: TextInputType.text,
        validator:
            (value) =>
                (value == null || value.isEmpty)
                    ? 'Ingresa la referencia'
                    : null,
      ),
    ];
  }
}
