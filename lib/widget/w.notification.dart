// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class FlutterLocalNotification {
//   FlutterLocalNotification._();

//   static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static init() async {
//     AndroidInitializationSettings androidInitializationSettings =
//         const AndroidInitializationSettings('mipmap/ic_launcher');

//     DarwinInitializationSettings iosInitializationSettings =
//         const DarwinInitializationSettings(
//       requestAlertPermission: false,
//       requestBadgePermission: false,
//       requestSoundPermission: false,
//     );

//     InitializationSettings initializationSettings = InitializationSettings(
//       android: androidInitializationSettings,
//       iOS: iosInitializationSettings,
//     );

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   static requestNotificationPermission() {
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//   }

//   static Future<void> showNotification(title, message) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails('channel id', 'channel name',
//             channelDescription: 'channel description',
//             importance: Importance.max,
//             priority: Priority.max,
//             showWhen: false);

//     const NotificationDetails notificationDetails = NotificationDetails(
//         android: androidNotificationDetails,
//         iOS: DarwinNotificationDetails(badgeNumber: 1));

//     await flutterLocalNotificationsPlugin.show(
//         0, title, message, notificationDetails);
//   }
// }

// 초기화
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class FlutterLocalNotification {
  FlutterLocalNotification._();

  static init() async {
    await AwesomeNotifications().initialize(
      null, // 앱 아이콘을 기본으로 사용
      [
        NotificationChannel(
          channelKey: 'channel id', // 기존 channel id 유지
          channelName: 'channel name', // 기존 channel name 유지
          channelDescription: 'channel description',
          defaultColor: const Color(0xFF9D50DD),
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          enableLights: true,
          enableVibration: true,
        ),
      ],
    );
  }

  static Future<void> requestNotificationPermission() async {
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications(
          permissions: [
            NotificationPermission.Alert,
            NotificationPermission.Sound,
            NotificationPermission.Badge,
          ],
        );
      }
    });
  }

  static Future<void> showNotification(String title, String message) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0, // 기존 notification id 유지
        channelKey: 'channel id',
        title: title,
        body: message,
        badge: 1,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  // 알림 상태 리스너 설정 (필요한 경우 사용)
  static void setListeners() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  /// 알림이 생성되었을 때
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // 알림 생성 시 필요한 처리
  }

  /// 알림이 표시되었을 때
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // 알림 표시 시 필요한 처리
  }

  /// 알림이 클릭되었을 때
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // 알림 클릭 시 필요한 처리
  }

  /// 알림이 삭제되었을 때
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // 알림 삭제 시 필요한 처리
  }
}
