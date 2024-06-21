import 'package:flutter/material.dart';
import 'FirestoreService.dart';
import 'item_model.dart';

class HomeScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  void _showDialog(BuildContext context, {Item? item}) {
    if (item != null) {
      _nameController.text = item.name;
      _quantityController.text = item.quantity.toString();
    } else {
      _nameController.clear();
      _quantityController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item == null ? 'Add Item' : 'Edit Item',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final name = _nameController.text;
                        final quantity = int.tryParse(_quantityController.text) ?? 0;

                        if (item == null) {
                          final newItem = Item(
                            id: Item.generateId(),
                            name: name,
                            quantity: quantity,
                          );
                          _firestoreService.addItem(newItem);
                        } else {
                          final updatedItem = Item(
                            id: item.id,
                            name: name,
                            quantity: quantity,
                          );
                          _firestoreService.updateItem(updatedItem);
                        }

                        Navigator.pop(context);
                      },
                      child: Text(item == null ? 'Add' : 'Update'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Firebase CRUD'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: StreamBuilder<List<Item>>(
          stream: _firestoreService.getItems(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            final items = snapshot.data;

            return ListView.builder(
              itemCount: items!.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: Colors.teal.shade50,
                  child: ListTile(
                    title: Text(item.name, style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                    subtitle: Text('Quantity: ${item.quantity}', style: TextStyle(color: Colors.teal)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.teal),
                          onPressed: () => _showDialog(context, item: item),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _firestoreService.deleteItem(item.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
