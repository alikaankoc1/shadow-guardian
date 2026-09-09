import 'dart:math';

import 'package:flame/components.dart';

/// Phone/tablet landscape layout for shadow matching stages.
///
/// Dense exams (9–15) use multi-row grids so items stay readable
/// instead of one cramped horizontal strip.
class StageLayout {
  StageLayout({
    required this.viewport,
    required this.itemCount,
  }) {
    _compute();
  }

  final Vector2 viewport;
  final int itemCount;

  late final bool isPhone;
  late final bool isShortPhone;
  late final int targetRows;
  late final int objectRows;
  late final int columns;
  late final double padX;
  late final double hudReserve;
  late final double targetBandTop;
  late final double targetBandBottom;
  late final double objectBandTop;
  late final double objectBandBottom;
  late final double cellWidth;
  late final double maxSprite;

  void _compute() {
    final w = viewport.x;
    final h = viewport.y;
    isShortPhone = h < 400;
    isPhone = h < 520;

    // Row plan tuned for landscape phones first, then tablets.
    if (itemCount <= 6) {
      targetRows = 1;
      objectRows = 1;
      columns = itemCount;
    } else if (itemCount <= 9) {
      targetRows = isPhone ? 2 : 1;
      objectRows = isPhone ? 2 : 1;
      columns = isPhone ? ((itemCount + 1) ~/ 2) : itemCount;
    } else if (itemCount <= 12) {
      targetRows = 2;
      objectRows = 2;
      columns = (itemCount + 1) ~/ 2; // 6 for 12
    } else {
      // 13–15: three tidy rows on phone, two on large tablets if wide enough.
      final wideTablet = !isPhone && w >= 1000;
      targetRows = wideTablet ? 2 : 3;
      objectRows = wideTablet ? 2 : 3;
      columns = (itemCount + targetRows - 1) ~/ targetRows;
    }

    padX = max(
      isShortPhone
          ? (itemCount >= 12 ? 10.0 : 14.0)
          : (itemCount >= 12 ? 18.0 : 28.0),
      w * 0.02,
    );

    hudReserve = isShortPhone ? h * 0.15 : h * 0.13;
    final bottomSafe = isShortPhone ? h * 0.04 : h * 0.05;
    final midGap = isShortPhone ? h * 0.04 : h * 0.06;

    final usableTop = hudReserve;
    final usableBottom = h - bottomSafe;
    final mid = (usableTop + usableBottom) / 2;

    targetBandTop = usableTop;
    targetBandBottom = mid - midGap / 2;
    objectBandTop = mid + midGap / 2;
    objectBandBottom = usableBottom;

    final availableWidth = w - padX * 2;
    cellWidth = availableWidth / columns;

    final targetRowH = (targetBandBottom - targetBandTop) / targetRows;
    final objectRowH = (objectBandBottom - objectBandTop) / objectRows;
    final rowBudget = min(targetRowH, objectRowH);

    // Keep sprites large enough to tap/drag on phones.
    final phoneFloor = isShortPhone ? 46.0 : (isPhone ? 54.0 : 68.0);
    final phoneCeil = isShortPhone ? 78.0 : (isPhone ? 96.0 : 130.0);
    maxSprite = min(
      phoneCeil,
      max(phoneFloor, min(cellWidth * 0.86, rowBudget * 0.78)),
    );
  }

  Vector2 slotPosition({
    required int index,
    required bool forTargets,
  }) {
    final rows = forTargets ? targetRows : objectRows;
    final row = index ~/ columns;
    final col = index % columns;

    // Center leftover items on the last row (e.g. 9 → 5+4).
    final itemsBeforeRow = row * columns;
    final itemsInRow = min(columns, itemCount - itemsBeforeRow);
    final rowPad = (columns - itemsInRow) * cellWidth * 0.5;

    final x = padX + rowPad + cellWidth * (col + 0.5);
    final bandTop = forTargets ? targetBandTop : objectBandTop;
    final bandBottom = forTargets ? targetBandBottom : objectBandBottom;
    final rowH = (bandBottom - bandTop) / rows;
    final y = bandTop + rowH * (row + 0.5);
    return Vector2(x, y);
  }

  Vector2 fitSprite(Sprite sprite) {
    final imageSize = Vector2(
      sprite.image.width.toDouble(),
      sprite.image.height.toDouble(),
    );
    final scale = min(maxSprite / imageSize.x, maxSprite / imageSize.y);
    return imageSize * scale;
  }
}
