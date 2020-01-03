class OneTimeValue<T> {
  bool used = false;
  T _value;

  OneTimeValue(this._value);

  T get value {
    T result = !used ? _value : null;
    used = true;
    return result;
  }

  T get peekValue {
    return value;
  }
}
