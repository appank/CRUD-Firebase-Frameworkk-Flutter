import 'dart:ffi';

import 'package:animate_do/animate_do.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:crud_firebase/Class/databasehalper_reltime.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
  final TextEditingController _edtDateController = TextEditingController();

  List<Student> studentList = [];

  bool updateStudent = false;

  /// Refreshing Data After every User action
  @override
  void initState() {
    super.initState();
    retrieveStudentData();
    dataload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFDFF),
      appBar: AppBar(
        title: const Text("Student Directory"),
      ),
      body: updateStudent
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurpleAccent,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopSideTitles(studentList: studentList),
                studentList.isEmpty
                    ? const Expanded(child: EmptyListState())
                    : Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: studentList.length,
                          itemBuilder: (context, index) => Slidable(
                            key: const ValueKey(0),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              extentRatio: 0.3,
                              children: [
                                SlidableAction(
                                  flex: 3,
                                  onPressed: (_) =>
                                      hapusWidget(studentList[index]),
                                  foregroundColor: Colors.red,
                                  icon: Icons.delete,
                                  label: 'Remove',
                                  autoClose: true,
                                ),
                              ],
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () =>
                                              editData(studentList[index]),
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const Text(
                                          "Edit",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      color: Colors.deepPurpleAccent
                                          .withOpacity(0.5),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 5),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 12, left: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            MyData(studentList[index]),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _edtNameController.text = "";
          _edtAgeController.text = "";
          _edtSubjectController.text = "";
          _edtDateController.text = "";
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
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.title), labelText: "Name"),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _edtAgeController,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.title), labelText: "Age"),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _edtSubjectController,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.message), labelText: "Subject"),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _edtDateController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.date_range),
                          labelText: "Date"),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Map<String, dynamic> data = {
                      "name": _edtNameController.text.toString(),
                      "age": _edtAgeController.text.toString(),
                      "subject": _edtSubjectController.text.toString(),
                      "date": _edtDateController.text.toString()
                    };

                    if (updateStudent) {
                      // Jika updateStudent bernilai true, artinya kita akan melakukan pembaruan
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
                        Navigator.of(context).pop();
                        setState(() {
                          updateStudent = false;
                        });
                        showSuccessSnackBar("Data updated successfully!");
                      });
                    } else {
                      // Jika updateStudent bernilai false, artinya kita akan menambahkan data baru
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

  // Widget studentWidget(Student student) {
  //   return InkWell(
  //     onTap: () {
  //       _edtNameController.text = student.studentData!.name!;
  //       _edtAgeController.text = student.studentData!.age!;
  //       _edtSubjectController.text = student.studentData!.subject!;
  //       _edtDateController.text = student.studentData!.date!;
  //       updateStudent = true;
  //       studentDialog(key: student.key);
  //     },
  //     child: Container(
  //       width: MediaQuery.of(context).size.width,
  //       padding: const EdgeInsets.all(16),
  //       margin: const EdgeInsets.only(top: 8),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10),
  //         border: Border.all(color: Colors.black),
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(student.studentData!.name!),
  //               Text(student.studentData!.age!),
  //               Text(student.studentData!.subject!),
  //               Text(student.studentData!.date!),
  //             ],
  //           ),
  //           InkWell(
  //             onTap: () {
  //               dbRef
  //                   .child("Students")
  //                   .child(student.key!)
  //                   .remove()
  //                   .then((value) {
  //                 int index = studentList
  //                     .indexWhere((element) => element.key == student.key!);
  //                 studentList.removeAt(index);
  //                 setState(() {});
  //                 showSuccessSnackBar("Data deleted successfully!");
  //               });
  //             },
  //             child: const Icon(
  //               Icons.delete,
  //               color: Colors.red,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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

  hapusWidget(Student student) {
    dbRef.child("Students").child(student.key!).remove().then((value) {
      int index =
          studentList.indexWhere((element) => element.key == student.key!);
      studentList.removeAt(index);
      setState(() {
        dataload();
      });
      showSuccessSnackBar("Data deleted successfully!");
    });
  }

  void dataload() {
    dbRef.child("Students").onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null && snapshot.value is Map) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        List<Student> updatedList = [];

        data.forEach((key, value) {
          if (value is Map) {
            StudentData studentData = StudentData.fromJson(value as Map);
            updatedList.add(Student(key: key, studentData: studentData));
          }
        });

        setState(() {
          studentList = updatedList;
        });
      }
    });
  }

  void retrieveStudentData() {
    dbRef.child("Students").onChildAdded.listen((data) {
      try {
        StudentData studentData =
            StudentData.fromJson(data.snapshot.value as Map);
        Student student =
            Student(key: data.snapshot.key, studentData: studentData);
        studentList.add(student);
        setState(() {});
      } catch (e) {
        print("Error parsing data: $e");
      }
    });

    dbRef.child("Students").onChildChanged.listen((data) {
      try {
        // Handle perubahan data
        StudentData studentData =
            StudentData.fromJson(data.snapshot.value as Map);
        String key = data.snapshot.key!;
        int index = studentList.indexWhere((element) => element.key == key);
        print("Data changed ok: ${data.snapshot.value}");
        if (index != -1) {
          setState(() {
            dataload();
          });
        }
      } catch (e) {
        print("Error handling data change: $e");
      }
    });

    dbRef.child("Students").onChildRemoved.listen((data) {
      try {
        print("Data removed: ${data.snapshot.value}");
        // Handle penghapusan data
        String key = data.snapshot.key!;
        studentList.removeWhere((element) => element.key == key);
        setState(() {
          dataload();
        });
      } catch (e) {
        print("Error handling data removal: $e");
      }
    });
  }

  editData(Student student) {
    _edtNameController.text = student.studentData!.name!;
    _edtAgeController.text = student.studentData!.age!;
    _edtSubjectController.text = student.studentData!.subject!;
    _edtDateController.text = student.studentData!.date!;
    updateStudent = true;
    studentDialog(key: student.key);
  }

  MyData(Student student) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(student.studentData!.name!,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 18,
            )),
        Text(student.studentData!.age!,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 18,
            )),
        Text(student.studentData!.subject!,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 18,
            )),
        Text(student.studentData?.date ?? 'No Date',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 18,
            )),
      ],
    );
  }

  Future _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());

    if (picked != null && picked != _edtDateController) {
      setState(() {
        _edtDateController.text =
            "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }
}

class EmptyListState extends StatelessWidget {
  const EmptyListState({super.key});

  // @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            height: 300,
            child: FadeInUp(
                from: 30,
                child: Lottie.network(
                    fit: BoxFit.cover,
                    'https://lottie.host/6c5d8b9e-aa40-4ca6-bd94-417832dfc644/vSG6B2gPfU.json')),
          ),
          const SizedBox(
            height: 50,
          ),
          FadeInUp(
            from: 30,
            child: const Text(
              "All Tasks Done!👍",
              style: TextStyle(fontSize: 17),
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          FadeInUp(
            from: 30,
            delay: const Duration(milliseconds: 400),
            child: Text(
              "For Creating a Task Tap on the FAB button👇",
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}

class TopSideTitles extends StatelessWidget {
  TopSideTitles({
    super.key,
    required this.studentList,
  });

  List<Student> studentList = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 15, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hello, Amir!",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 23,
              color: Colors.grey.shade500,
            ),
          ),
          Text(
            "Your \nProjects ${studentList.isNotEmpty ? "(${studentList.length})" : " "}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 55,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
