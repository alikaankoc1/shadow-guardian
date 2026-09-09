import 'package:flutter/widgets.dart';

/// Shared UI scale for landscape phones → tablets (Play Store target).
///
/// Typical phone landscape heights: ~360–430. Tablets: ~600+.
double landscapeUiScale(double height) {
  if (height <= 340) return 0.68;
  if (height <= 360) return 0.74;
  if (height <= 400) return 0.82;
  if (height <= 450) return 0.88;
  if (height <= 520) return 0.94;
  if (height >= 700) return 1.08;
  return 1.0;
}

double landscapeUiScaleOf(BuildContext context) {
  return landscapeUiScale(MediaQuery.sizeOf(context).height);
}

bool isShortLandscape(double height) => height < 420;
