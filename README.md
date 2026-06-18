# Bhuwana Guard Mobile

Bhuwana Guard Mobile adalah aplikasi mobile berbasis Flutter yang dibuat untuk membantu proses pelaporan dan pemantauan data flora dan fauna. Aplikasi ini menyediakan fitur autentikasi pengguna, pembuatan laporan, riwayat laporan, detail laporan, emergency contact, serta pengelolaan profil pengguna.

Project ini dikembangkan sebagai bagian dari proses pembelajaran dan portfolio pengembangan aplikasi mobile, dengan fokus pada integrasi Flutter, Firebase, dan alur deployment testing menggunakan Firebase App Distribution.

## Fitur Utama

* Login dan register pengguna
* Verifikasi akun pengguna
* Pelaporan data flora dan fauna
* Riwayat laporan pengguna
* Detail laporan
* Emergency contact
* Pengelolaan profil pengguna
* Dukungan perubahan bahasa
* Integrasi Firebase Authentication
* Integrasi Firebase Firestore
* Deployment testing menggunakan Firebase App Distribution

## Tech Stack

* Flutter
* Dart
* Firebase Authentication
* Cloud Firestore
* Firebase Realtime Database
* Firebase Storage
* Firebase App Distribution
* Git & GitHub
* Figma

## Preview Aplikasi

Tambahkan screenshot aplikasi di bagian ini.

| Login                                | Home                               | History                                  | Profile                                  |
| ------------------------------------ | ---------------------------------- | ---------------------------------------- | ---------------------------------------- |
| ![Login](docs/screenshots/login.png) | ![Home](docs/screenshots/home.png) | ![History](docs/screenshots/history.png) | ![Profile](docs/screenshots/profile.png) |

## UI/UX Design

Desain aplikasi dibuat menggunakan Figma.

Figma Preview:
[Masukkan link Figma view-only di sini]

## Download APK

APK testing dapat diunduh melalui halaman GitHub Releases.

Download:
[Masukkan link GitHub Releases di sini]

Catatan: Aplikasi juga didistribusikan kepada tester menggunakan Firebase App Distribution.

## Cara Menjalankan Project

Clone repository:

```bash
git clone https://github.com/RidhoS22/Bhuwana_Guard_Mobile.git
```

Masuk ke folder project:

```bash
cd bhuwana_guard_mobile
```

Install dependencies:

```bash
flutter pub get
```

Jalankan aplikasi:

```bash
flutter run
```

Build APK release:

```bash
flutter build apk --release
```

## Struktur Folder

```text
lib/
├── features/
│   ├── auth/
│   ├── emergency_contact/
│   ├── history/
│   ├── home/
│   └── splash/
├── services/
├── firebase_options.dart
└── main.dart
```

## Deployment

Aplikasi ini menggunakan Firebase App Distribution untuk proses testing. APK hasil build diunggah ke Firebase, kemudian tester diundang melalui email untuk mengunduh dan menguji aplikasi di perangkat Android.

## Status Project

Project masih berada dalam tahap pengembangan dan testing. Beberapa fitur dapat terus diperbarui sesuai kebutuhan pengujian dan pengembangan lanjutan.

## Developer

Dikembangkan oleh:

* Ridho Syahfero
* Rajab Agustami Efendi
* Hengky Indrawan
