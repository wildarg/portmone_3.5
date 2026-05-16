class TransactionType {
  final String uid;
  final String name;
  final bool isArchived;
  TransactionType({required this.uid, required this.name, this.isArchived = false});

  TransactionType copyWith({
    String? uid,
    String? name,
    bool? isArchived,
  }) {
    return TransactionType(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}