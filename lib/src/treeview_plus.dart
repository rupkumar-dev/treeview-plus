import 'package:flutter/material.dart';
import 'package:treeview_plus/src/models/visible_node.dart';
import 'package:treeview_plus/src/painter/tree_painter.dart';

enum NodeIndicatorType {
  plusMinus, // + / -
  arrow, // default rotating arrow
  // add more in future if needed
}

class TreeviewPlus<T> extends StatefulWidget {
  final T root;
  //final String Function(T node) getId;
  // final List<T> Function(T node) getChildren;
  final Widget Function(BuildContext context, T node, bool isSelected)
  nodeBuilder;

  /// Optional: externally controlled selected node
  final String? selectedNodeId;

  /// Optional: enable internal highlighting
  final bool? isSelected;

  /// Predefined indicator for expand/collapse
  final NodeIndicatorType indicatorType;

  /// Called when a node is tapped
  final ValueChanged<String>? onTap;

  final double indent;
  final double treeHeight;

  const TreeviewPlus({
    super.key,
    required this.root,
    //required this.getId,
    // required this.getChildren,
    required this.nodeBuilder,
    this.selectedNodeId,
    this.isSelected,
    this.onTap,
    this.indent = 24.0,
    this.treeHeight = 36.0,
    this.indicatorType = NodeIndicatorType.plusMinus,
  });

  @override
  State<TreeviewPlus<T>> createState() => _TreeviewPlusState<T>();
}

class _TreeviewPlusState<T> extends State<TreeviewPlus<T>> {
  final Set<String> _expandedNodes = {};
  final Set<String> _previousNodes = {};
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();

  String? _selectedNodeId;
  // new code added maybe bugs infutre

  String getId(T node) {
    try {
      return (node as dynamic).id as String;
    } catch (e) {
      throw Exception('CustomTreeView expects node to have an "id" property');
    }
  }

  List<T> getChildren(T node) {
    final children = <T>[];
    try {
      final dynamic dyn = node;

      if (dyn.child != null) children.add(dyn.child as T);
      if (dyn.children != null && dyn.children is List) {
        children.addAll(List<T>.from(dyn.children));
      }
    } catch (e) {
      throw Exception(
        'CustomTreeView expects node to have either "child" or "children" property',
      );
    }
    return children;
  }

  @override
  void initState() {
    super.initState();
    final rootId = getId(widget.root);
    _expandedNodes.add(rootId); // expand root by default
    _selectedNodeId = rootId; // select root by default
    _previousNodes.add(rootId);
   // setState(() {}); // <-- add this

  
  }

  @override
  void didUpdateWidget(covariant TreeviewPlus<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final currentNodes = _collectNodeIds(widget.root);

    // Automatically expand new nodes
    for (final nodeId in currentNodes) {
      if (!_previousNodes.contains(nodeId)) {
        _expandedNodes.add(nodeId);
      }
    }

    _previousNodes
      ..clear()
      ..addAll(currentNodes);
  }

