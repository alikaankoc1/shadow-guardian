import 'package:flutter/material.dart';

import '../game/shadow_game.dart';
import '../theme/app_theme.dart';
import '../theme/landscape_ui.dart';
import '../widgets/playful_background.dart';

/// In-app privacy summary (offline — no INTERNET permission needed).
class PrivacyPolicyOverlay extends StatelessWidget {
  const PrivacyPolicyOverlay({super.key, required this.game});

  final ShadowGame game;

  static const publicUrl =
      'https://alikaankoc1.github.io/shadow-guardian/privacy-policy.html';

  @override
  Widget build(BuildContext context) {
    final scale = landscapeUiScaleOf(context);

    return PlayfulBackground(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16 * scale, 8 * scale, 16 * scale, 12 * scale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: game.hidePrivacy,
                    tooltip: 'Geri',
                    icon: Icon(Icons.arrow_back_rounded, size: 22 * scale),
                  ),
                  SizedBox(width: 10 * scale),
                  Expanded(
                    child: Text(
                      'Gizlilik Politikası',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 22 * scale,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10 * scale),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(20 * scale),
                    border: Border.all(
                      color: AppColors.coral.withValues(alpha: 0.28),
                      width: 2,
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16 * scale),
                    child: DefaultTextStyle(
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontFamily: 'Nunito',
                        color: AppColors.slate,
                        fontSize: 14 * scale,
                        fontWeight: FontWeight.w700,
                        height: 1.45,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sevimli Gölgeler',
                            style: TextStyle(
                              color: AppColors.navy,
                              fontSize: 18 * scale,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 8 * scale),
                          const Text(
                            'Bu oyun çevrimdışı çalışır. Kişisel veri toplamayız '
                            '(hesap, e-posta, konum, reklam kimliği yok).',
                          ),
                          SizedBox(height: 12 * scale),
                          Text(
                            'Cihazda saklananlar',
                            style: TextStyle(
                              color: AppColors.navy,
                              fontSize: 15 * scale,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 4 * scale),
                          const Text('• Oyun ilerlemesi (dünyalar / seviyeler)'),
                          const Text('• Ses açık / kapalı tercihi'),
                          SizedBox(height: 12 * scale),
                          const Text(
                            'Bu bilgiler telefonunuzda kalır; sunucuya gönderilmez. '
                            'Reklam veya analitik yoktur.',
                          ),
                          SizedBox(height: 12 * scale),
                          const Text(
                            'Verileri silmek için uygulamayı kaldırabilir veya '
                            'cihaz ayarlarından uygulama verilerini temizleyebilirsiniz.',
                          ),
                          SizedBox(height: 14 * scale),
                          Text(
                            'Tam metin (internet gerekir):',
                            style: TextStyle(
                              color: AppColors.navy,
                              fontWeight: FontWeight.w900,
                              fontSize: 13 * scale,
                            ),
                          ),
                          SizedBox(height: 4 * scale),
                          SelectableText(
                            publicUrl,
                            style: TextStyle(
                              color: AppColors.coral,
                              fontSize: 12.5 * scale,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
