import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SingleImageFirebaseController {
  //Property
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

// 갤러리에서 단일 이미지 선택
  Future<XFile?> pickSingleImage() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 150,
      maxWidth: 150,
    );
    return pickedFile;
  }

  // 선택한 단일 이미지를 Firebase Storage에 업로드
  Future<String?> uploadSingleImage(XFile? pickedImage) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false, // 사용자가 다이얼로그 외부를 탭하여 닫을 수 없도록 설정
    );
    String now =
        '${DateTime.now().year}.${DateTime.now().month}.${DateTime.now().day}';
    //기존 이미지 삭제 2/22추가
    // deleteSingleImage(pickedImage);

    if (pickedImage != null) {
      try {
        // Firebase Storage 참조
        Reference ref = FirebaseStorage.instance.ref().child('boards_Images').child(
            '$now _${DateTime.now().hour}:${DateTime.now().minute}_Icon_${pickedImage.path.split('/').last}');
        // 파일을 Firebase Storage에 업로드
        await ref.putFile(File(pickedImage.path));

        // 다운로드 URL 가져오기
        String downloadURL = await ref.getDownloadURL();
        return downloadURL;
      } catch (e) {
        print('단일 이미지 업로드 오류: $e');
        return null;
      } finally {
        // 데이터 추가가 완료된 후에 로딩 인디케이터를 숨깁니다.
        Get.back();
      }
    } else {
      return null;
    }
  }

  // Firebase Storage에서 선택한 단일 이미지 삭제
  Future<void> deleteSingleImage(XFile? pickedImage) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false, // 사용자가 다이얼로그 외부를 탭하여 닫을 수 없도록 설정
    );
    String now =
        '${DateTime.now().year}.${DateTime.now().month}.${DateTime.now().day}';
    if (pickedImage != null) {
      try {
        // Firebase Storage 참조
        Reference imageRef = FirebaseStorage.instance
            .ref()
            .child('boards_Images')
            .child(
                '$now _${DateTime.now().hour}:${DateTime.now().minute}_Icon_${pickedImage.path.split('/').last}');
        // Firebase Storage에서 이미지 삭제
        await imageRef.delete();
      } catch (e) {
        print('단일 이미지 삭제 오류: $e');
      } finally {
        // 데이터 추가가 완료된 후에 로딩 인디케이터를 숨깁니다.
        Get.back();
      }
    }
  }

// Url로 Firebase Storage에서 선택한 단일 이미지 삭제
  Future<void> deleteImageUrl(String iconImageUrl) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false, // 사용자가 다이얼로그 외부를 탭하여 닫을 수 없도록 설정
    );
    try {
      // Firebase Storage에서 이미지 삭제
      await FirebaseStorage.instance.refFromURL(iconImageUrl).delete();
    } catch (e) {
      print('이미지 삭제 오류: $e');
      // 예외 처리를 위한 추가적인 동작 수행
    } finally {
      // 데이터 추가가 완료된 후에 로딩 인디케이터를 숨깁니다.
      Get.back();
    }
  }
}
