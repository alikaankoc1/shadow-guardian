import 'package:flutter/material.dart';

import 'sound_toggle_button.dart';

class PlayScreenHeader extends StatelessWidget {
  const PlayScreenHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onBack,
    required this.scale,
    this.trailing,
    this.leading,
  });

  final String title;
  final String subtitle;
  final VoidCallback onBack;
  final double scale;
  final Widget? trailing;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filledTonal(
          onPressed: onBack,
          tooltip: 'Geri',
          icon: Icon(Icons.arrow_back_rounded, size: 22 * scale),
        ),
        SizedBox(width: 10 * scale),
        if (leading != null) ...[
          leading!,
          SizedBox(width: 10 * scale),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 24 * scale,
                ),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 14 * scale,
                ),
              ),
            ],
          ),
        ),
        ?trailing,
        // Room for the global top-right sound toggle.
        SizedBox(width: SoundToggleButton.reservedWidth(scale)),
      ],
    );
  }
}
