class Pair<LEFT, RIGHT> {
  Pair(this.left, this.right);

  final LEFT left;
  final RIGHT right;

  @override
  String toString() => 'Pair[$left, $right]';
}
