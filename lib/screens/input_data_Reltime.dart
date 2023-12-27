import 'package:animate_do/animate_do.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:crud_firebase/Class/databasehalper_reltime.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// class Student {
//   String? key;
//   StudentData? studentData;

//   Student({this.key, this.studentData});
// }

// class StudentData {
//   String? name;
//   String? age;
//   String? subject;

//   StudentData({this.name, this.age, this.subject});

//   StudentData.fromJson(Map<dynamic, dynamic> json) {
//     name = json["name"];
//     age = json["age"];
//     subject = json["subject"];
//   }
// }

class InputDataRealtime extends StatefulWidget {
  const InputDataRealtime({Key? key}) : super(key: key);

  @override
  State<InputDataRealtime> createState() => _InputDataRealtimeState();
}

class _InputDataRealtimeState extends State<InputDataRealtime> {
  DatabaseReference dbRef = FirebaseDatabase.instance.reference();

  final TextEditingController _edtNameController = TextEditingController();
  final TextEditingController _edtAgeController = TextEditingController();
  final TextEditingController _edtSubjectController = TextEditingController();

  List<Student> studentList = [];

  bool updateStudent = false;

  @override
  void initState() {
    super.initState();
    retrieveStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Directory"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: studentList.length,
              itemBuilder: (context, index) {
                return studentWidget(studentList[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _edtNameController.text = "";
          _edtAgeController.text = "";
          _edtSubjectController.text = "";
          updateStudent = false;
          studentDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void studentDialog({String? key}) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _edtNameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _edtAgeController,
                  decoration: const InputDecoration(labelText: "Age"),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _edtSubjectController,
                  decoration: const InputDecoration(labelText: "Subject"),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Map<String, dynamic> data = {
                      "name": _edtNameController.text.toString(),
                      "age": _edtAgeController.text.toString(),
                      "subject": _edtSubjectController.text.toString()
                    };

                    if (updateStudent) {
                      dbRef
                          .child("Students")
                          .child(key!)
                          .update(data)
                          .then((value) {
                        int index = studentList
                            .indexWhere((element) => element.key == key);
                        studentList.removeAt(index);
                        studentList.insert(
                            index,
                            Student(
                                key: key,
                                studentData: StudentData.fromJson(data)));
                        setState(() {});
                        Navigator.of(context).pop();
                        showSuccessSnackBar("Data updated successfully!");
                      });
                    } else {
                      dbRef.child("Students").push().set(data).then((value) {
                        Navigator.of(context).pop();
                        showSuccessSnackBar("Data added successfully!");
                      });
                    }
                  },
                  child: Text(updateStudent ? "Update Data" : "Save Data"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void retrieveStudentData() {
    dbRef.child("Students").onChildAdded.listen((data) {
      StudentData studentData =
          StudentData.fromJson(data.snapshot.value as Map);
      Student student =
          Student(key: data.snapshot.key, studentData: studentData);
      studentList.add(student);
      setState(() {});
    });
  }

  Widget studentWidget(Student student) {
    return InkWell(
      onTap: () {
        _edtNameController.text = student.studentData!.name!;
        _edtAgeController.text = student.studentData!.age!;
        _edtSubjectController.text = student.studentData!.subject!;
        updateStudent = true;
        studentDialog(key: student.key);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student.studentData!.name!),
                Text(student.studentData!.age!),
                Text(student.studentData!.subject!),
              ],
            ),
            InkWell(
              onTap: () {
                dbRef
                    .child("Students")
                    .child(student.key!)
                    .remove()
                    .then((value) {
                  int index = studentList
                      .indexWhere((element) => element.key == student.key!);
                  studentList.removeAt(index);
                  setState(() {});
                  showSuccessSnackBar("Data deleted successfully!");
                });
              },
              child: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSuccessSnackBar(String message) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.fixed,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Success!',
        message: message,
        contentType: ContentType.success,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
