import 'package:flutter/material.dart';
import 'package:treeview_plus/src/models/visible_node.dart';

class TreePainter<T> extends CustomPainter {
  final VisibleNode<T> node;
  final double spacing;
  final double height;
  final Color color;

  TreePainter({
    required this.node,
    this.spacing = 16,
    this.height = 24,
    this.color = Colors.grey,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    final yMiddle = height / 2;

    for (int i = 0; i < node.ancestorsLastFlags.length; i++) {
      final x = i * spacing + spacing / 1.5;
      final isLast = node.ancestorsLastFlags[i];
// draw vertical line for all ancestors that are not last

      if (!isLast) {
        canvas.drawLine(Offset(x, 0), Offset(x, height), paint);
      }
         // draw connector
      // center - line  horizontal
      if (i == node.ancestorsLastFlags.length - 1) {
        canvas.drawLine(
          Offset(x, yMiddle),
          Offset(x + spacing / 1.7, yMiddle),

          paint,
        );
           // // vertical down if has children midle
        // if (node.node.children.isNotEmpty) {
        //   canvas.drawLine(
        //     Offset(x + spacing / 0, yMiddle),
        //     Offset(x + spacing / 0, rowHeight),
        //     paint,
        //   );
        // }
        // vertical line for this node (so next row connects) last line
        canvas.drawLine(Offset(x, 0), Offset(x, yMiddle), paint);
      }
    }
  }
 
  @override
  bool shouldRepaint(covariant TreePainter oldDelegate) => true;
}

