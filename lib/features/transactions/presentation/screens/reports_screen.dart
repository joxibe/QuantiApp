import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quanti_app/core/theme/app_colors.dart';
import 'package:quanti_app/core/utils/formatters.dart';
import 'package:quanti_app/features/transactions/domain/models/transaction_model.dart';
import 'package:quanti_app/features/transactions/presentation/providers/transaction_provider.dart';
import 'package:quanti_app/features/transactions/presentation/screens/category_detail_screen.dart';
import 'package:quanti_app/shared/widgets/stat_row.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final transactions = provider.transactions;
    final totalIncome = provider.totalIncome;
    final totalExpenses = provider.totalExpenses;

    // Agrupar transacciones por categoría
    final expenseByCategory = <String, double>{};
    for (final transaction in transactions.where((t) => t.type == TransactionType.expense)) {
      final category = transaction.category;
      expenseByCategory[category] = (expenseByCategory[category] ?? 0) + transaction.amount;
    }

    // Calcular estadísticas
    final hasExpenses = expenseByCategory.isNotEmpty;
    final dayWithMostExpenses = hasExpenses
        ? transactions
            .where((t) => t.type == TransactionType.expense)
            .reduce((a, b) => a.amount > b.amount ? a : b)
            .date
        : DateTime.now();
    final averageDailyExpense = hasExpenses
        ? totalExpenses / transactions
            .where((t) => t.type == TransactionType.expense)
            .map((t) => t.date.day)
            .toSet()
            .length
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informes'),
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
                      'Balance del Mes',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'COP ${Formatters.formatCurrency(totalIncome - totalExpenses)}',
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
                                'COP ${Formatters.formatCurrency(totalIncome)}',
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
                                'COP ${Formatters.formatCurrency(totalExpenses)}',
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
            if (hasExpenses) ...[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Estadísticas del Mes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      StatRow(
                        icon: Icons.calendar_today,
                        title: 'Día con más gastos',
                        value: DateFormat('d MMMM').format(dayWithMostExpenses),
                        color: AppColors.expense,
                      ),
                      const SizedBox(height: 12),
                      StatRow(
                        icon: Icons.trending_up,
                        title: 'Promedio diario',
                        value: 'COP ${Formatters.formatCurrency(averageDailyExpense)}',
                        color: AppColors.primary,
                      ),
                      if (totalIncome > 0) ...[
                        const SizedBox(height: 12),
                        StatRow(
                          icon: Icons.account_balance_wallet,
                          title: 'Ahorro potencial',
                          value: 'COP ${Formatters.formatCurrency(totalIncome * 0.2)}',
                          color: AppColors.income,
                          subtitle: '20% de tus ingresos',
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Gastos por Categoría',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...expenseByCategory.entries.map((entry) {
                        final category = entry.key;
                        final amount = entry.value;
                        final percentage = (amount / totalExpenses * 100).toStringAsFixed(1);
                        final categoryTransactions = transactions
                            .where((t) => t.type == TransactionType.expense && t.category == category)
                            .toList();

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategoryDetailScreen(
                                    category: category,
                                    transactions: categoryTransactions,
                                  ),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              category,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'COP ${Formatters.formatCurrency(amount)}',
                                              style: const TextStyle(
                                                color: AppColors.expense,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '$percentage%',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  LinearProgressIndicator(
                                    value: amount / totalExpenses,
                                    backgroundColor: AppColors.expense.withOpacity(0.1),
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.expense),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ] else
              const Center(
                child: Text(
                  'No hay gastos registrados',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 