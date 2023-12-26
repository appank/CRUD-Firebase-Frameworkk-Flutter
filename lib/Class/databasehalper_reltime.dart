import 'package:firebase_database/firebase_database.dart';

final DatabaseReference databaseReference =
    FirebaseDatabase.instance.reference();

Future<void> addData(String name, String email) async {
  String? key = databaseReference.child('users').push().key;
  await databaseReference.child('users').child(key!).set({
    'name': name,
    'email': email,
  });
}

Stream<List<User>> getUsers() {
  return databaseReference.child('users').onValue.map((event) {
    List<User> userList = [];

    // Pengecekan tipe data snapshot.value
    if (event.snapshot.value is Map<String, dynamic>) {
      // Konversi snapshot.value ke Map<String, dynamic>
      Map<String, dynamic> data = event.snapshot.value as Map<String, dynamic>;

      // Iterasi melalui entri Map
      data.forEach((key, value) {
        userList.add(User.fromJson(key, value));
      });
    }

    return userList;
  });
}

// Update Data
Future<void> updateData(String key, String name, String email) async {
  await databaseReference.child('users').child(key).update({
    'name': name,
    'email': email,
  });
}

// Delete Data
Future<void> deleteData(String key) async {
  databaseReference.child('users').child(key).remove();
}

class User {
  String key;
  String name;
  String email;

  User(this.key, this.name, this.email);

  factory User.fromJson(String key, Map<String, dynamic> json) {
    return User(
      key,
      json['name'] as String,
      json['email'] as String,
    );
  }
}
