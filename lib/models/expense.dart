import 'package:isar/isar.dart';

part 'expense.g.dart';

@Collection()
class Expense{
  late Id id;
  final String name;
  final double amount;
  final DateTime date;

  Expense({
    required this.name,
    required this.amount,
    required this.date,
  });
}