import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../transactions/domain/models/transaction_model.dart';
import '../../../transactions/presentation/providers/transaction_provider.dart';
import '../../../../shared/widgets/report_card.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  List<Transaction> _getCurrentMonthTransactions(List<Transaction> transactions) {
    final now = DateTime.now();
    return transactions.where((t) => 
      t.date.year == now.year && t.date.month == now.month
    ).toList();
  }

  Map<String, double> _calculateCategoryTotals(List<Transaction> transactions) {
    final categoryTotals = <String, double>{};
    for (var transaction in transactions) {
      categoryTotals[transaction.category] = 
          (categoryTotals[transaction.category] ?? 0) + transaction.amount;
    }
    return categoryTotals;
  }

  Widget _buildBalanceCard(TransactionProvider provider) {
    final transactions = provider.transactions;
    if (transactions.isEmpty) {
      return const Center(child: Text('No hay datos disponibles'));
    }

    final currentMonthTransactions = _getCurrentMonthTransactions(transactions);
    final totalIncome = currentMonthTransactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalExpenses = currentMonthTransactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);

    final balance = totalIncome - totalExpenses;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ingresos'),
                Text(
                  _formatCurrency(totalIncome),
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('Gastos'),
                Text(
                  _formatCurrency(totalExpenses),
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Balance'),
            Text(
              _formatCurrency(balance),
              style: TextStyle(
                color: balance >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatisticsCard(TransactionProvider provider) {
    final transactions = provider.transactions;
    if (transactions.isEmpty) {
      return const Center(child: Text('No hay datos disponibles'));
    }

    final currentMonthTransactions = _getCurrentMonthTransactions(transactions);
    final totalTransactions = currentMonthTransactions.length;
    final avgTransactionAmount = currentMonthTransactions
        .fold(0.0, (sum, t) => sum + t.amount) / totalTransactions;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Total Transacciones'),
            Text(
              totalTransactions.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('Promedio por Transacción'),
            Text(
              _formatCurrency(avgTransactionAmount),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoriesCard(TransactionProvider provider) {
    final transactions = provider.transactions;
    if (transactions.isEmpty) {
      return const Center(child: Text('No hay datos disponibles'));
    }

    final expenses = transactions
        .where((t) => t.type == TransactionType.expense)
        .toList();

    if (expenses.isEmpty) {
      return const Center(child: Text('No hay gastos registrados'));
    }

    final categoryTotals = _calculateCategoryTotals(expenses);
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < sortedCategories.length && i < 3; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(sortedCategories[i].key),
                Text(
                  _formatCurrency(sortedCategories[i].value),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informes'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Análisis detallado de tus finanzas',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              Consumer<TransactionProvider>(
                builder: (context, provider, _) => Column(
                  children: [
                    ReportCard(
                      title: 'Balance del Mes',
                      icon: Icons.account_balance_wallet,
                      color: Colors.blue,
                      subtitle: 'Resumen de ingresos y gastos',
                      content: _buildBalanceCard(provider),
                      onTap: () {
                        // TODO: Navegar a vista detallada del balance
                      },
                    ),
                    const SizedBox(height: 16),
                    ReportCard(
                      title: 'Estadísticas del Mes',
                      icon: Icons.trending_up,
                      color: Colors.orange,
                      subtitle: 'Análisis de tendencias',
                      content: _buildStatisticsCard(provider),
                      onTap: () {
                        // TODO: Navegar a vista detallada de estadísticas
                      },
                    ),
                    const SizedBox(height: 16),
                    ReportCard(
                      title: 'Gastos por Categoría',
                      icon: Icons.pie_chart,
                      color: Colors.red,
                      subtitle: 'Distribución de gastos',
                      content: _buildCategoriesCard(provider),
                      onTap: () {
                        // TODO: Navegar a vista detallada de categorías
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 