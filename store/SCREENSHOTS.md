# Play Store ekran görüntüleri (landscape)

Bu oyun **yalnız yatay**. Telefon + tablet için ayrı klasörler:

| Klasör | Play alanı | Hedef boyut | En az adet |
|--------|------------|-------------|------------|
| `screenshots/phone/` | Phone | **1920×1080** | 4 (min 2) |
| `screenshots/tablet/` | Tablet | **1920×1200** (veya 2560×1600) | 4 önerilir |

Kurallar: PNG/JPEG, **alpha yok**, her kenar 320–3840 px, uzun kenar ≤ 2× kısa kenar, dosya &lt; 8 MB.

## Hangi sahneler (aynı set, iki boyutta)

| Dosya | Sahne |
|-------|--------|
| `01_start.png` | Açılış menüsü |
| `02_worlds.png` | Dünya seçimi |
| `03_play.png` | Oyun (nesne + gölge) |
| `04_complete.png` | Tebrik ekranı |

## Yakalama (önerilen — Chrome önizleme)

`flutter screenshot` **Chrome’da çalışmaz**. Pencereyi doğru boyutta açıp Windows kırpma aracını kullan:

### 1) Telefon

```powershell
cd "C:\Users\Ali Kaan\Desktop\GitHub\shadow-guardian"
powershell -ExecutionPolicy Bypass -File store/capture_preview.ps1 phone
```

veya:

```powershell
flutter run -d chrome --web-browser-flag "--window-size=1920,1080"
```

1. Chrome penceresini tam gör (adres çubuğu mümkünse gizle / F11).
2. Sahneye gel.
3. **Win + Shift + S** → pencereyi seç.
4. Kaydet: `store/screenshots/phone/01_start.png` (sonra 02, 03, 04).

### 2) Tablet

Aynı akış, boyut **1920×1200**:

```powershell
powershell -ExecutionPolicy Bypass -File store/capture_preview.ps1 tablet
```

Kaydet: `store/screenshots/tablet/01_start.png` …

### İpuçları

- Sadece oyun alanını kırp (Windows görev çubuğu / Chrome UI olmasın).
- Ses butonu ve metinler okunaklı olsun.
- Telefon setini bitir → tablet için yeniden başlat → aynı 4 sahneyi tekrar çek.

## Android telefon / tablet (en iyisi)

Gerçek cihazda yatay `flutter run`, cihazın kendi ekran görüntüsü → aynı klasörlere kopyala.

## Play Console

Store listing → **Phone screenshots** + **Tablet screenshots** alanlarına yükle.
