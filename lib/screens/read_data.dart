import 'package:crud_firebase/Class/databasehalper_reltime.dart';
import 'package:flutter/material.dart';

class ViewDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Pengguna'),
      ),
      body: StreamBuilder<List<User>>(
        stream: getUsers(),
        builder: (context, snapshot) {
          print('Connection State: ${snapshot.connectionState}');
          print('Has Error: ${snapshot.hasError}');
          print('Data: ${snapshot.data}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading data: ${snapshot.error}'),
            );
          } else {
            List<User> userList = snapshot.data ?? [];

            if (userList.isEmpty) {
              return Center(
                child: Text('No users available.'),
              );
            }

            return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                User user = userList[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                );
              },
            );
          }
        },
      ),
    );
  }
}
