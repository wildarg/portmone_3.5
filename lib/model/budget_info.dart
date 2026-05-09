import 'package:portmone_bloc/model/budget.dart';
import 'package:portmone_bloc/model/money.dart';

class BudgetInfo {
  final Budget budget;
  final Money spent;
  BudgetInfo({required this.budget, required this.spent});
}