import 'package:flutter/material.dart';
import 'package:quanti_app/core/animations/app_animations.dart';
import 'package:quanti_app/core/theme/app_colors.dart';
import 'package:quanti_app/core/theme/app_text_styles.dart';
import 'package:quanti_app/features/transactions/domain/models/transaction_model.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionType initialType;

  const AddTransactionScreen({
    super.key,
    required this.initialType,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.normal,
      vsync: this,
    );

    _fadeAnimation = AppAnimations.fadeIn(_animationController);
    _slideAnimation = AppAnimations.slideUp(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final transaction = Transaction(
        description: _descriptionController.text,
        amount: double.parse(_amountController.text),
        type: widget.initialType,
        category: _selectedCategory,
      );

      // TODO: Implementar lógica para guardar la transacción
      Navigator.of(context).pop(transaction);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = widget.initialType == TransactionType.income;
    final color = isIncome ? AppColors.income : AppColors.expense;
    final title = isIncome ? 'Nuevo Ingreso' : 'Nuevo Gasto';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      prefixIcon: Icon(Icons.description),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Por favor ingresa una descripción';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Monto',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Por favor ingresa un monto';
                      }
                      if (double.tryParse(value!) == null) {
                        return 'Por favor ingresa un monto válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Categoría',
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: [
                      if (isIncome) ...[
                        'Salario',
                        'Inversiones',
                        'Ventas',
                        'Otros',
                      ] else ...[
                        'Comida',
                        'Transporte',
                        'Entretenimiento',
                        'Servicios',
                        'Otros',
                      ]
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Guardar ${isIncome ? "Ingreso" : "Gasto"}',
                      style: AppTextStyles.button,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 