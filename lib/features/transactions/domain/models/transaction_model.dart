import 'package:uuid/uuid.dart';

enum TransactionType {
  income,
  expense,
}

class TransactionCategories {
  static const List<String> income = [
    '💼 Salario',
    '📈 Inversiones',
    '🎁 Regalo',
    '💰 Ahorros',
    '🏢 Negocio',
    '🎯 Otro',
  ];

  static const List<String> expense = [
    '🍔 Comida',
    '🏠 Hogar',
    '🚗 Transporte',
    '🎮 Ocio',
    '👕 Ropa',
    '💊 Salud',
    '📚 Educación',
    '📱 Tecnología',
    '🎯 Otro',
  ];
}

class Transaction {
  final int? id;
  final String description;
  final double amount;
  final DateTime date;
  final String category;
  final TransactionType type;

  Transaction({this.id, required this.description, required this.amount, required this.date, required this.category, required this.type});

  // Convert a Transaction into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'type': type.toString(),
    };
  }

  // Implement toString to make it easier to see information about
  // each transaction when using the print statement.
  @override
  String toString() {
    return 'Transaction{id: $id, description: $description, amount: $amount, date: $date, category: $category, type: $type}';
  }

  // A method that retrieves all the transactions from the transactions table.
  static Transaction fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      description: map['description'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      category: map['category'],
      type: TransactionType.values.firstWhere((e) => e.toString() == map['type']),
    );
  }

  Transaction copyWith({
    int? id,
    String? description,
    double? amount,
    DateTime? date,
    String? category,
    TransactionType? type,
  }) {
    return Transaction(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      type: type ?? this.type,
    );
  }
} 