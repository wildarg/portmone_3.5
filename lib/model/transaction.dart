abstract class Transaction {
  final String uid;
  final DateTime date;
  final DateTime timestamp;
  final bool isPending;
  final String notes;

  const Transaction({
    required this.uid,
    required this.date,
    required this.timestamp,
    required this.isPending,
    required this.notes,
  });
}