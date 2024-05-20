import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tester_share_app/model/post_firebase_model.dart';

class PostFirebaseController {
  final CollectionReference _postsCollection =
      FirebaseFirestore.instance.collection('posts');

  Future<void> addPost(PostFirebaseModel post) async {
    try {
      await _postsCollection.add(post.toMap());
    } catch (e) {
      print('Error adding post: $e');
      throw Exception('Failed to add post');
    }
  }

  Stream<List<PostFirebaseModel>> getPosts() {
    try {
      return _postsCollection
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
                return PostFirebaseModel.fromMap(
                    doc.data() as Map<String, Object?>);
              }).toList());
    } catch (e) {
      print('Error getting posts: $e');
      throw Exception('Failed to get posts');
    }
  }

  Future<void> updatePost(PostFirebaseModel post) async {
    try {
      await _postsCollection.doc(post.id).update(post.toMap());
    } catch (e) {
      print('Error updating post: $e');
      throw Exception('Failed to update post');
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _postsCollection.doc(postId).delete();
    } catch (e) {
      print('Error deleting post: $e');
      throw Exception('Failed to delete post');
    }
  }
}
