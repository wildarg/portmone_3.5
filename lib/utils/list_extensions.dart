extension ListExtensions<T> on Iterable<T> {
  List<T> sortWith(int Function(T one, T other) comparator) {
    final list = toList();
    list.sort(comparator);
    return list;
  }

  Iterable<R> mapIndexed<R>(R Function(int index, T element) convert) sync* {
    var index = 0;
    for (var element in this) {
      yield convert(index++, element);
    }
  }
}
