# Sevimli Gölgeler

Çocuklar için yatay (landscape) gölge eşleştirme oyunu. Flutter + Flame.

**Play kimliği:** `com.alikaankoc.sevimligolgeler`  
**Sürüm:** `pubspec.yaml` → `1.0.0+2`

## Özellikler

- 9 tema dünyası + 3 sınav (Çıraklık / Kalfalık / Ustalık)
- Yerel kayıt (`SharedPreferences`) — hesap / internet yok
- Ses açık/kapalı, arka planda BGM durur
- Telefon + tablet landscape UI

## Çalıştırma

```powershell
cd "C:\Users\Ali Kaan\Desktop\GitHub\shadow-guardian"
flutter pub get
flutter run -d chrome --web-browser-flag "--window-size=1024,600"
```

Android release paket:

```powershell
flutter build appbundle
```

Çıktı: `build/app/outputs/bundle/release/app-release.aab`

## Mağaza / gizlilik

| Dosya | Konu |
|-------|------|
| [store/LISTING.md](store/LISTING.md) | Play mağaza metinleri |
| [store/PLAY_DATA_SAFETY.md](store/PLAY_DATA_SAFETY.md) | Data safety / Families |
| [store/SIGNING.md](store/SIGNING.md) | Keystore |
| [store/SCREENSHOTS.md](store/SCREENSHOTS.md) | Ekran görüntüleri |
| [docs/privacy-policy.html](docs/privacy-policy.html) | Gizlilik (GitHub Pages) |

## Lisans notları

`assets/licenses/` — Kenney CC0, Nunito OFL, Pixabay ses notları.
