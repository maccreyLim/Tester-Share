import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tester_share_app/widget/w.notification.dart';

class FcmManager {
  static void requestPermission() {
    //IOS Permission 대응
    FirebaseMessaging.instance.requestPermission();
  }

//FCM 초기화
  static void initialize() async {
    //FCM 토큰 가지고 오고 서버로 보내기
    final token = await FirebaseMessaging.instance.getToken();
    print('FCMtoken : $token');
    //Forground
    FirebaseMessaging.onMessage.listen((message) {
      final title = message.notification?.title;
      if (title == null) {
        return;
      }
      FlutterLocalNotification.showNotification(
          message.notification!.title, message.notification!.body);
    });

    //Background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final title = message.notification?.title;
      if (title == null) {
        return;
      }
      FlutterLocalNotification.showNotification(
          message.data['title'], message.data['body']);
    });

    // Not running -> initial lanch
    final firstMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (firstMessage == null) {
      return;
    }
    FlutterLocalNotification.showNotification(
        firstMessage.data['title'], firstMessage.data['body']);
  }
}
