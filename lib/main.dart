import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/controller/message_firebase_controller.dart';
import 'package:tester_share_app/firebase_options.dart';
import 'package:tester_share_app/scr/first_screen.dart';
import 'package:tester_share_app/widget/w.notification.dart';

// 앱에서 지원하는 언어 리스트 변수
final supportedLocales = [
  const Locale('en', 'US'),
  const Locale('ko', 'KR'),
  const Locale('ja', 'JP')
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //애드몹 초기화
  MobileAds.instance.initialize();

  //세로방향으로 제한
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //파이어베이스 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) => Get.put(AuthController()));

  //Local Notification 초기화
  await FlutterLocalNotification.init();
  // 3초 후 권한 요청
  Future.delayed(
    const Duration(seconds: 3),
    FlutterLocalNotification.requestNotificationPermission,
  );
  FlutterLocalNotification.setListeners();

  // Hive 초기화
  await Hive.initFlutter();
  await MassageFirebaseController().initHive();
  // 필요한 박스 열기 (예: 'settings'라는 박스)
  await Hive.openBox('message');

  //다국어 초기화
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
        // 지원 언어 리스트
        supportedLocales: supportedLocales,
        //path: 언어 파일 경로
        path: 'assets/translations',
        //fallbackLocale supportedLocales에 설정한 언어가 없는 경우 설정되는 언어
        fallbackLocale: const Locale('en', 'US'),
        child: const MyApp()),
  );
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
      // 기본적으로 필요한 언어 설정
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const FirstScreen(),
    );
  }
}
