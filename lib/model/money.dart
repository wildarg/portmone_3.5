class Money {
  final int amountInCents;

  const Money({
    required this.amountInCents,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Money &&
          runtimeType == other.runtimeType &&
          amountInCents == other.amountInCents;

  @override
  int get hashCode => amountInCents.hashCode;

  double get asDouble => amountInCents.toDouble() / 100.toDouble();
}
