# Play Store görselleri

Bu klasör **telefon / tablet** mağaza materyallerini tutar (oyun web için değil).

İmza / keystore: [SIGNING.md](SIGNING.md)

## Hazır dosyalar

| Dosya | Kullanım |
|-------|----------|
| `feature_graphic.png` | Play Store özellik grafiği |
| `../assets/branding/app_icon.png` | Uygulama ikonu |
| `../assets/branding/splash.png` | Açılış ekranı |

## Ekran görüntüsü (telefon / tablet)

1. Gerçek cihaz veya emülatörde yatay çalıştır:
   ```powershell
   flutter run
   ```
2. En az 4 ekran al: açılış, dünya seçimi, oyun (gölgeler), tebrikler
3. Kaydet: `store/screenshots/01_start.png` …

İlerleme telefonda yerel kaydedilir (`SharedPreferences`) — backend yok.
