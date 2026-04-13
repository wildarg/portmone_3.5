extension CommonExtensions<T> on T {

  R let<R>(R Function(T value) block) {
    return block(this);
  }

  T apply(void Function(T) block) {
    block(this);
    return this;
  }

  T? takeIf(bool Function(T) block) {
    return block(this)? this : null;
  }

  R? takeIfInstance<R>() {
    return this is R? this as R : null;
  }

}