import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class MultiImageFirebaseController {
  final CollectionReference boardImagesCollection =
      FirebaseFirestore.instance.collection('boardImages');

  // ImagePicke

  /// ImagePicker를 사용하여 갤러리에서 다중 이미지 선택하고 이미지 XFile리스트에 추가하는 메서드
  Future<List<XFile?>> pickMultiImage(List<XFile?> pickedImages) async {
    List<XFile?> newPickedImages = await ImagePicker().pickMultiImage(
      imageQuality: 50,
      maxHeight: 300,
      maxWidth: 150,
    );

    if (newPickedImages.isNotEmpty) {
      pickedImages.addAll(newPickedImages);
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

  // Storage Create

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
                  '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}');

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
                    '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}');

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

  /// 이미지를 imageUrls 리스트로 Firebase Storage에서 이미지 파일을 삭제하는 메서드
  Future<void> deleteImagesUrlFromStorage(List<String> appImagesUrls) async {
    try {
      for (String imageUrl in appImagesUrls) {
        // 이미지 URL에서 gs:// 형태의 Bucket 이름과 Path 추출
        RegExp regex = RegExp(r'gs://([^/]+)/(.*?)\?.*');
        Match? match = regex.firstMatch(imageUrl);

        if (match != null && match.groupCount == 2) {
          String bucket = match.group(1)!;
          String path = match.group(2)!;

          // Firebase Storage에서 해당 이미지의 참조를 얻어옴
          Reference imageRef = FirebaseStorage.instance.ref().child(bucket)
            ..child('boards_Images').child(path);

          // Firebase Storage에서 이미지 삭제
          await imageRef.delete();
        } else {
          print('이미지 URL 형식이 잘못되었습니다: $imageUrl');
        }
      }
    } catch (e) {
      print('Firebase Storage에서 이미지 삭제 오류: $e');
    }
  }

// 이미지 수정삭제
  Future<List<String>> deleteUpdateImage(
      int index, List<String> existingImageUrls) async {
    try {
      // index가 existingImageUrls 리스트의 범위 내에 있는지 확인
      if (index >= 0 && index < existingImageUrls.length) {
        // Firebase Storage 참조
        Reference imageRef =
            FirebaseStorage.instance.refFromURL(existingImageUrls[index]);

        print("삭제 주소: $imageRef");

        // Firebase Storage에서 이미지 삭제
        await imageRef.delete();

        // 리스트에서 이미지 제거
        existingImageUrls.removeAt(index);

        // 수정된 리스트 반환 (이미 삭제된 이미지는 제외)
        return existingImageUrls;
      } else {
        print('인덱스가 existingImageUrls 리스트의 범위를 벗어납니다.');
        // 오류가 발생한 경우 원래 리스트를 그대로 반환
        return existingImageUrls;
      }
    } catch (error) {
      print('이미지 삭제 오류: $error');
      // 오류가 발생한 경우 원래 리스트를 그대로 반환
      return existingImageUrls;
    }
  }
}
