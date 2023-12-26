import 'package:cloud_firestore/cloud_firestore.dart';

// Create Data
Future<void> addData(String name, String email) async {
  await FirebaseFirestore.instance.collection('users').add({
    'name': name,
    'email': email,
  });
}

// Read Data
Stream<QuerySnapshot> getUsers() {
  return FirebaseFirestore.instance.collection('users').snapshots();
}

// Update Data
Future<void> updateData(String id, String name, String email) async {
  await FirebaseFirestore.instance.collection('users').doc(id).update({
    'name': name,
    'email': email,
  });
}

// Delete Data
Future<void> deleteData(String id) async {
  await FirebaseFirestore.instance.collection('users').doc(id).delete();
}
