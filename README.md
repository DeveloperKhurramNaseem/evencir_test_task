# evencir_test

# Flutter Interview Test Task

## 📱 Project Overview

A Flutter application developed as part of the interview assessment task. The application demonstrates clean architecture, state management, API integration, and responsive UI implementation.

---

# 📦 Dependencies Used & Why

| Dependency        | Purpose                                                                                                                                     |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `flutter`         | Core framework used to build the cross-platform mobile application.                                                                         |
| `cupertino_icons` | Provides iOS-style icons for a consistent user interface.                                                                                   |
| `flutter_svg`     | Used for rendering SVG images and icons, allowing scalable and high-quality graphics without loss of quality across different screen sizes. |

---

# 🏗️ Project Structure

```text
lib/
│
├── models/
│
├── screens/
│   ├── home_screen/
│   │   ├── widgets/
│   │   └── home_screen.dart
│   │
│   ├── mood_screen/
│   │   ├── widgets/
│   │   └── mood_screen.dart
│   │
│   └── training_plan_screen/
│       ├── widgets/
│       └── training_plan_screen.dart
│
├── theme/
│
└── main.dart
```

## Folder Explanation

### `models/`

Contains all data models used throughout the application. These models represent the application's data structures and help organize and manage data efficiently.

### `screens/`

Contains all application screens. Each screen is organized into its own dedicated folder to maintain a clear and scalable structure.

#### `home_screen/`

Contains the Home Screen implementation and all widgets specific to the Home Screen.

#### `mood_screen/`

Contains the Mood Screen implementation and all widgets related to mood tracking and display.

#### `training_plan_screen/`

Contains the Training Plan Screen implementation and all widgets used for displaying training plans and workout-related information.

### `widgets/`

Each screen contains a dedicated `widgets` folder that stores reusable UI components used only within that screen. This approach keeps screen files clean, modular, and easy to maintain.

### `theme/`

Contains application-wide styling configurations, including colors, typography, and theme definitions to ensure a consistent user experience across the application.

### `main.dart`

The entry point of the application. It initializes the app, applies the theme configuration, and loads the initial screen.


---

# 📸 App Screenshots

### Home Screen

![Home Screen](screenshots/home.png)

### Home Screen Calender

![Home Screen Calender](screenshots/calender.png)

### Plan Screen

![Details Screen](screenshots/plan.png)

### Mood Screen

![Profile Screen](screenshots/mood.png)

### Screenshots Folder

[View All Screenshots](https://github.com/DeveloperKhurramNaseem/evencir_test_task/tree/main/screenshots)

---

# 🎥 App Demo Video

Watch a complete walkthrough of the application:

[Watch App Demo Video](https://drive.google.com/file/d/1lxvN0WpaZxP6OdI3F-59PLqO7RbMsVph/view?usp=sharing)

---

# 📲 Download APK

Download and install the latest APK:

[Download APK](https://github.com/DeveloperKhurramNaseem/evencir_test_task/releases/download/v1.0.0/app-release.apk)

---

# 🚀 Getting Started

## Prerequisites

* Flutter SDK
* Dart SDK
* Android Studio / VS Code
* Android Emulator or Physical Device

## Installation

```bash
git clone https://github.com/DeveloperKhurramNaseem/evencir_test_task.git

cd project-name

flutter pub get

flutter run
```

---

# 🛠️ Build APK

```bash
flutter build apk --release
```

Generated APK location:

```text
build/app/outputs/flutter-apk/app-release.apk
```

---

# 📧 Submission

GitHub Repository Link should be shared via email:

**[evencirhr@gmail.com](mailto:evencirhr@gmail.com)**

---

# 👨‍💻 Developer

M Khuram Naseem

Flutter Developer

