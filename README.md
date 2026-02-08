# Stopwatch - Interval Trainer

Bir HIIT (High-Intensity Interval Training) ve egzersiz aralık antrenmanı uygulaması. Flutter ile geliştirilmiş, Android ve Web platformlarında çalışır.

## Özellikler

- **Esnek Egzersiz Yapılandırması**
  - Egzersiz sayısı (minimum 2)
  - Set sayısı (minimum 2)
  - Egzersiz süresi (minimum 3 saniye)
  - Egzersizler arası dinlenme süresi (minimum 3 saniye)
  - Setler arası dinlenme süresi (minimum 3 saniye)

- **Otomatik Zamanlama ve Faz Yönetimi**
  - Hazırlık fazı: Başlamadan önce 5 saniyelik geri sayım
  - Egzersiz fazı: Belirlenen egzersiz süresinde sayım
  - Egzersizler arası dinlenme: Belirtilen ara süresi
  - Setler arası dinlenme: Setler arasında uzun mola
  - Otomatik faz geçişleri

- **Sesli Bildirimler**
  - Hazırlık aşamasında kalan son 3 saniyede kısa bip (100ms)
  - Faz sona erdiğinde uzun bip (300ms)
  - Android: Yerel ToneGenerator kullanır
  - Web: Programmatik WAV ses üretimi (base64 veri URL'si ile)

- **Kolay Kullanım Arayüzü**
  - İnput formu: Tüm parametreler tek ekranda
  - Zamanlayıcı ekranı: Mevcut durumu gösterir
  - Kontrol tuşları: Başlat, Durdur, Sıfırla

- **Çoklu Platform Desteği**
  - Android emülatörü ve cihazı
  - Chrome Web
  - Diğer Flutter destekli platformları

## Başlangıç

### Gereksinimler

- Flutter SDK (3.10+)
- Dart SDK (3.0+)
- Android SDK (API Level 21+) - Android için
- Chrome - Web için

### Yükleme ve Çalıştırma

1. Projeyi klonla

   ```bash
   https://github.com/debugistan/stopwatch_app.git
   cd stopwatch_app
   ```

2. Bağımlılıkları yükle

   ```bash
   flutter pub get
   ```

3. Uygulamayı çalıştır

   ```bash
   # Android emülatörü
   flutter run -d emulator-5554

   # Web (Chrome)
   flutter run -d chrome
   ```

## Proje Yapısı

- `lib/main.dart` - Ana uygulama, UI ekranları ve zamanlayıcı mantığı
- `android/app/src/main/kotlin/com/example/my_app/MainActivity.kt` - Android yerel ses implementasyonu
- `pubspec.yaml` - Bağımlılıklar ve proje yapılandırması

## Teknik Detaylar

### Ses Sistemi

- **Android**: `android.media.ToneGenerator` (MethodChannel üzerinden)
  - TONE_PROP_BEEP tonu kullanır
  - Handler.postDelayed() ile süre kontrollü çalışır

- **Web**: Programatik WAV üretimi
  - Sine dalga (750Hz kısa, 800-600Hz melanji uzun)
  - PCM audio verisi
  - Base64 data URL olarak oynatılır

### Durum Yönetimi

- StatefulWidget + Timer.periodic() ile 1 saniyelik sayım
- Phase enum'u ile fazları takibi
- Set/egzersiz sayaçları ile ilerleme takibi

## Lisans

MIT
