import 'package:flutter/material.dart';

// https://github.com/flutter/flutter/issues/63946#issuecomment-1000442747
// - By: https://github.com/PaulBout1

class AllwaysScrollableFixedPositionScrollPhysics extends ScrollPhysics {
  const AllwaysScrollableFixedPositionScrollPhysics({ScrollPhysics? parent})
    : super(parent: parent);

  @override
  AllwaysScrollableFixedPositionScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return AllwaysScrollableFixedPositionScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double adjustPositionForNewDimensions({
    required ScrollMetrics oldPosition,
    required ScrollMetrics newPosition,
    required bool isScrolling,
    required double velocity,
  }) {
    if (newPosition.extentBefore == 0) {
      return super.adjustPositionForNewDimensions(
        oldPosition: oldPosition,
        newPosition: newPosition,
        isScrolling: isScrolling,
        velocity: velocity,
      );
    }
    return newPosition.maxScrollExtent - oldPosition.extentAfter;
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) => true;
}