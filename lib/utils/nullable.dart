class Nullable<T> {
  final T? value;
  Nullable(this.value);

  bool get hasData => value != null;
  bool get isNull => value == null;
}
