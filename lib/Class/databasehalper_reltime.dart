class Student {
  String? key;
  StudentData? studentData;
  String? date; // Tambahkan properti date

  Student({this.key, this.studentData, this.date});
}

class StudentData {
  String? name;
  String? age;
  String? subject;
  String? date;

  StudentData({this.name, this.age, this.subject, this.date});

  StudentData.fromJson(Map<dynamic, dynamic> json) {
    name = json["name"];
    age = json["age"];
    subject = json["subject"];
    date = json["date"]; // Ambil data tanggal dari JSON
  }
}
