import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class SingleImageFirebaseController {
  //Property
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

// 갤러리에서 단일 이미지 선택
  Future<XFile?> pickSingleImage() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 300,
      maxWidth: 150,
    );
    return pickedFile;
  }

  // 선택한 단일 이미지를 Firebase Storage에 업로드
  Future<String?> uploadSingleImage(XFile? pickedImage) async {
    if (pickedImage != null) {
      try {
        // Firebase Storage 참조
        Reference ref = FirebaseStorage.instance.ref().child('boards_Images').child(
            '${DateTime.now().millisecondsSinceEpoch}_${pickedImage.path.split('/').last}');

        // 파일을 Firebase Storage에 업로드
        await ref.putFile(File(pickedImage.path));

        // 다운로드 URL 가져오기
        String downloadURL = await ref.getDownloadURL();
        return downloadURL;
      } catch (e) {
        print('단일 이미지 업로드 오류: $e');
        return null;
      }
    } else {
      return null;
    }
  }

  // Firebase Storage에서 선택한 단일 이미지 삭제
  Future<void> deleteSingleImage(XFile? pickedImage) async {
    if (pickedImage != null) {
      try {
        // Firebase Storage 참조
        Reference imageRef = FirebaseStorage.instance
            .ref()
            .child('boards_Images')
            .child(pickedImage.path.split('/').last);

        // Firebase Storage에서 이미지 삭제
        await imageRef.delete();
      } catch (e) {
        print('단일 이미지 삭제 오류: $e');
      }
    }
  }
}
