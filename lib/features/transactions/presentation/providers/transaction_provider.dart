import 'package:flutter/material.dart';
import '../../domain/models/transaction_model.dart';
import '../../../../core/database/database_helper.dart';

class TransactionProvider extends ChangeNotifier {
  final List<Transaction> _transactions = [];
  double _totalIncome = 0;
  double _totalExpenses = 0;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  TransactionProvider() {
    _loadTransactionsFromDatabase();
  }

  Future<void> _loadTransactionsFromDatabase() async {
    final transactions = await _dbHelper.getTransactions();
    _transactions.addAll(transactions);
    _updateTotals();
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
  Future<void> addTransaction(Transaction transaction) async {
    await _dbHelper.insertTransaction(transaction);
    _transactions.add(transaction);
    _updateTotals();
  }

  Future<void> updateTransaction(Transaction oldTransaction, Transaction newTransaction) async {
    await _dbHelper.updateTransaction(newTransaction);
    final index = _transactions.indexWhere((t) => t.id == oldTransaction.id);
    if (index != -1) {
      _transactions[index] = newTransaction.copyWith(id: oldTransaction.id);
      _updateTotals();
    }
  }

  Future<void> deleteTransaction(Transaction transaction) async {
    await _dbHelper.deleteTransaction(transaction.id!);
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
} 