  Set<String> _collectNodeIds(T node) {
    final ids = <String>{};
    final nodeId = getId(node);
    ids.add(nodeId);
    final children = getChildren(node);
    for (final child in children) {
      ids.addAll(_collectNodeIds(child));
    }
    return ids;
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  int _getMaxDepth(T node, [int depth = 0]) {
    final children = getChildren(node);
    if (children.isEmpty) return depth;
    int maxDepth = depth;
    for (final child in children) {
      final childDepth = _getMaxDepth(child, depth + 1);
      if (childDepth > maxDepth) maxDepth = childDepth;
    }
    return maxDepth;
  }

  @override
  Widget build(BuildContext context) {
    final nodes = _buildVisibleNodes(widget.root, 0, []);
    final maxDepth = _getMaxDepth(widget.root);

    return Scrollbar(
      thumbVisibility: true, // always show horizontal scrollbar
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        primary: true,
        child: SizedBox(
          width: 280 * (maxDepth + 1),
          child: ListView.builder(
            itemCount: nodes.length,
            itemBuilder: (context, index) {
              final visibleNode = nodes[index];
              final node = visibleNode.node;
              final nodeId = getId(node);
              final isSelected = widget.selectedNodeId != null
                  ? widget.selectedNodeId == nodeId
                  : _selectedNodeId == nodeId;




              final children = getChildren(node);
              final hasChildren = children.isNotEmpty;
              final isExpanded = _expandedNodes.contains(nodeId);

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: visibleNode.depth * widget.indent,
                    height: widget.treeHeight,
                    child: CustomPaint(
                      painter: TreePainter<T>(
                        node: visibleNode,
                        spacing: widget.indent,
                        height: widget.treeHeight,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),

                  if (hasChildren)
                    IconButton(
                      iconSize: 16,
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      icon: _buildIndicatorIcon(isExpanded),
                      onPressed: () {
                        setState(() {
                          if (isExpanded) {
                            _expandedNodes.remove(nodeId);
                          } else {
                            _expandedNodes.add(nodeId);
                          }
                        });
                      },
                    )
                  else
                    const SizedBox(width: 24),

                  SizedBox(
                    width: 220,

                    child: InkWell(
                      onTap: () {
                        widget.onTap?.call(nodeId);
                        if (widget.onTap == null) _selectedNodeId = nodeId;
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        color: widget.isSelected == true
                            ? (isSelected
                                  ? Colors.blue.shade50
                                  : Colors.transparent)
                            : Colors.transparent,

                        alignment: Alignment.centerLeft,
                        child: widget.nodeBuilder(context, node, isSelected),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );

    // return ListView.builder(
    //   itemCount: nodes.length,
    //   itemBuilder: (context, index) {
    //     final visibleNode = nodes[index];
    //     final node = visibleNode.node;
    //     final nodeId = widget.getId(node);

    //     // Determine if node is selected
    //     final isSelected = widget.selectedNodeId != null
    //         ? widget.selectedNodeId == nodeId
    //         : _selectedNodeId == nodeId;

    //     final children = widget.getChildren(node);
    //     final hasChildren = children.isNotEmpty;
    //     final isExpanded = _expandedNodes.contains(nodeId);

    //     return Expanded(
    //       child: Row(
    //         children: [
    //           // Connector lines
    //           SizedBox(
    //             width: visibleNode.depth * widget.indent,
    //             height: widget.treeHeight,
    //             child: CustomPaint(
    //               painter: TreePainter<T>(
    //                 node: visibleNode,
    //                 spacing: widget.indent,
    //                 height: widget.treeHeight,
    //                 color: Colors.grey.shade400,
    //               ),
    //             ),
    //           ),
    //           if (hasChildren)
    //             IconButton(
    //               iconSize: 16,
    //               padding: EdgeInsets.zero,
    //               visualDensity: VisualDensity.compact,
    //               icon: _buildIndicatorIcon(isExpanded),
    //               onPressed: () {
    //                 setState(() {
    //                   if (isExpanded) {
    //                     _expandedNodes.remove(nodeId);
    //                   } else {
    //                     _expandedNodes.add(nodeId);
    //                   }
    //                 });
    //               },
    //             )
    //           else
    //             const SizedBox(width: 24),

    //           Expanded(
    //             child: InkWell(
    //               onTap: () {
    //                 widget.onTap?.call(nodeId);
    //                 if (widget.onTap == null) {
    //                   setState(() => _selectedNodeId = nodeId);
    //                 }
    //               },
    //               child: AnimatedContainer(
    //                 margin: EdgeInsets.only(right: 10),
    //                 duration: const Duration(milliseconds: 150),
    //                 color: widget.isSelected == true
    //                     ? (isSelected
    //                           ? Colors.blue.shade50
    //                           : Colors.transparent)
    //                     : Colors.transparent,
    //                 padding: EdgeInsets.only(right: 6),

    //                 alignment: Alignment.centerLeft,
    //                 child: widget.nodeBuilder(context, node, isSelected),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    // );
  }

  Widget _buildIndicatorIcon(bool isExpanded) {
    switch (widget.indicatorType) {
      case NodeIndicatorType.plusMinus:
        return Icon(
          color: Colors.grey,
          isExpanded ? Icons.remove_circle_outline : Icons.add_circle_outline,
          size: 16,
        );
      case NodeIndicatorType.arrow:
        return AnimatedRotation(
          turns: isExpanded ? 0.25 : 0,
          duration: const Duration(milliseconds: 200),
          child: const Icon(Icons.arrow_right),
        );
    }
  }

  List<VisibleNode<T>> _buildVisibleNodes(
    T node,
    int depth,
    List<bool> ancestorsLastFlags,
  ) {
    final nodes = <VisibleNode<T>>[];
    final nodeId = getId(node);
    final children = getChildren(node);
    final isExpanded = _expandedNodes.contains(nodeId);

    nodes.add(
      VisibleNode(
        node: node,
        depth: depth,
        ancestorsLastFlags: List.from(ancestorsLastFlags),
      ),
    );

    if (isExpanded && children.isNotEmpty) {
      for (int i = 0; i < children.length; i++) {
        final child = children[i];
        final isLast = i == children.length - 1;
        final newFlags = [...ancestorsLastFlags, isLast];
        nodes.addAll(_buildVisibleNodes(child, depth + 1, newFlags));
      }
    }

    return nodes;
  }
}
