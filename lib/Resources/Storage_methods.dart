import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;  // Instance of FirebaseAuth for user authentication
  final FirebaseStorage _storage = FirebaseStorage.instance;  // Instance of FirebaseStorage for storing files

  // Function to upload an image to Firebase Storage
  Future<String> uploadImageToStorage(String childName, Uint8List file, bool isPost) async {
    // Creating a reference to a location in Firebase Storage
    Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);

    // If the image is for a post, create a unique ID for the image
    if (isPost) {
      String id = const Uuid().v1();  // Generate a unique ID
      ref = ref.child(id);  // Append the unique ID to the reference path
    }

    // Upload the image data (in Uint8List format) to Firebase Storage
    UploadTask uploadTask = ref.putData(file);

    // Wait for the upload to complete and get the snapshot
    TaskSnapshot snapshot = await uploadTask;

    // Get the download URL of the uploaded image
    String downloadUrl = await snapshot.ref.getDownloadURL();

    // Return the download URL
    return downloadUrl;
  }
}
