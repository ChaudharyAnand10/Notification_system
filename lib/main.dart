import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:new_app_window/firebase_options.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  // Windows ke liye initialization settings
  const windowsInit = WindowsInitializationSettings(
  appName: 'Windows Notification Demo',
  appUserModelId: 'com.example.new_app_window',
  guid: '12345678-1234-1234-1234-123456789abc',
);

  // Overall initialization (sirf Windows)
  const initSettings = InitializationSettings(
    windows: windowsInit,
  );

  // Plugin initialize karo
  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (response) {
      debugPrint('Notification clicked: ${response.payload}');
    },
  );
}

Future<void> showNotification() async {
  // Notification ka design aur style
  const notificationDetails = NotificationDetails(
    windows: WindowsNotificationDetails(),
  );

  // Notification show karo
  await flutterLocalNotificationsPlugin.show(
    0, // unique id
    'Hello from Flutter 🚀', // title
    'This is a Windows-style notification', // message body
    notificationDetails,
    payload: 'sample_payload', // optional data
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  await initNotifications(); // app start me notification system initialize
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Windows Notification Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const NotificationPage(),
    );
  }
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Windows Notification Demo')),
      body: Center(
        child: ElevatedButton(
          onPressed: showNotification, // button click par notification show
          child: const Text('Show Notification'),
        ),
      ),
    );
  }
}
