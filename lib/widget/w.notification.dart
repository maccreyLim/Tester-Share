// notification.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ConcreteNotificationDetails extends NotificationDetails {
  ConcreteNotificationDetails({
    required AndroidNotificationDetails android,
  }) : super(android: android);
}

class CustomNotification {
  final NotificationDetails _details = ConcreteNotificationDetails(
    android: const AndroidNotificationDetails(
      'alarm 1',
      '1번 푸시',
      channelDescription: '푸시 알림 채널',
      importance: Importance.high,
      priority: Priority.high,
    ),
  );

  Future<void> showPushAlarm() async {
    FlutterLocalNotificationsPlugin _localNotification =
        FlutterLocalNotificationsPlugin();

// 신호를 받은 후 10초 후에 알림을 보내기 위해 Future.delayed 사용
    await Future.delayed(const Duration(seconds: 3), () async {
      await _localNotification.show(
        0,
        //메시지 title
        '신규프로젝트 알림',
        //메시지 Contents
        'NAVI Diary가 신규 프로젝트로 등록되었습니다.',
        _details,
        payload: 'deepLink',
      );
    });
  }
}
