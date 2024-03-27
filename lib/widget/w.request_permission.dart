import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tester_share_app/widget/w.show_toast.dart';

class RequestPermission extends StatelessWidget {
  const RequestPermission({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkIfPermissionGranted(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 비동기 작업이 아직 완료되지 않은 경우 로딩 표시
          return CircularProgressIndicator();
        } else {
          if (snapshot.data!) {
            showToast("권한 허용이 되었습니다.", 1);
            return Container(); // 비동기 작업이 완료되고 허용된 경우 아무것도 반환하지 않음
          } else {
            showPermissionDialog();
            return Container(); // 비동기 작업이 완료되고 허용되지 않은 경우 아무것도 반환하지 않음
          }
        }
      },
    );
  }

  Future<bool> checkIfPermissionGranted() async {
    Map<Permission, PermissionStatus> statuses = await [
      //허용할 퍼미션을 기입
      Permission.camera,
      Permission.notification
    ].request();
    //permission이 되었다는 전제하에 변수 선언
    bool permitted = true;

    //permission check
    statuses.forEach((permission, status) {
      if (!status.isGranted) permitted = false;
    });

    return permitted;
  }

  void showPermissionDialog() {
    Get.defaultDialog(
      title: "Permission Required",
      middleText: "앱에서 필요한 권한을 허용해주세요.",
      confirm: TextButton(
        onPressed: () {
          AppSettings.openAppSettings();
          Get.back(); // 다이얼로그 닫기
        },
        child: Text("Settings"),
      ),
      cancel: TextButton(
        onPressed: () {
          Get.back(); // 다이얼로그 닫기
        },
        child: Text("Cancel"),
      ),
    );
  }
}
