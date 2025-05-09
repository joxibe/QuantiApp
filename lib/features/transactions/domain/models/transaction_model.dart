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
  final String id;
  final String description;
  final double amount;
  final TransactionType type;
  final String category;
  final DateTime date;

  Transaction({
    String? id,
    required this.description,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
  }) : id = id ?? const Uuid().v4();

  Transaction copyWith({
    String? id,
    String? description,
    double? amount,
    TransactionType? type,
    String? category,
    DateTime? date,
  }) {
    return Transaction(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'type': type.toString(),
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      description: json['description'] as String,
      amount: json['amount'] as double,
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      category: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Transaction &&
        other.id == id &&
        other.description == description &&
        other.amount == amount &&
        other.type == type &&
        other.category == category &&
        other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        amount.hashCode ^
        type.hashCode ^
        category.hashCode ^
        date.hashCode;
  }
} 