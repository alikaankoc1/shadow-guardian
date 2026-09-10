# Play Store görselleri

Bu klasör **telefon / tablet** mağaza materyallerini tutar (oyun web için değil).

İmza / keystore: [SIGNING.md](SIGNING.md)  
Gizlilik / Data safety / Families: [PLAY_DATA_SAFETY.md](PLAY_DATA_SAFETY.md)  
Ekran görüntüleri: [SCREENSHOTS.md](SCREENSHOTS.md)  
Mağaza metinleri: [LISTING.md](LISTING.md)  
Duman testi: [SMOKE_TEST.md](SMOKE_TEST.md)

## Hazır dosyalar

| Dosya | Kullanım |
|-------|----------|
| `feature_graphic.png` | Play Store özellik grafiği |
| `../assets/branding/app_icon.png` | Uygulama ikonu |
| `../assets/branding/splash.png` | Açılış ekranı |

## Ekran görüntüsü

- Telefon: `screenshots/phone/` → **1920×1080** landscape (en az 4)
- Tablet: `screenshots/tablet/` → **1920×1200** landscape (en az 4)

Hızlı önizleme:

```powershell
powershell -ExecutionPolicy Bypass -File store/capture_preview.ps1 phone
powershell -ExecutionPolicy Bypass -File store/capture_preview.ps1 tablet
```

Detay: [SCREENSHOTS.md](SCREENSHOTS.md)

İlerleme telefonda yerel kaydedilir (`SharedPreferences`) — backend yok.
