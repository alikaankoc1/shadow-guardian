# Cihaz duman testi (release / AAB)

Bağlı Android cihaz yoksa bu listeyi fiziksel telefonda / emülatörde işaretle.

```powershell
flutter build appbundle
# isteğe bağlı APK:
flutter build apk --release
flutter install --release
```

## Kontrol listesi

- [ ] Uygulama adı: **Sevimli Gölgeler**
- [ ] Açılış menüsü + ses düğmesi
- [ ] **Devam Et** kayıtlı seviyeyi açıyor (veya ilk kez **Oyuna Başla** → dünyalar)
- [ ] Dünya seç → seviye → sürükle-bırak eşleşme
- [ ] Doğru / yanlış ses (ses açıkken)
- [ ] Uygulamayı Home’a al → **BGM duruyor**; geri dön → menüde devam
- [ ] Dünya bitince kutlamada **Sonraki: …** görünüyor
- [ ] Ustalık bitince **Gölge Ustası** + konfeti
- [ ] Gizlilik ekranı (açılış sol alt)
- [ ] Yatay kilit (portrait’e dönmüyor)
- [ ] İlerleme kapat-aç sonrası duruyor

AAB yolu: `build/app/outputs/bundle/release/app-release.aab`

> Not: `flutter build appbundle` bazen “failed to strip debug symbols” ile exit 1 verebilir; AAB yine de `outputs/bundle/release/` altında oluşmuş olabilir. Dosya boyutunu kontrol et (~50MB+).
