# Modern Academy Belur — School Portal (Flutter)

## Setup

### Prerequisites
- Flutter SDK ≥ 3.0.0
- Android Studio / VS Code with Flutter plugin
- Android SDK (API 21+)

### Run

```bash
cd modern_academy
flutter pub get
flutter run
```

### Build APK

```bash
flutter build apk --release
```
APK will be at `build/app/outputs/flutter-apk/app-release.apk`

---

## Demo Credentials

| Role    | ID    | Password   |
|---------|-------|------------|
| Student | S001  | pass123    |
| Teacher | T002  | teach123   |
| Parent  | P001  | parent123  |
| Admin   | ADM01 | admin123   |

> Teacher T002 is class teacher of **X-A** and has full CRUD on notices & homework.  
> Parent P001 has two wards (S001 — X-A, S004 — VIII-C) and can switch between them.

---

## Project Structure

```
lib/
  main.dart                  — App entry point
  theme/app_theme.dart       — Colors, fonts, Material theme
  models/models.dart         — Data models
  data/app_data.dart         — Static demo data (users, timetable, results)
  providers/app_provider.dart— ChangeNotifier state (auth, CRUD, ward)
  widgets/common_widgets.dart— Shared UI components
  screens/
    login/                   — Login screen (4 roles)
    shell_screen.dart        — Bottom nav + sub-tab shell
    home/dashboard_screen.dart
    profile/profile_screen.dart
    timetable/timetable_screen.dart
    notices/notices_screen.dart
    homework/homework_screen.dart
    results/results_screen.dart
    birthdays/birthdays_screen.dart
    admin/admin_screen.dart
```

## Navigation

Bottom tab bar selects a **section group**. Top tab strip selects a **sub-page** within that group.

| Role    | Bottom tabs                          |
|---------|--------------------------------------|
| Student | Home · Info · School · Birthday      |
| Teacher | Home · Info · Manage · Birthdays     |
| Parent  | Home · Info · School · Birthdays     |
| Admin   | Home · Users · Manage                |

## Replacing the Logo

Drop your school logo at `assets/logo.png` (512×512 recommended, circular crop looks best).

For the Android launcher icon, replace:
- `android/app/src/main/res/mipmap-mdpi/ic_launcher.png`   (48×48)
- `android/app/src/main/res/mipmap-hdpi/ic_launcher.png`   (72×72)
- `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png`  (96×96)
- `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png` (144×144)

Or use the `flutter_launcher_icons` package to generate them automatically.
