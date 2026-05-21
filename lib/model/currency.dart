class Currency {
  final String uid;
  final String name;
  const Currency({required this.uid, required this.name});

  static const Currency empty = Currency(uid: '', name: '');
}
