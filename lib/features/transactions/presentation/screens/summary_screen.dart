import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quanti_app/core/theme/app_colors.dart';
import 'package:quanti_app/features/transactions/domain/models/transaction_model.dart';
import 'package:quanti_app/features/transactions/presentation/providers/transaction_provider.dart';
import 'package:intl/intl.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  String _formatCurrency(double value) {
    return NumberFormat.currency(
      locale: 'es_CO',
      symbol: '',
      decimalDigits: 0,
    ).format(value);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final transactions = provider.transactions;

    // Agrupar transacciones por mes
    final transactionsByMonth = <String, List<Transaction>>{};
    for (final transaction in transactions) {
      final month = DateFormat('MMMM yyyy').format(transaction.date);
      transactionsByMonth.putIfAbsent(month, () => []).add(transaction);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (transactionsByMonth.isEmpty)
              const Center(
                child: Text(
                  'No hay transacciones registradas',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              )
            else
              ...transactionsByMonth.entries.map((entry) {
                final monthTransactions = entry.value;
                final monthIncome = monthTransactions
                    .where((t) => t.type == TransactionType.income)
                    .fold(0.0, (sum, t) => sum + t.amount);
                final monthExpenses = monthTransactions
                    .where((t) => t.type == TransactionType.expense)
                    .fold(0.0, (sum, t) => sum + t.amount);

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Ingresos',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'COP ${_formatCurrency(monthIncome)}',
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Gastos',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'COP ${_formatCurrency(monthExpenses)}',
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
                        const SizedBox(height: 16),
                        const Text(
                          'Transacciones',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...monthTransactions.map((transaction) {
                          final isExpense = transaction.type == TransactionType.expense;
                          final color = isExpense ? AppColors.expense : AppColors.income;
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: color.withOpacity(0.1),
                              child: Icon(
                                isExpense ? Icons.remove : Icons.add,
                                color: color,
                              ),
                            ),
                            title: Text(transaction.description),
                            subtitle: Text(
                              transaction.category ?? 'Sin categoría',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            trailing: Text(
                              '${isExpense ? '-' : '+'} COP ${_formatCurrency(transaction.amount)}',
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
} 