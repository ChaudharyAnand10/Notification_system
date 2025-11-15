import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:new_app_window/listPage.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


final FlutterLocalNotificationsPlugin localNotifications =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  const initSettings = InitializationSettings(
    windows: WindowsInitializationSettings(
      appName: 'Windows Notification Demo',
      appUserModelId: 'com.example.new_app_window',
      guid: '12345678-1234-1234-1234-123456789abc',
    ),
  );

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

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> myList = [];
  

  final int id = DateTime.now().millisecondsSinceEpoch;

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

  Future<void> checkForServerNotifications() async {
    final url = Uri.parse("http://172.16.223.122:3000/notifications");

    final response = await http.get(url);
    print(response.statusCode);
    print("RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      List result = jsonDecode(response.body);
          

           if (result.isEmpty) {
              print("No new notifications from server");
            return;
           }

      for (var item in result) {
        await localNotifications.show(
          DateTime.now().millisecondsSinceEpoch,
          item["title"], 
          item["body"], 
          const NotificationDetails(windows: WindowsNotificationDetails()),
        );

        myList.add(item["title"]);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (timer) {
      checkForServerNotifications();
    });
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
              // onPressed: () => showSimpleNotification(data),
              onPressed: () => checkForServerNotifications(),
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
