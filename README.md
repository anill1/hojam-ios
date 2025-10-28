# UniApp iOS Client

SwiftUI tabanlı UniApp istemcisi, kampüs içi eşleşme ve sohbet deneyimini Tinder benzeri bir akışla sunar. Proje iOS 17+ hedefler ve MVVM + UseCase/Repository mimarisiyle modüler şekilde organize edilmiştir.

## Özellikler
- Onboarding ve SSO mock akışı (Apple / Google / .edu magic link doğrulaması)
- Kart tabanlı swipe deneyimi, filtreler ve limit göstergeleri
- Eşleşme modal animasyonu, matches listesi ve mock sohbet ekranı
- Profil düzenleme, anonim mod, fotoğraf seçimi ve paywall bağlantısı
- StoreKit 2 ile mock abonelik ve Boost satın alma akışı
- Çok dillilik (TR/EN), erişilebilirlik etiketleri ve Dynamic Type uyumu
- SwiftLint / SwiftFormat, Unit & UI testleri ve GitHub Actions CI

## Klasör Yapısı
```
App/                # App entry point ve root navigasyon
Core/               # Design System, Networking, Storage, Analytics, Utilities
Features/           # Özelleşmiş modüller (Auth, Swipe, Match, Chat, Profile, Settings, Paywall)
Resources/          # Lokalizasyonlar, varlıklar
Tests/              # Unit ve UI testleri
UniApp.xcodeproj/   # Xcode projesi
```

## Kurulum
1. `brew bundle` ile SwiftLint/SwiftFormat gibi araçları kurun veya manuel olarak yükleyin.
2. `open UniApp.xcodeproj` ile projeyi Xcode’da açın.
3. Çalıştırma hedefi olarak iOS 17+ bir simülatör seçin (iPhone SE (3. nesil), iPhone 13 mini, iPhone 15, iPhone 15 Pro Max önerilir).
4. `Command + R` ile uygulamayı başlatın.

### Xcode 16.1 projeyi açarken "parse error" uyarısı
Xcode 16.1’de görülen “The project is damaged and cannot be opened due to a parse error” mesajı iki temel sebepten kaynaklanabilir:

1. **Proje sürüm bilgileri 16 serisiyle uyumlu değil.** `UniApp.xcodeproj/project.pbxproj` içinde `objectVersion = 61;` ve `compatibilityVersion = "Xcode 16.0";` satırlarının yer aldığını doğrulayın. Eğer farklı değerler görüyorsanız, Xcode 16.1 projeyi açmayı reddeder.
2. **Build ayarlarında makro değerleri tırnaksız bırakılmış.** `PRODUCT_NAME = "$(TARGET_NAME)";` ve `BUNDLE_LOADER = "$(TEST_HOST)";` gibi makro içeren alanların çift tırnakla çevrildiğinden emin olun. Tırnaklar eksikse OpenStep plist söz dizimi bozulur ve Xcode projeyi “damaged” olarak işaretler.

Depodaki proje dosyası bu iki koşulu da sağlayacak şekilde güncellendi. Hâlâ aynı uyarıyı alırsanız:

1. `UniApp.xcodeproj/project.xcworkspace/contents.xcworkspacedata` dosyasında `location = "self:UniApp.xcodeproj"` referansının yer aldığını kontrol edin.
2. Xcode’u kapatıp Derived Data klasörünü temizleyin (`Window → Projects → Delete Derived Data`).
3. Projeyi tekrar `open UniApp.xcodeproj` komutuyla açın.

Bu kontroller, Xcode 16.1’in proje dosyasını hatasız parse etmesi için yeterlidir; ayrıca Xcode 16.1’den daha yeni (ör. Xcode 16.2/17) bir sürüme yükseltmenize gerek yoktur.

### Xcode ↔︎ GitHub kimlik doğrulaması
Xcode’un GitHub depolarına erişirken “Credentials rejected” hatası vermesi genellikle Git’in kimlik bilgisi yardımcı programının eksik olmasından veya GitHub hesabı için kişisel erişim jetonu (PAT) kullanılmamasından kaynaklanır. macOS tarafında aşağıdaki adımları izleyerek bağlantıyı onarın:

1. Terminal’de Git’in macOS anahtar zinciri yardımcı programını kullandığından emin olun:
   ```bash
   git config --global credential.helper osxkeychain
   ```
2. GitHub’da **Developer settings → Personal access tokens → Tokens (classic)** bölümünden en az `repo` yetkisine sahip bir PAT oluşturun. Xcode’un Accounts paneline giriş yaparken bu jetonu şifre olarak kullanın.
3. Eğer daha önce başarısız denemeler yaptıysanız `Keychain Access` uygulamasında `github.com` girdilerini silip tekrar deneyin.

Bu ayarlardan sonra Xcode’un `Source Control → Sign in to GitHub…` akışında kullanıcı adı olarak GitHub hesabınızı, şifre olarak oluşturduğunuz PAT’i girerek depoya erişebilirsiniz.

## Testler
- Unit testleri: `xcodebuild -scheme UniApp -destination 'platform=iOS Simulator,name=iPhone 15' test`
- UI testleri: Aynı komutla otomatik olarak tetiklenir.

## CI
`.github/workflows/ios.yml` GitHub Actions iş akışı, SwiftLint/SwiftFormat kontrolleri ve `xcodebuild` testlerini çalıştırır.

## Yerelleştirme ve Erişilebilirlik
- `Resources/Localization` altındaki `Localizable.strings` dosyaları TR ve EN desteği sağlar.
- Görünümler erişilebilirlik etiketleri, Dynamic Type ve yüksek kontrast için optimize edilmiştir.

## Gelecek Adımlar
- Gerçek backend ve doğrulama servisleri bağlandığında `APIClient` ve `StoreKitClient` implementasyonları kolayca değiştirilebilir.
- App Privacy Manifest detayları backend entegrasyonu sonrası eklenmelidir.
