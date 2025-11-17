# Windows Notification Flutter App

This project demonstrates how to create and manage **Windows desktop notifications** using Flutter and `flutter_local_notifications` package. It also shows how to fetch notifications from a server and display them periodically.

---

##  Features

* Show instant local notifications.
* Show scheduled notifications (after delay).
* Poll server every 5 seconds to fetch remote notifications.
* Show list of all triggered notifications.
* Simple and clean UI with TextField and navigation.

---

##  Project Structure

```
lib/
│ main.dart
│ listPage.dart
```

* **main.dart** → Contains UI and notification logic.
* **listPage.dart** → Displays all notifications stored in `myList`.

---

##  Dependencies Used

Add the following packages in `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_local_notifications: ^17.0.0
  http: ^1.2.0
  timezone: ^0.9.2
```

---

##  Initialization

Before running the app, timezones must be initialized:

```dart
tz.initializeTimeZones();
```

Also initialize notifications:

```dart
const initSettings = InitializationSettings(
  windows: WindowsInitializationSettings(
    appName: 'Windows Notification Demo',
    appUserModelId: 'com.example.new_app_window',
    guid: '12345678-1234-1234-1234-123456789abc',
  ),
);
await localNotifications.initialize(initSettings);
```

---

##  Showing Simple Notification

```dart
await localNotifications.show(
  id,
  data.text,
  "This is a Windows notification!",
  notifDetails,
);
```

After showing notification:

* Title is added to **myList**
* TextField is cleared

---

## ⏱ Scheduled Notification

Sends notification after 5 seconds:

```dart
await localNotifications.zonedSchedule(
  2,
  "Scheduled Alert",
  "This notification came after 5 seconds",
  tz.TZDateTime.now(tz.local).add(Duration(seconds: 5)),
  notifDetails,
  androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
);
```

---

##  Fetch Notifications From Server

App hits the API every **5 seconds**:

```dart
final url = Uri.parse("http://172.16.223.122:3000/notifications");
final response = await http.get(url);
```

If new notifications arrive:

* Show notification
* Add title to list

Timer setup:

```dart
Timer.periodic(Duration(seconds: 5), (timer) {
  checkForServerNotifications();
});
```

---

##  UI Overview

* TextField → Enter notification title
* Buttons:

  * Show Notification
  * Show Notification After 5 Seconds
  * View All Notifications

---

##  listPage.dart

Used to display notifications:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ShowNotification(myList: myList),
  ),
);
```

---

##  How To Run

1. Run `flutter pub get`
2. Ensure Windows desktop support is enabled:

   ```sh
   flutter config --enable-windows-desktop
   ```
3. Connect PC to Internet (for API polling)
4. Run app:

   ```sh
   flutter run -d windows
   ```

---
