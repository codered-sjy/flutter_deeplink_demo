# Flutter Deep Link Demo

A Flutter demo application showcasing deep linking implementation using **GoRouter** with typed routes and the **app_links** package.

## Features

- 🔗 **Deep Linking** - Handle custom URL schemes and HTTP/HTTPS links
- 🛣️ **GoRouter** - Type-safe navigation with `go_router` and `go_router_builder`
- 📱 **Cross-Platform** - Works on both Android and iOS
- 🔄 **Cold & Warm Start** - Supports deep links on app launch and while running
- 📝 **Query Parameters** - Pass data through URL query parameters

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── pages/
│   ├── home_page.dart        # Home screen
│   ├── profile_page.dart     # Profile screen (deep link target)
│   └── settings_page.dart    # Settings screen
└── router/
    ├── app_router.dart       # Router configuration & typed routes
    └── app_router.g.dart     # Generated route helpers
```

## Deep Link Configuration

### Supported URL Schemes

| Type | URL Format |
|------|------------|
| Custom Scheme | `deeplinkdemo://profile` |
| HTTP/HTTPS | `https://deeplinkdemo.example.com/profile` |

### Supported Routes

Currently, only the `/profile` route is enabled for deep linking with the following query parameters:

| Parameter | Description |
|-----------|-------------|
| `userId` | User identifier |
| `name` | User display name |
| `tab` | Active tab to display |

**Example URLs:**
```
deeplinkdemo://profile?userId=123&name=John&tab=activity
https://deeplinkdemo.example.com/profile?userId=123&name=John
```

## Getting Started

### Prerequisites

- Flutter SDK ^3.8.1
- Dart SDK ^3.8.1

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/codered-sjy/flutter_deeplink_demo.git
   cd flutter_deeplink_demo
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate route files (if needed):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Testing Deep Links

### Android

Using ADB:
```bash
# Custom URL scheme
adb shell am start -a android.intent.action.VIEW \
  -d "deeplinkdemo://profile?userId=123&name=John" \
  com.example.flutter_gorouter_app

# HTTPS link
adb shell am start -a android.intent.action.VIEW \
  -d "https://deeplinkdemo.example.com/profile?userId=456&name=Jane" \
  com.example.flutter_gorouter_app
```

### iOS

Using xcrun (Simulator):
```bash
xcrun simctl openurl booted "deeplinkdemo://profile?userId=123&name=John"
```

## Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| [go_router](https://pub.dev/packages/go_router) | ^17.0.0 | Declarative routing |
| [app_links](https://pub.dev/packages/app_links) | ^6.4.0 | Deep link handling |
| [go_router_builder](https://pub.dev/packages/go_router_builder) | ^4.1.2 | Type-safe route generation |
| [build_runner](https://pub.dev/packages/build_runner) | ^2.10.5 | Code generation |

## How It Works

### Router Initialization

The router is initialized in `main.dart` before running the app:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initRouter();
  runApp(const MyApp());
}
```

### Deep Link Handling

1. **Cold Start**: When the app launches from a deep link, `AppLinks.getInitialLink()` retrieves the URI
2. **Warm Start**: While the app is running, `AppLinks.uriLinkStream` listens for incoming links
3. **Route Validation**: Only allowed routes (currently `/profile`) are processed
4. **Navigation**: Valid deep links trigger `GoRouter.go()` to navigate to the target route

### Typed Routes

Routes are defined using `go_router_builder` annotations for type safety:

```dart
@TypedGoRoute<ProfileRoute>(path: '/profile')
class ProfileRoute extends GoRouteData with $ProfileRoute {
  final String? userId;
  final String? name;
  final String? tab;

  const ProfileRoute({this.userId, this.name, this.tab});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProfilePage(userId: userId, name: name, tab: tab);
  }
}
```

## Platform Configuration

### Android (`android/app/src/main/AndroidManifest.xml`)

```xml
<!-- Custom URL Scheme -->
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="deeplinkdemo" />
</intent-filter>

<!-- App Links (HTTP/HTTPS) -->
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="https" android:host="deeplinkdemo.example.com" />
    <data android:scheme="http" android:host="deeplinkdemo.example.com" />
</intent-filter>
```

### iOS

Configure URL schemes in `ios/Runner/Info.plist` or via Xcode:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>deeplinkdemo</string>
        </array>
    </dict>
</array>
```

For Universal Links, add an Associated Domains entitlement and host an `apple-app-site-association` file.

## License

This project is for demonstration purposes.
