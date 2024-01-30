import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tester_share_app/model/board_firebase_model.dart';

class ImageFirebaseController {
  // Firebase Storage 인스턴스
  final FirebaseStorage _storage = FirebaseStorage.instance;
  //Firebase Firestore  인스턴스
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 갤러리에서 이미지를 선택하고 이미지 리스트에 추가하는 함수
  Future<void> pickMultiImage(List<XFile?> images) async {
    List<XFile?> pickedImages = await ImagePicker().pickMultiImage(
      imageQuality: 50,
      maxHeight: 300,
      maxWidth: 150,
    );

    if (pickedImages.isNotEmpty) {
      images.addAll(pickedImages);
    }
  }

  // 보드에서 이미지를 삭제하는 함수
  Future<void> _deleteImage(BoardFirebaseModel board, String imageUrl) async {
    try {
      await _firestore.collection('boradImages').doc(board.docid).update({
        'imageUrl': FieldValue.arrayRemove([imageUrl]),
      });
      print('Firestore: 이미지가 성공적으로 삭제되었습니다');
    } catch (error) {
      print('Firestore: 이미지 삭제 중 오류 발생 - $error');
    }
  }

  // 이미지 리스트에서 특정 인덱스의 이미지를 삭제하는 함수
  void deleteImage(int index, List<XFile?> images) {
    images.removeAt(index);
  }

  // 이미지를 Firebase Storage에서 삭제하는 메서드
  Future<void> deleteImageFromStorage(String imageUrl) async {
    try {
      // 이미지 URL에서 gs:// 형태의 Bucket 이름과 Path 추출
      RegExp regex = RegExp(r'gs://([^/]+)/(.*?)\?.*');
      Match? match = regex.firstMatch(imageUrl);

      if (match != null && match.groupCount == 2) {
        String bucket = match.group(1)!;
        String path = match.group(2)!;

        // Firebase Storage에서 해당 이미지의 참조를 얻어옴
        Reference imageRef =
            FirebaseStorage.instance.ref().child(bucket).child(path);

        // Firebase Storage에서 이미지 삭제
        await imageRef.delete();
      } else {
        print('이미지 URL 형식이 잘못되었습니다.');
      }
    } catch (e) {
      print('Firebase Storage에서 이미지 삭제 오류: $e');
    }
  }

// 멀티 이미지 업로드 함수
  Future<List<String>> uploadImages(List<XFile?> images) async {
    List<String> imageUrls = [];

    // 이미지 리스트를 순회하며 업로드
    for (XFile? imageFile in images) {
      if (imageFile != null) {
        File file = File(imageFile.path);

        // Firebase Storage에 업로드할 위치에 대한 참조 생성
        Reference ref = _storage.ref().child('boards_Images').child(
            '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}');

        // 파일을 Firebase Storage에 업로드
        await ref.putFile(File(imageFile.path));

        // 다운로드 URL 가져오기
        String downloadURL = await ref.getDownloadURL();
        imageUrls.add(downloadURL);
      }
    }

    return imageUrls;
  }

  // 단일 이미지 업로드 함수
  Future<String?> uploadImage(XFile? pickedImage) async {
    if (pickedImage != null) {
      File file = File(pickedImage.path);

      try {
        // Firebase Storage에 업로드할 위치에 대한 참조 생성
        Reference ref = _storage.ref().child('boards_Images').child(
            '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}');

        // 파일을 Firebase Storage에 업로드
        await ref.putFile(File(pickedImage.path));

        // 다운로드 URL 가져오기
        String downloadURL = await ref.getDownloadURL();
        return downloadURL;
      } catch (e) {
        print('이미지 업로드 중 오류 발생: $e');
        return null;
      }
    } else {
      return null;
    }
  }
}
