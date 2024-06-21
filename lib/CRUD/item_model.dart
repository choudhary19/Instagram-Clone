import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String id;
  String name;
  int quantity;

  Item({required this.id, required this.name, required this.quantity});

  // Factory constructor to create an Item from a Firestore document
  factory Item.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Item(
      id: doc.id,
      name: data['name'] ?? '',
      quantity: data['quantity'] ?? 0,
    );
  }

  // Factory constructor to create an Item from a map
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? 0,
    );
  }

  // Convert an Item instance to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
    };
  }

  // Validation methods
  bool isValidName() => name.isNotEmpty;
  bool isValidQuantity() => quantity >= 0;

  // Generate a unique ID (you could use uuid package for more complex ID generation)
  static String generateId() => DateTime.now().millisecondsSinceEpoch.toString();
}
