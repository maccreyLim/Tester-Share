import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/firebase_options.dart';
import 'package:tester_share_app/scr/login_screen.dart';
import 'package:tester_share_app/widget/w.notification.dart';

late FlutterLocalNotificationsPlugin _localNotification;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) => Get.put(AuthController()));
  //Local Notification 초기화
  // await _initLocalNotification();
  FlutterLocalNotification.init();
  // 3초 후 권한 요청
  Future.delayed(const Duration(seconds: 3),
      FlutterLocalNotification.requestNotificationPermission());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Testera Share',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
