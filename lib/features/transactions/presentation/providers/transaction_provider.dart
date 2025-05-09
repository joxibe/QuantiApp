import 'package:flutter/material.dart';
import '../../domain/models/transaction_model.dart';

class TransactionProvider extends ChangeNotifier {
  final List<Transaction> _transactions = [];
  double _totalIncome = 0;
  double _totalExpenses = 0;

  TransactionProvider() {
    loadTestData();
  }

  // Getters
  List<Transaction> get transactions => List.unmodifiable(_transactions);
  double get totalIncome => _totalIncome;
  double get totalExpenses => _totalExpenses;
  double get balance => _totalIncome - _totalExpenses;

  // Métodos de cálculo
  void _updateTotals() {
    _totalIncome = _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);

    _totalExpenses = _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);

    notifyListeners();
  }

  List<Transaction> getTransactionsByMonth(DateTime date) {
    return _transactions.where((t) => 
      t.date.year == date.year && t.date.month == date.month
    ).toList();
  }

  Map<String, double> getCategoryTotals(TransactionType type) {
    final categoryTotals = <String, double>{};
    final filteredTransactions = _transactions.where((t) => t.type == type);
    
    for (var transaction in filteredTransactions) {
      categoryTotals[transaction.category] = 
          (categoryTotals[transaction.category] ?? 0) + transaction.amount;
    }
    
    return categoryTotals;
  }

  // Métodos de gestión de transacciones
  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    _updateTotals();
  }

  void updateTransaction(Transaction oldTransaction, Transaction newTransaction) {
    final index = _transactions.indexWhere((t) => t.id == oldTransaction.id);
    if (index != -1) {
      _transactions[index] = newTransaction.copyWith(id: oldTransaction.id);
      _updateTotals();
    }
  }

  void deleteTransaction(Transaction transaction) {
    _transactions.removeWhere((t) => t.id == transaction.id);
    _updateTotals();
  }

  // Métodos de análisis
  Map<String, dynamic> getMonthlyAnalysis(DateTime date) {
    final monthlyTransactions = getTransactionsByMonth(date);
    final totalTransactions = monthlyTransactions.length;
    
    if (totalTransactions == 0) {
      return {
        'totalTransactions': 0,
        'avgTransactionAmount': 0.0,
        'totalIncome': 0.0,
        'totalExpenses': 0.0,
        'balance': 0.0,
      };
    }

    final totalAmount = monthlyTransactions
        .fold(0.0, (sum, t) => sum + t.amount);

    return {
      'totalTransactions': totalTransactions,
      'avgTransactionAmount': totalAmount / totalTransactions,
      'totalIncome': monthlyTransactions
          .where((t) => t.type == TransactionType.income)
          .fold(0.0, (sum, t) => sum + t.amount),
      'totalExpenses': monthlyTransactions
          .where((t) => t.type == TransactionType.expense)
          .fold(0.0, (sum, t) => sum + t.amount),
      'balance': totalAmount,
    };
  }

  // Método para cargar datos de prueba
  void loadTestData() {
    _transactions.addAll([
      // Ingresos
      Transaction(
        id: '1',
        description: 'Salario mensual',
        amount: 5000000,
        type: TransactionType.income,
        category: TransactionCategories.income[0], // 💼 Salario
        date: DateTime.now(),
      ),
      Transaction(
        id: '2',
        description: 'Dividendos',
        amount: 1500000,
        type: TransactionType.income,
        category: TransactionCategories.income[1], // 📈 Inversiones
        date: DateTime.now(),
      ),
      // Gastos
      Transaction(
        id: '3',
        description: 'Alquiler',
        amount: 1500000,
        type: TransactionType.expense,
        category: TransactionCategories.expense[1], // 🏠 Hogar
        date: DateTime.now(),
      ),
      Transaction(
        id: '4',
        description: 'Supermercado',
        amount: 500000,
        type: TransactionType.expense,
        category: TransactionCategories.expense[0], // 🍔 Comida
        date: DateTime.now(),
      ),
      Transaction(
        id: '5',
        description: 'Servicios públicos',
        amount: 300000,
        type: TransactionType.expense,
        category: TransactionCategories.expense[1], // 🏠 Hogar
        date: DateTime.now(),
      ),
      Transaction(
        id: '6',
        description: 'Gasolina',
        amount: 200000,
        type: TransactionType.expense,
        category: TransactionCategories.expense[2], // 🚗 Transporte
        date: DateTime.now(),
      ),
    ]);
    _updateTotals();
  }
} 