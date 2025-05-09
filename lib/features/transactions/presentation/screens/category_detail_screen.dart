import 'package:flutter/material.dart';
import 'package:quanti_app/core/theme/app_colors.dart';
import 'package:quanti_app/features/transactions/domain/models/transaction_model.dart';
import 'package:quanti_app/shared/widgets/transaction_card.dart';
import 'package:intl/intl.dart';

class CategoryDetailScreen extends StatelessWidget {
  final String category;
  final List<Transaction> transactions;

  const CategoryDetailScreen({
    super.key,
    required this.category,
    required this.transactions,
  });

  String _formatCurrency(double value) {
    return NumberFormat.currency(
      locale: 'es_CO',
      symbol: '',
      decimalDigits: 0,
    ).format(value);
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = transactions.fold<double>(
      0,
      (sum, transaction) => sum + transaction.amount,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.expense.withOpacity(0.1),
            child: Column(
              children: [
                const Text(
                  'Total Gastado',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'COP ${_formatCurrency(totalAmount)}',
                  style: const TextStyle(
                    color: AppColors.expense,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${transactions.length} transacciones',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TransactionCard(
                    transaction: transaction,
                    onTap: () {
                      // TODO: Implementar edición de transacción
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 