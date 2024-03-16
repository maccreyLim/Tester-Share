import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/firebase_options.dart';
import 'package:tester_share_app/scr/login_screen_tr.dart';
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
  Future.delayed(const Duration(seconds: 3),
      FlutterLocalNotification.requestNotificationPermission());
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
        // startLocale: const Locale('en', 'US'),
        //startLocale을 지정하면 초기 언어가 설정한 언어로 변경됨
        //만일 이 설정을 하지 않으면 OS 언어를 따라 기본 언어가 설정됨
        // startLocale: const Locale('ko', 'KR'),
        // ('en', 'US')

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
      home: const LoginScreen(),
    );
  }
}
