import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class MultiImageFirebaseController {
  final CollectionReference boardImagesCollection =
      FirebaseFirestore.instance.collection('boardImages');

  // ImagePicke

  /// ImagePicker를 사용하여 Xfile 리스트 반환
  Future<List<XFile?>> pickMultiImage(List<XFile?> pickedImages) async {
    List<XFile?> selectedImages = await ImagePicker().pickMultiImage(
      //이미지 화질 설정
      imageQuality: 100,
      maxHeight: 600,
      maxWidth: 300,
    );
    if (selectedImages.isNotEmpty) {
      pickedImages.addAll(selectedImages);
    }
    return pickedImages; // 수정: 이미지 목록을 반환
  }

  // 이미지 XFile리스트에서 특정 인덱스의 이미지를 삭제하는 메서드
  void deleteImageList(int index, List<XFile?> pickedImages) {
    pickedImages.removeAt(index);
  }

  // 특정 인덱스의 이미지를 Firebase Storage에서 삭제하는 메서드
  Future<List<XFile?>> deleteImageAtIndex(
      int index, List<XFile?> pickedImages) async {
    if (index >= 0 && index < pickedImages.length) {
      try {
        // Firebase Storage 참조
        Reference imageRef =
            FirebaseStorage.instance.ref().child(pickedImages[index]!.path);

        // Firebase Storage에서 이미지 삭제
        await imageRef.delete();

        // 리스트에서 이미지 제거
        pickedImages.removeAt(index);

        // 수정된 리스트 반환
        return pickedImages;
      } catch (e) {
        print('다중 이미지 삭제 오류: $e');
        // 오류가 발생한 경우 원래 리스트를 그대로 반환
        return pickedImages;
      }
    } else {
      // 인덱스가 범위를 벗어난 경우 원래 리스트를 그대로 반환
      return pickedImages;
    }
  }

  // Storage Upload

  /// 선택한 다중 이미지들을 Firebase Storage에 업로드하고 imageUrls를 반환하는 메서드
  Future<List<String>> uploadMultiImages(List<XFile?> pickedImages) async {
    List<String> imageUrls = [];

    for (XFile? imageFile in pickedImages) {
      if (imageFile != null) {
        try {
          // Firebase Storage 참조
          Reference ref = FirebaseStorage.instance
              .ref()
              .child('boards_Images')
              .child(
                  '${DateTime.now().millisecondsSinceEpoch}_App_${imageFile.path.split('/').last}');

          // 파일을 Firebase Storage에 업로드
          await ref.putFile(File(imageFile.path));

          // 다운로드 URL 가져오기
          String downloadURL = await ref.getDownloadURL();
          imageUrls.add(downloadURL);
        } catch (e) {
          print('다중 이미지 업로드 오류: $e');
        }
      }
    }

    return imageUrls;
  }

  // Storage Update
  /// 이미지 업로드 전에 기존 이미지를 삭제하고, 새로 선택한 이미지들을 업로드하여 새로운 URL 목록을 반환하는 메서드
  Future<List<String>> updateMultiImages(
      List<XFile?> pickedImages, List<String> existingImageUrls) async {
    try {
      // 이미지 업로드 전에 기존 이미지 삭제
      await deleteImagesUrlFromStorage(existingImageUrls);

      List<String> newImageUrls = [];

      for (XFile? imageFile in pickedImages) {
        if (imageFile != null) {
          try {
            // Firebase Storage 참조
            Reference ref = FirebaseStorage.instance
                .ref()
                .child('boards_Images')
                .child(
                    '${DateTime.now().millisecondsSinceEpoch}_App_${imageFile.path.split('/').last}');

            // 파일을 Firebase Storage에 업로드
            await ref.putFile(File(imageFile.path));

            // 다운로드 URL 가져오기
            String downloadURL = await ref.getDownloadURL();
            newImageUrls.add(downloadURL);
          } catch (e) {
            print('다중 이미지 업로드 오류: $e');
          }
        }
      }

      return newImageUrls;
    } catch (e) {
      print('이미지 업로드 및 삭제 중 오류 발생: $e');
      return [];
    }
  }

// Storage Delete
//리스트에 있는 주소로 모든 파일을 삭제
  Future<void> deleteImagesUrlFromStorage(List<String> appImagesUrls) async {
    try {
      for (String imageUrl in appImagesUrls) {
        try {
          // Firebase Storage에서 해당 이미지의 참조를 얻어옴
          Reference imageRef = FirebaseStorage.instance.refFromURL(imageUrl);

          // 이미지가 존재하는지 확인
          await imageRef.getDownloadURL();

          // Firebase Storage에서 이미지 삭제
          await imageRef.delete();
          print('이미지 삭제 성공: $imageUrl');
        } catch (e) {
          // 이미지가 존재하지 않는 경우
          print('이미지 삭제 실패 - 이미지가 존재하지 않습니다: $imageUrl');
        }
      }
    } catch (e) {
      print('Firebase Storage에서 이미지 삭제 오류: $e');
    }
  }

// List에서 이미지 수정삭제
  Future<List<String>> deleteUpdateImage(
    int index,
    List<String> existingImageUrls,
  ) async {
    try {
      // list 복사본 생성
      List<String> updatedImageUrls = List.from(existingImageUrls);

      // index가 existingImageUrls 리스트의 범위 내에 있는지 확인
      if (index >= 0 && index < existingImageUrls.length) {
        // Firebase Storage 참조
        Reference imageRef =
            FirebaseStorage.instance.refFromURL(existingImageUrls[index]);

        // 이미지를 삭제하려고 시도
        await imageRef.delete();

        // 리스트에서 이미지 제거
        updatedImageUrls.removeAt(index);
        print("삭제 후 리스트: $updatedImageUrls");

        // 수정된 리스트 반환 (이미 삭제된 이미지는 제외)
        return updatedImageUrls;
      } else {
        print('인덱스가 existingImageUrls 리스트의 범위를 벗어납니다.');
        // 오류가 발생한 경우 원래 리스트를 그대로 반환
        return existingImageUrls;
      }
    } catch (error) {
      // 이미지를 삭제하는 도중 오류 발생
      print('이미지 삭제 오류: $error');

      if (error is FirebaseException && error.code == 'object-not-found') {
        // 이미지가 존재하지 않을 경우 오류가 발생하지만 무시하고 계속 진행
        print('삭제하려는 이미지가 Firebase Storage에 존재하지 않습니다.');
      } else {
        // 다른 오류에 대해서는 그대로 throw
        rethrow;
      }

      // 오류가 발생한 경우 원래 리스트를 그대로 반환
      return existingImageUrls;
    }
  }
}
