import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagramclone/models/post.dart';
import 'package:instagramclone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Instance of Firestore for database operations

  // Method to upload a post to Firestore
  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    // Get the uid from state management to avoid extra calls to FirebaseAuth
    String res = "Some error occurred"; // Default error message
    try {
      // Upload the image to Firebase Storage and get the download URL
      String photoUrl =
      await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1(); // Create a unique ID for the post based on time
      // Create a Post object
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );
      // Add the post to the 'posts' collection in Firestore
      await _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success"; // Update the result message to success
    } catch (err) {
      res = err.toString(); // Update the result message to the error message
    }
    return res; // Return the result message
  }

  // Method to like or unlike a post
  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred"; // Default error message
    try {
      if (likes.contains(uid)) {
        // If the user has already liked the post, remove the like
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // If the user has not liked the post, add the like
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success'; // Update the result message to success
    } catch (err) {
      res = err.toString(); // Update the result message to the error message
    }
    return res; // Return the result message
  }

  // Method to post a comment on a post
  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred"; // Default error message
    try {
      if (text.isNotEmpty) {
        // If the comment text is not empty
        String commentId = const Uuid().v1(); // Create a unique ID for the comment
        // Add the comment to the 'comments' subcollection of the post
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success'; // Update the result message to success
      } else {
        res = "Please enter text"; // Update the result message to prompt for text
      }
    } catch (err) {
      res = err.toString(); // Update the result message to the error message
    }
    return res; // Return the result message
  }

  // Method to delete a post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred"; // Default error message
    try {
      // Delete the post document from the 'posts' collection
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success'; // Update the result message to success
    } catch (err) {
      res = err.toString(); // Update the result message to the error message
    }
    return res; // Return the result message
  }

  // Method to follow or unfollow a user
  Future<void> followUser(String uid, String followId) async {
    try {
      // Get the document snapshot of the current user
      DocumentSnapshot snap =
      await _firestore.collection('users').doc(uid).get();
      // Get the list of users the current user is following
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        // If the current user is already following the target user, unfollow
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        // If the current user is not following the target user, follow
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      if (kDebugMode) print(e.toString()); // Print the error message in debug mode
    }
  }
}
