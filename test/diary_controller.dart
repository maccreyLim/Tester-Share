import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:navi_diary/controller/auth_controller.dart';
import 'package:navi_diary/model/diary_model.dart';

class DiaryController {
  AuthController authController = AuthController.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

//Create
//일기장 추가
  Future<void> addDiary(DiaryModel diary) async {
    try {
      // Firestore 인스턴스와 'diaries'라는 컬렉션을 사용
      DocumentReference diaryRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(authController.userData!['uid'])
          .collection('diaries')
          .add({
        'uid': diary.uid,
        'createdAt': diary.createdAt,
        'title': diary.title,
        'contents': diary.contents,
        'photoURL': diary.photoURL,
      });
      // 추가된 문서의 ID를 출력
      print('Added document with ID: ${diaryRef.id}');

      // 추가된 문서의 ID를 사용하여 'id' 필드 업데이트
      await diaryRef.set({'id': diaryRef.id}, SetOptions(merge: true));
    } catch (e) {
      // 에러 처리
      print('일기 추가 중 오류: $e');
    }
  }

  // 일기에 첨부된 이미지를 업로드하고 이미지 URL을 반환하는 함수
  Future<List<String>> uploadImages(List<String> imagePaths) async {
    List<String> imageUrls = [];

    try {
      // 현재 로그인한 사용자의 UID 가져오기
      String uid = authController.userData!['uid'] ?? 'unknown_user';
      for (String imagePath in imagePaths) {
        File compressedImage = await _compressImage(File(imagePath));
        // "images/UID/현재시간" 경로에 파일 업로드
        final ref = _storage.ref().child('images/$uid/${DateTime.now()}');
        await ref.putFile(compressedImage);
        final url = await ref.getDownloadURL();
        imageUrls.add(url);
      }
    } catch (e) {
      print('이미지 업로드 오류: $e');
    }

    return imageUrls;
  }

  // 이미지를 압축하고 압축된 이미지 파일을 반환하는 함수
  Future<File> _compressImage(File file) async {
    int quality = 50;
    List<int> compressedBytes = await FlutterImageCompress.compressWithList(
      file.readAsBytesSync(),
      quality: quality,
    );

    return File('${file.path}_compressed.jpg')
      ..writeAsBytesSync(compressedBytes);
  }

//Read
  // 사용자의 일기 목록을 가져오는 함수
  Future<List<DiaryModel>> getDiaries() async {
    try {
      if (authController.userData != null) {
        String userUid = authController.userData!['uid'];
        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .doc(userUid)
            .collection('diaries')
            .orderBy('createdAt',
                descending: true) // 'createdAt' 필드 기준으로 내림차순 정렬
            .get();

        return querySnapshot.docs
            .map(
                (doc) => DiaryModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
      } else {
        print('authController.userData is null');
        return [];
      }
    } catch (e) {
      print('일기 읽어오기 오류: $e');
      return [];
    }
  }

// 일기를 업데이트하는 함수
  Future<DiaryModel?> updateDiary(
    DiaryModel existingDiary,
    List<XFile?> newImages,
    List<String> deletedImageUrls,
    List<String> newImageUrls,
  ) async {
    try {
      String userUid = authController.userData!['uid'];

      // Firestore 문서 업데이트
      await _firestore
          .collection('users')
          .doc(userUid)
          .collection('diaries')
          .doc(existingDiary.id)
          .update({
        'updatedAt': DateTime.now(),
        'title': existingDiary.title,
        'contents': existingDiary.contents,
        'photoURL': newImageUrls,
      });

      // 여기에서 'photoURL'을 업데이트합니다.

      // existingDiary를 수정하지 않고 새로운 DiaryModel 객체를 반환
      return DiaryModel(
        id: existingDiary.id,
        title: existingDiary.title,
        contents: existingDiary.contents,
        // 나머지 필드들도 업데이트에 따라 적절히 추가
        // 예: photoURL, createdAt, updatedAt 등
        photoURL: newImageUrls,
        createdAt: existingDiary.createdAt,
        updatedAt: DateTime.now(),
        uid: existingDiary.uid,
      );
    } catch (e) {
      print('일기 업데이트 오류: $e');
      return null;
    }
  }

// 중복을 제거하는 함수
  List<String> removeDuplicates(List<String> list) {
    Set<String> uniqueSet = Set<String>.from(list);
    return uniqueSet.toList();
  }

  // 일기를 삭제하는 함수
  Future<void> deleteDiary(String diaryId) async {
    try {
      String userUid = authController.userData!['uid'];
      await _firestore
          .collection('users')
          .doc(userUid)
          .collection('diaries')
          .doc(diaryId)
          .delete();
    } catch (e) {
      print('일기 삭제 오류: $e');
    }
  }

  // 갤러리에서 이미지를 선택하고 이미지 리스트에 추가하는 함수
  Future<void> pickMultiImage(List<XFile?> images) async {
    List<XFile?> pickedImages = await ImagePicker().pickMultiImage();

    if (pickedImages.isNotEmpty) {
      images.addAll(pickedImages);
    }
  }

  // 이미지 리스트에서 특정 인덱스의 이미지를 삭제하는 함수
  void deleteImage(int index, List<XFile?> images) {
    images.removeAt(index);
  }

  // 일기에서 이미지를 삭제하는 함수
  Future<void> _deleteImage(DiaryModel diary, String imageUrl) async {
    try {
      await _firestore
          .collection('users')
          .doc(authController.userData!['uid'])
          .collection('diaries')
          .doc(diary.id)
          .update({
        'photoURL': FieldValue.arrayRemove([imageUrl]),
      });
      print('Firestore: 이미지가 성공적으로 삭제되었습니다');
    } catch (error) {
      print('Firestore: 이미지 삭제 중 오류 발생 - $error');
    }
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

// Firestore에서 이미지를 삭제하는 메서드
  Future<void> deleteImageFromFirestore(
      DiaryModel diary, String imageUrl) async {
    try {
      // Firestore 문서 삭제 코드
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authController.userData!['uid'])
          .collection('diaries')
          .doc(diary.id)
          .update({
        'photoURL': FieldValue.arrayRemove([imageUrl]),
      });

      print('Firestore에서 이미지가 성공적으로 삭제되었습니다.');
    } catch (error) {
      print('Firestore: 이미지 삭제 중 오류 발생 - $error');
    }
  }
}
