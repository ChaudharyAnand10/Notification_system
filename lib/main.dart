import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:new_app_window/listPage.dart';
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

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage(), debugShowCheckedModeBanner: false);
  }
}

class HomePage extends StatelessWidget {
  final List<String> myList = [];
  final int id = DateTime.now().millisecondsSinceEpoch;
  // Simple notification
  Future<void> showSimpleNotification(TextEditingController data) async {
    const notifDetails = NotificationDetails(
      windows: WindowsNotificationDetails(),
    );

    try {
      await localNotifications.show(
        id,
        data.text,
        "This is a Windows notification!",
        notifDetails,
      );
      myList.add(data.text);
      data.clear();
    } catch (e) {
      print("Failed to send notification: $e");
    }
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
    final TextEditingController data = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: Text("Windows Notification App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: data,
              decoration: InputDecoration(
                hintText: "enter title",
                fillColor: Colors.grey.shade200,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () => showSimpleNotification(data),
              child: Text("Show Notification"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: showScheduledNotification,
              child: Text("Show Notification After 5 Seconds"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowNotification(myList: myList),
                  ),
                );
              },
              child: Text("view all notification"),
            ),
          ],
        ),
      ),
    );
  }
}
