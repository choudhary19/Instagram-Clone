import 'package:cloud_firestore/cloud_firestore.dart';
import 'item_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create
  Future<void> addItem(Item item) async {
    try {
      if (!item.isValidName() || !item.isValidQuantity()) {
        throw Exception('Invalid item data');
      }
      await _db.collection('items').doc(item.id).set(item.toMap());
    } catch (e) {
      throw Exception('Failed to add item: $e');
    }
  }

  // Read
  Stream<List<Item>> getItems() {
    try {
      return _db.collection('items').snapshots().map((snapshot) => snapshot.docs
          .map((doc) => Item.fromMap(doc.data() as Map<String, dynamic>))
          .toList());
    } catch (e) {
      throw Exception('Failed to get items: $e');
    }
  }

  // Update
  Future<void> updateItem(Item item) async {
    try {
      if (!item.isValidName() || !item.isValidQuantity()) {
        throw Exception('Invalid item data');
      }
      await _db.collection('items').doc(item.id).update(item.toMap());
    } catch (e) {
      throw Exception('Failed to update item: $e');
    }
  }

  // Delete
  Future<void> deleteItem(String id) async {
    try {
      await _db.collection('items').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete item: $e');
    }
  }
}
