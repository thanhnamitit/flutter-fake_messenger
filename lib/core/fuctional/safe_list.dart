import 'dart:collection';

class SafeList<T> extends ListBase<T> {
  List<T> innerList = new List();

  int get length => innerList.length;

  set length(int length) {
    innerList.length = length;
  }

  void operator []=(int index, T value) {
    innerList[index] = value;
  }

  @override
  T operator [](int index) {
    return index >= length || index < 0 ? null : innerList[index];
  }

  T before({T model, int index}) {
    if (index == null) index = indexOf(model);
    return index == 0 || index == -1 ? null : this[index - 1];
  }

  T after({T model, int index}) {
    if (index == null) index = indexOf(model);
    return index == this.length - 1 || index == -1 ? null : this[index + 1];
  }

  T get first => innerList[0];

  T get second => innerList[1];

  void addFirst(T element) {
    insert(0, element);
  }
}
