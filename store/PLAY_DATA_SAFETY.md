# Play Console — Gizlilik URL, Data safety, Families

## 1) Gizlilik politikası URL’si (ücretsiz)

Kaynak dosya: `docs/privacy-policy.html`

**Hedef URL (GitHub Pages açıldıktan sonra):**

```text
https://alikaankoc1.github.io/shadow-guardian/privacy-policy.html
```

### İlk kez etkinleştirme

1. `docs/` klasörünü GitHub’a push et.
2. Repo → **Settings → Pages**
3. Source: **Deploy from a branch**
4. Branch: `main` · Folder: `/docs` → Save
5. 1–2 dakika sonra URL’yi tarayıcıda açıp kontrol et.
6. Play Console → Uygulama içeriği / Store listing → **Privacy policy** alanına bu URL’yi yapıştır.

---

## 2) Data safety (Veri güvenliği) — ne işaretlenir?

Bu uygulama **kişisel veri toplamıyor / paylaşmıyor**. Önerilen cevaplar:

| Soru | Cevap |
|------|--------|
| Veri toplanıyor mu? | **Hayır** (Does your app collect or share any of the required user data types? → **No**) |
| Uygulama tüm kullanıcılar için aynı mı? | Evet |
| Şifreleme / silme vb. | Veri toplanmadığı için genelde atlanır |

### Neden “Hayır”?

- Release manifest’te `INTERNET` yok
- Reklam / analitik / crash SDK yok
- Sadece cihazda: oyun ilerlemesi + ses tercihi (`SharedPreferences`)
- Bunlar Play’in “collected data” tanımına girmez (geliştiriciye iletilmiyor)

> Not: İleride reklam veya analitik eklersen formu **yeniden** doldurman gerekir.

---

## 3) Families / Designed for Families

Hedef: küçük çocuklar (yaklaşık 5–8 yaş) — gölge eşleştirme.

Play Console’da genelde:

1. **Target audience** → çocuk yaş gruplarını seç (ör. 5–8; gerekirse 9–12)
2. **News apps** → Hayır
3. **Families politika uyumu** beyanlarını onayla
4. Mağaza görselleri / açıklama: şiddet, korku, sohbet, UGC yok
5. Gizlilik URL’si zorunlu (yukarıdaki)

### Uygulama özellikleri (beyan için)

- Çevrimdışı oyun
- Hesap / sohbet / UGC yok
- Reklam yok
- Gerçek para / kumar yok
- Sosyal paylaşım yok

---

## 4) Mağaza kısa metin önerisi (TR)

**Kısa açıklama:**  
Sevimli gölge eşleştirme oyunu. Doğru gölgeyi bul, dünyaları tamamla!

**Gizlilik cümlesi (uzun açıklamaya eklenebilir):**  
İlerleme yalnızca cihazınızda saklanır. Kişisel veri toplanmaz. Gizlilik: [URL]

---

## Kontrol listesi

- [ ] `docs/` push edildi
- [ ] GitHub Pages `/docs` açık
- [ ] Privacy URL tarayıcıda açılıyor
- [ ] Play → Privacy policy URL kayıtlı
- [ ] Data safety → No data collected
- [ ] Target audience / Families soruları dolduruldu
