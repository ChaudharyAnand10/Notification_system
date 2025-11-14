import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// Global notification object
final FlutterLocalNotificationsPlugin localNotifications =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Timezone initialize
  tz.initializeTimeZones();

  // Windows initialization settings
  const initSettings = InitializationSettings(
    windows: WindowsInitializationSettings(
       appName: 'Windows Notification Demo',
    appUserModelId: 'com.example.new_app_window',
    guid: '12345678-1234-1234-1234-123456789abc',
      
    ),
  );

  // Initialize notifications
  await localNotifications.initialize(initSettings);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  // Simple notification
  Future<void> showSimpleNotification() async {
    const notifDetails = NotificationDetails(
      windows: WindowsNotificationDetails(),
    );

    await localNotifications.show(
      1,
      "New Message",
      "This is a Windows notification!",
      notifDetails,
    );
  }

  // Scheduled notification
  Future<void> showScheduledNotification() async {
    const notifDetails = NotificationDetails(
      windows: WindowsNotificationDetails(),
    );

    await localNotifications.zonedSchedule(
  2,
  "Scheduled Alert",
  "This notification came after 5 seconds",
  tz.TZDateTime.now(tz.local).add(Duration(seconds: 5)),
  notifDetails,

  // REQUIRED parameter (new in v17+)
  androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Windows Notification App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: showSimpleNotification,
              child: Text("Show Notification"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: showScheduledNotification,
              child: Text("Show Notification After 5 Seconds"),
            ),
          ],
        ),
      ),
    );
  }
}
