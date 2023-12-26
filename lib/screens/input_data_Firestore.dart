import 'package:crud_firebase/Class/databasehalper_firestore.dart';
import 'package:flutter/material.dart';

class InputData extends StatefulWidget {
  const InputData({super.key});

  @override
  State<InputData> createState() => _InputDataState();
}

class _InputDataState extends State<InputData> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Data'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Tambahkan data baru
                  addData(_nameController.text, _emailController.text);
                },
                child: Text('Add Data'),
              ),
              SizedBox(height: 20),
              StreamBuilder(
                stream: getUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('No data available.');
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var userData = snapshot.data!.docs[index];
                      return ListTile(
                        title: Text(userData['name']),
                        subtitle: Text(userData['email']),
                        onTap: () {
                          // Tampilkan dialog untuk memilih tindakan: Update atau Delete
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Choose Action'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // Implementasi Update di sini
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Update'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Implementasi Delete di sini
                                      deleteData(userData.id);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
