# Android release imza (keystore)

Bu adımlar **ücretsiz**. Google Play Developer hesabı ($25) ayrı ve senin tarafında.

## Kilitli kimlik (Play’de değişmez)

| Alan | Değer |
|------|--------|
| applicationId | `com.alikaankoc.sevimligolgeler` |
| version (pubspec) | `1.0.0+2` → isim `1.0.0`, kod `2` |

İlk yayın sonrası **applicationId değiştirilmez**.

## Bu projede hazır olanlar

| Dosya | Durum | Git |
|-------|--------|-----|
| `android/app/upload-keystore.jks` | Oluşturuldu | **YOK** (gitignore) |
| `android/key.properties` | Oluşturuldu | **YOK** (gitignore) |
| `android/app/build.gradle.kts` | Release imzaya bağlı | commit edilir |

## Senin yapman gereken (çok önemli)

1. `android/key.properties` ve `android/app/upload-keystore.jks` dosyalarını **USB / bulut / şifreli yedek** olarak sakla.
2. Şifreleri kaybetme — aynı uygulama güncellemesi için bu anahtar şart.
3. Bu dosyaları **asla GitHub’a push etme** (zaten ignore’lu).

## Play hesabı açtıktan sonra

```powershell
cd "C:\Users\Ali Kaan\Desktop\GitHub\shadow-guardian"
flutter build appbundle
```

Çıktı: `build/app/outputs/bundle/release/app-release.aab` → Play Console’a yüklenir.

## Not

- İlk yüklemede Play Console’da **Play App Signing** önerilir (Google da bir anahtar tutar).
- Keystore kaybolursa aynı `applicationId` ile güncelleme yapılamaz.
