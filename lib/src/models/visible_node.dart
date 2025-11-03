
class VisibleNode<T> {
  final T node;
  final int depth;
  final List<bool> ancestorsLastFlags;

  VisibleNode({
    required this.node,
    required this.depth,
    required this.ancestorsLastFlags,
  });
}
