import 'package:flutter/material.dart';

import '../services/sound_settings.dart';
import '../theme/app_theme.dart';
import '../theme/landscape_ui.dart';

/// Circular mute / unmute control used across every screen.
class SoundToggleButton extends StatefulWidget {
  const SoundToggleButton({super.key, this.scale});

  final double? scale;

  /// Approximate diameter used to reserve layout space under the button.
  static double reservedWidth(double scale) => 52 * scale;

  @override
  State<SoundToggleButton> createState() => _SoundToggleButtonState();
}

class _SoundToggleButtonState extends State<SoundToggleButton> {
  @override
  void initState() {
    super.initState();
    SoundSettings.instance.addListener(_onChanged);
  }

  @override
  void dispose() {
    SoundSettings.instance.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.scale ?? landscapeUiScaleOf(context);
    final pad = 10.0 * scale;
    final icon = 26.0 * scale;
    final enabled = SoundSettings.instance.enabled;

    return Semantics(
      button: true,
      label: enabled ? 'Sesi kapat' : 'Sesi aç',
      toggled: enabled,
      child: Material(
        color: AppColors.white.withValues(alpha: 0.92),
        shape: const CircleBorder(),
        elevation: 2,
        shadowColor: AppColors.navy.withValues(alpha: 0.12),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => SoundSettings.instance.toggle(),
          child: Padding(
            padding: EdgeInsets.all(pad),
            child: Icon(
              enabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
              size: icon,
              color: enabled ? AppColors.coral : AppColors.locked,
            ),
          ),
        ),
      ),
    );
  }
}

/// Top-right floating sound control for the whole app.
class SoundToggleLayer extends StatelessWidget {
  const SoundToggleLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final scale = landscapeUiScaleOf(context);
    final padding = MediaQuery.paddingOf(context);

    return Positioned(
      top: padding.top + 6 * scale,
      right: padding.right + 10 * scale,
      child: SoundToggleButton(scale: scale),
    );
  }
}
