import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/app_colors.dart';
import '../data/tree_member_model.dart';
import 'tree_node_card.dart';

/// ---- layout constants ----
double _nodeW() => 150.w;
double _nodeH() => 90.h;
double _hGap() => 20.w;
double _vGap() => 56.h;
double _addBtnH() => 42.h;
double _lineStroke() => 1.8;

/// A positioned node used for both painting and placing widgets.
class _PlacedNode {
  _PlacedNode({
    required this.member,
    required this.x,
    required this.y,
    required this.w,
    required this.h,
    required this.isCurrentUser,
  });

  final TreeMemberModel member;
  final double x; // left
  final double y; // top
  final double w;
  final double h;
  final bool isCurrentUser;

  double get centerX => x + w / 2;
  double get bottom => y + h;
}

/// A line segment to draw.
class _LineSeg {
  const _LineSeg(this.from, this.to);
  final Offset from;
  final Offset to;
}

/// Recursively lays out the family tree with connecting lines.
class TreeLayoutWidget extends StatelessWidget {
  const TreeLayoutWidget({
    super.key,
    required this.roots,
    required this.currentUserId,
    this.onAddChild,
  });

  final List<TreeMemberModel> roots;
  final int? currentUserId;
  final void Function(TreeMemberModel parent)? onAddChild;

  @override
  Widget build(BuildContext context) {
    if (roots.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(40.w),
          child: Text(
            'لا توجد بيانات',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.neutral400,
            ),
          ),
        ),
      );
    }

    // 1. compute every node's position
    final placements = <_PlacedNode>[];
    final lines = <_LineSeg>[];
    double cursor = 0;
    for (int i = 0; i < roots.length; i++) {
      if (i > 0) cursor += _hGap();
      final w = _layoutSubtree(
        roots[i],
        cursor,
        0,
        placements,
        lines,
      );
      cursor += w;
    }

    // 2. total canvas size
    double totalW = 0;
    double totalH = 0;
    for (final p in placements) {
      totalW = math.max(totalW, p.x + p.w);
      totalH = math.max(totalH, p.bottom + (p.isCurrentUser ? _addBtnH() : 0));
    }
    totalW += 20.w;
    totalH += 20.h;

    return SizedBox(
      width: totalW,
      height: totalH,
      child: CustomPaint(
        painter: _TreeLinePainter(lines),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            for (final p in placements)
              Positioned(
                left: p.x,
                top: p.y,
                width: p.w,
                child: TreeNodeCard(
                  member: p.member,
                  isCurrentUser: p.isCurrentUser,
                  onAddChild: p.isCurrentUser
                      ? () => onAddChild?.call(p.member)
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Returns the width of the subtree rooted at [node], starting at ([startX], [startY]).
  /// Populates [outNodes] and [outLines].
  double _layoutSubtree(
    TreeMemberModel node,
    double startX,
    double startY,
    List<_PlacedNode> outNodes,
    List<_LineSeg> outLines,
  ) {
    final isMe = node.id == currentUserId;
    final cardH = _nodeH();
    final subtreeW = _subtreeWidth(node);

    // center the node card within its subtree width
    final nodeX = startX + (subtreeW - _nodeW()) / 2;

    outNodes.add(_PlacedNode(
      member: node,
      x: nodeX,
      y: startY,
      w: _nodeW(),
      h: cardH,
      isCurrentUser: isMe,
    ));

    if (node.children.isEmpty) return subtreeW;

    // y for children row
    final parentBottomY = startY + cardH + (isMe ? _addBtnH() : 0);
    final childrenTopY = parentBottomY + _vGap();
    final midY = parentBottomY + _vGap() / 2;

    // parent center  
    final parentCX = nodeX + _nodeW() / 2;

    // lay out children and collect their center-x
    final childCenters = <double>[];
    double cx = startX;
    final childrenTotalW = _childrenTotalWidth(node);
    // center children block within subtree
    cx = startX + (subtreeW - childrenTotalW) / 2;

    for (int i = 0; i < node.children.length; i++) {
      if (i > 0) cx += _hGap();
      final childW = _layoutSubtree(
        node.children[i],
        cx,
        childrenTopY,
        outNodes,
        outLines,
      );
      // child card center
      final childNodeX = cx + (childW - _nodeW()) / 2;
      final childCX = childNodeX + _nodeW() / 2;
      childCenters.add(childCX);
      cx += childW;
    }

    // --- draw connecting lines ---

    // 1. vertical from parent bottom to midY
    outLines.add(_LineSeg(
      Offset(parentCX, parentBottomY),
      Offset(parentCX, midY),
    ));

    // 2. horizontal bar across children (only if > 1 child)
    if (childCenters.length > 1) {
      final leftMost = childCenters.reduce(math.min);
      final rightMost = childCenters.reduce(math.max);
      outLines.add(_LineSeg(
        Offset(leftMost, midY),
        Offset(rightMost, midY),
      ));
    }

    // 3. vertical drop from midY to each child top
    for (final ccx in childCenters) {
      outLines.add(_LineSeg(
        Offset(ccx, midY),
        Offset(ccx, childrenTopY),
      ));
    }

    return subtreeW;
  }

  double _subtreeWidth(TreeMemberModel node) {
    if (node.children.isEmpty) return _nodeW();
    final cw = _childrenTotalWidth(node);
    return math.max(cw, _nodeW());
  }

  double _childrenTotalWidth(TreeMemberModel node) {
    if (node.children.isEmpty) return _nodeW();
    double total = 0;
    for (int i = 0; i < node.children.length; i++) {
      if (i > 0) total += _hGap();
      total += _subtreeWidth(node.children[i]);
    }
    return total;
  }
}

/// Paints the connecting lines between nodes.
class _TreeLinePainter extends CustomPainter {
  _TreeLinePainter(this.lines);

  final List<_LineSeg> lines;

  @override
  void paint(Canvas canvas, Size size) {
    if (lines.isEmpty) return;

    final paint = Paint()
      ..color = AppColors.neutral300
      ..strokeWidth = _lineStroke()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (final seg in lines) {
      canvas.drawLine(seg.from, seg.to, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TreeLinePainter old) =>
      old.lines.length != lines.length;
}
