import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quanti_app/core/theme/app_colors.dart';
import 'package:quanti_app/features/transactions/domain/models/transaction_model.dart';
import 'package:quanti_app/features/transactions/presentation/providers/transaction_provider.dart';
import 'package:intl/intl.dart';

class EditTransactionScreen extends StatefulWidget {
  final Transaction transaction;

  const EditTransactionScreen({
    super.key,
    required this.transaction,
  });

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _descriptionController;
  late final TextEditingController _amountController;
  late String? _selectedCategory;
  late TransactionType _type;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.transaction.description);
    _amountController = TextEditingController(
      text: NumberFormat.currency(
        locale: 'es_CO',
        symbol: '',
        decimalDigits: 0,
      ).format(widget.transaction.amount),
    );
    _selectedCategory = widget.transaction.category;
    _type = widget.transaction.type;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  String _formatCurrency(String value) {
    if (value.isEmpty) return '';
    value = value.replaceAll(RegExp(r'[^\d]'), '');
    if (value.isEmpty) return '';
    final number = int.parse(value);
    return number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  void _saveTransaction() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedTransaction = widget.transaction.copyWith(
        description: _descriptionController.text,
        amount: double.parse(_amountController.text.replaceAll('.', '')),
        type: _type,
        category: _selectedCategory ?? TransactionCategories.expense[0],
      );

      context.read<TransactionProvider>().updateTransaction(
        widget.transaction,
        updatedTransaction,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = _type == TransactionType.income
        ? TransactionCategories.income
        : TransactionCategories.expense;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Transacción'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Eliminar Transacción'),
                  content: const Text('¿Estás seguro de que deseas eliminar esta transacción?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<TransactionProvider>().deleteTransaction(widget.transaction);
                        Navigator.pop(context); // Cerrar diálogo
                        Navigator.pop(context); // Cerrar pantalla de edición
                      },
                      child: const Text(
                        'Eliminar',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<TransactionType>(
                segments: const [
                  ButtonSegment(
                    value: TransactionType.income,
                    label: Text('Ingreso'),
                    icon: Icon(Icons.add),
                  ),
                  ButtonSegment(
                    value: TransactionType.expense,
                    label: Text('Gasto'),
                    icon: Icon(Icons.remove),
                  ),
                ],
                selected: {_type},
                onSelectionChanged: (Set<TransactionType> selected) {
                  setState(() {
                    _type = selected.first;
                    _selectedCategory = null;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  hintText: _type == TransactionType.expense
                      ? '¿En qué gastaste?'
                      : '¿De dónde viene el ingreso?',
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
                  final formatted = _formatCurrency(value);
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
                  final isSelected = category == _selectedCategory;
                  return FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? category : null;
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: _type == TransactionType.expense
                        ? AppColors.expense.withOpacity(0.2)
                        : AppColors.income.withOpacity(0.2),
                    checkmarkColor: _type == TransactionType.expense
                        ? AppColors.expense
                        : AppColors.income,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? _type == TransactionType.expense
                              ? AppColors.expense
                              : AppColors.income
                          : Colors.grey,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? _type == TransactionType.expense
                                ? AppColors.expense
                                : AppColors.income
                            : AppColors.border,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _type == TransactionType.income
                      ? AppColors.income
                      : AppColors.expense,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Guardar Cambios',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 