# Play Store görselleri

Bu klasör ücretsiz mağaza materyallerini tutar.

## Hazır dosyalar

| Dosya | Boyut / kullanım |
|-------|------------------|
| `feature_graphic.png` | Play Store özellik grafiği (yatay banner) |
| `../assets/branding/app_icon.png` | Uygulama ikonu kaynağı |
| `../assets/branding/splash.png` | Açılış ekranı kaynağı |

## Ekran görüntüsü nasıl alınır (ücretsiz)

1. Oyunu yatay telefonda veya Chrome’da çalıştır:
   ```powershell
   flutter run -d chrome --web-browser-flag "--window-size=960,540"
   ```
2. Şu ekranlardan screenshot al (en az 4 önerilir):
   - Açılış menüsü
   - Dünya seçimi
   - Bir seviye (gölge eşleştirme)
   - Tebrikler / seviye tamamlandı
3. Dosyaları buraya koy:
   - `store/screenshots/01_start.png`
   - `store/screenshots/02_worlds.png`
   - `store/screenshots/03_play.png`
   - `store/screenshots/04_complete.png`
4. Play Console’da telefon için **16:9** veya cihaz çözünürlüğüne uygun yükle.

## Not

İlerleme **cihazda** saklanır (`SharedPreferences`). Hesap / sunucu (backend) yok — çocuk oyunu için yeterli ve ücretsiz.
