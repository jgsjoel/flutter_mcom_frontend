# mcommerce (flutter_mcom_frontend)

A Flutter front-end for a mobile commerce app. It includes maps, payments, realtime messaging, Firebase backend integration and a few native components (there are C/C++ and CMake artifacts for desktop/native targets).

This README gives a practical setup guide and lists the feature dependencies you need to enable before running the app.

---

## Quick clone & run

Clone the repo

```bash
git clone https://github.com/jgsjoel/flutter_mcom_frontend.git
cd flutter_mcom_frontend
```

Install Dart / Flutter

- Use a Flutter SDK compatible with Dart SDK >= 3.5.4 (the project declares `sdk: ^3.5.4`).

Add environment file

- Create a `.env` file at the project root (the repo expects one; it's listed in assets). See "Environment variables" below for keys to add.
- Do not commit `.env` to version control.

Get packages

```bash
flutter pub get
```

Platform-specific steps

- Android: open `android/` in Android Studio, ensure Kotlin/Gradle toolchain is up to date, add API keys and Firebase config files as described below.
- iOS: open `ios/Runner.xcworkspace` in Xcode, ensure proper signing, add Google/Stripe/Firebase keys and plist files.
- Web / Desktop: some native code (C/C++/CMake) and platform folders exist — follow usual Flutter desktop setup if you target those platforms.

Run

```bash
flutter run
```

---

## Main features and the packages they depend on

Below are the main app features and the packages or services you must configure for them to work properly.

- Networking / API  
  - Package: `dio`  
  - Notes: set your backend base URL in the `.env` or wherever the app expects it.

- Authentication / Secure storage / JWT handling  
  - Packages: `flutter_secure_storage`, `jwt_decoder`  
  - Notes: `flutter_secure_storage` requires platform setup for iOS (Keychain) and Android (encrypted shared prefs).

- UI / State management / Animations  
  - Packages: `provider`, `carousel_slider`, `curved_navigation_bar`, `shimmer`, `google_fonts`, `cupertino_icons`

- Maps & Location  
  - Packages: `google_maps_flutter`, `latlong2`, `location`, `geocoding`, `permission_handler`  
  - Notes:
    - Add Google Maps API key to `AndroidManifest.xml` and AppDelegate (iOS) or use the platform guide for your Flutter Maps package version.
    - Request and handle runtime location permissions (`permission_handler` & `location`).
    - Enable Maps API and Geocoding in the Google Cloud Console.

- Image picking & uploads  
  - Packages: `image_picker`, `firebase_storage`  
  - Notes:
    - On iOS, add `NSPhotoLibraryUsageDescription` / `NSCameraUsageDescription` keys.
    - Firebase Storage requires the Firebase SDK config (see Firebase section).

- Realtime / Messaging (STOMP)  
  - Package: `stomp_dart_client`  
  - Notes: configure the STOMP broker URL in environment/backend config.

- Firebase (core, Firestore, Storage)  
  - Packages: `firebase_core`, `cloud_firestore`, `firebase_storage`  
  - Notes:
    - The repo contains `firebase.json` — you'll still need to add platform-specific Firebase config files:
      - Android: `google-services.json`
      - iOS: `GoogleService-Info.plist`
    - Initialize Firebase in app startup (the code should already import `firebase_core`).

- Payments (Stripe)  
  - Package: `flutter_stripe`  
  - Notes:
    - Add publishable and secret keys in `.env` or in your backend.
    - Follow package setup for Android (manifest) and iOS (plist and URL schemes). Some features require additional native configuration.

---

## Environment variables

- Package: `flutter_dotenv`  
- Notes: ensures sensitive keys (backend URL, Stripe publishable key, Firebase keys if used dynamically) are not committed.

Environment variables (`.env`) — example

Create a `.env` file at project root with keys the app expects (example keys below; confirm exact names in code):

```env
API_BASE_URL=https://api.example.com
FIREBASE_API_KEY=...
FIREBASE_AUTH_DOMAIN=...
FIREBASE_PROJECT_ID=...
FIREBASE_STORAGE_BUCKET=...
FIREBASE_MESSAGING_SENDER_ID=...
FIREBASE_APP_ID=...
GOOGLE_MAPS_API_KEY=...
STRIPE_PUBLISHABLE_KEY=pk_test_...
STOMP_URL=wss://broker.example.com/stomp
```

Do not commit `.env` to version control.

---

## Firebase setup

1. Create a Firebase project.
2. Add Android and iOS apps within the Firebase console.
3. Download and place the platform config files:
   - Android: put `google-services.json` into `android/app/`.
   - iOS: put `GoogleService-Info.plist` into `ios/Runner/` and add it to the Xcode project.
4. Enable Firestore and Storage from the Firebase console.
5. If you use Firebase Authentication, enable the providers needed.

---

## Google Maps & Location setup

1. Enable Maps SDK for Android and iOS in Google Cloud Console.
2. Restrict API key appropriately (application restrictions + API restrictions).
3. Add API key to:
   - Android: `android/app/src/main/AndroidManifest.xml` (meta-data entry)
   - iOS: AppDelegate or `Info.plist` depending on the Flutter Maps package version.

Ensure your runtime permission handling is implemented (see `permission_handler` and `location`).

---

## Stripe setup

1. Create a Stripe account and copy the publishable key to `.env`.
2. Server-side: create endpoints to create `PaymentIntents` / `SetupIntents` using your Stripe secret key.
3. iOS/Android: follow `flutter_stripe` installation guides (URL schemes, manifest/plist changes).

---

