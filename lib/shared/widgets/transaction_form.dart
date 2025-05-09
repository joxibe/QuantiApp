import 'package:flutter/material.dart';
import 'package:quanti_app/core/theme/app_colors.dart';
import 'package:quanti_app/core/utils/formatters.dart';
import 'package:quanti_app/features/transactions/domain/models/transaction_model.dart';
import 'package:quanti_app/shared/widgets/category_chip.dart';

class TransactionForm extends StatefulWidget {
  final TransactionType type;
  final Function(String description, double amount, String category) onSave;
  final VoidCallback onCancel;

  const TransactionForm({
    super.key,
    required this.type,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  String? _selectedCategory;

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _saveTransaction() {
    if (_formKey.currentState?.validate() ?? false) {
      final amount = double.parse(_amountController.text.replaceAll('.', ''));
      widget.onSave(
        _descriptionController.text,
        amount,
        _selectedCategory ?? '',
      );
      _formKey.currentState?.reset();
      setState(() => _selectedCategory = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isExpense = widget.type == TransactionType.expense;
    final categories = isExpense
        ? TransactionCategories.expense
        : TransactionCategories.income;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Descripción',
              hintText: isExpense ? '¿En qué gastaste?' : '¿De dónde viene el ingreso?',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Por favor ingresa una descripción';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Monto',
              hintText: '0',
              prefixText: 'COP ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              final formatted = Formatters.formatInputCurrency(value);
              if (formatted != value) {
                _amountController.value = TextEditingValue(
                  text: formatted,
                  selection: TextSelection.collapsed(offset: formatted.length),
                );
              }
            },
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Por favor ingresa un monto';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: categories.map((category) {
              return CategoryChip(
                label: category,
                isSelected: category == _selectedCategory,
                isExpense: isExpense,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = selected ? category : null;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onCancel,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isExpense ? AppColors.expense : AppColors.income,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Guardar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 