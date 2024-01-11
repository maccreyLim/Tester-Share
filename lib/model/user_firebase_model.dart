import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirebaseModel {
  String uid;
  String email;
  String profileName;
  int deployed;
  int testerParticipation;
  DateTime createAt;
  DateTime updateAt;
  int testerRequest;

  UserFirebaseModel({
    required this.uid,
    required this.email,
    required this.profileName,
    required this.deployed,
    required this.testerParticipation,
    required this.createAt,
    required this.updateAt,
    required this.testerRequest,
  });

  factory UserFirebaseModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserFirebaseModel(
      uid: doc.id,
      email: data['email'] ?? '',
      profileName: data['profileName'] ?? '',
      deployed: data['deployed'] ?? 0,
      testerParticipation: data['testerParticipation'] ?? 0,
      createAt: (data['createAt'] as Timestamp).toDate(),
      updateAt: (data['updateAt'] as Timestamp).toDate(),
      testerRequest: data['testerRequest'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'profileName': profileName,
      'deployed': deployed,
      'testerParticipation': testerParticipation,
      'createAt': createAt,
      'updateAt': updateAt,
      'testerRequest': testerRequest,
    };
  }
}
