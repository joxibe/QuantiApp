import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quanti_app/core/theme/app_colors.dart';
import 'package:quanti_app/features/transactions/domain/models/transaction_model.dart';
import 'package:quanti_app/features/transactions/presentation/providers/transaction_provider.dart';
import 'package:quanti_app/shared/widgets/action_button.dart';
import 'package:quanti_app/shared/widgets/transaction_card.dart';
import 'package:quanti_app/shared/widgets/transaction_form.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TransactionType? _selectedType;
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  String? _selectedCategory;

  String _formatCurrency(double value) {
    return NumberFormat.currency(
      locale: 'es_CO',
      symbol: '',
      decimalDigits: 0,
    ).format(value);
  }

  void _showTransactionForm(TransactionType type) {
    setState(() {
      _selectedType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final transactions = provider.transactions;
    final totalIncome = provider.totalIncome;
    final totalExpenses = provider.totalExpenses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('QuantiApp'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Balance Total',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'COP ${_formatCurrency(totalIncome - totalExpenses)}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Ingresos',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'COP ${_formatCurrency(totalIncome)}',
                                style: const TextStyle(
                                  color: AppColors.income,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Gastos',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'COP ${_formatCurrency(totalExpenses)}',
                                style: const TextStyle(
                                  color: AppColors.expense,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ActionButton(
                    label: 'Nuevo Ingreso',
                    icon: Icons.add,
                    color: AppColors.income,
                    isSelected: _selectedType == TransactionType.income,
                    onTap: () => _showTransactionForm(TransactionType.income),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ActionButton(
                    label: 'Nuevo Gasto',
                    icon: Icons.remove,
                    color: AppColors.expense,
                    isSelected: _selectedType == TransactionType.expense,
                    onTap: () => _showTransactionForm(TransactionType.expense),
                  ),
                ),
              ],
            ),
            if (_selectedType != null) ...[
              const SizedBox(height: 24),
              TransactionForm(
                type: _selectedType!,
                onSave: _saveTransaction,
                onCancel: () {
                  setState(() {
                    _selectedType = null;
                  });
                },
              ),
            ],
            const SizedBox(height: 24),
            const Text(
              'Historial',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (transactions.isEmpty)
              const Center(
                child: Text(
                  'No hay transacciones',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              )
            else
              ...transactions.map((transaction) {
                return TransactionCard(
                  transaction: transaction,
                  onTap: () {
                    // TODO: Implementar edición de transacción
                  },
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  void _saveTransaction(String description, double amount, String category) {
    if (_selectedType == null) return;

    final transaction = Transaction(
      description: description,
      amount: amount,
      type: _selectedType!,
      category: category,
      date: DateTime.now(),
    );

    context.read<TransactionProvider>().addTransaction(transaction);
    setState(() {
      _selectedType = null;
    });
  }
} 