class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  List? tasksTitle;
  List? tasksText;
  List? tasksColor;
  List? tasksIsDone;

  UserModel(
      {this.uid,
      this.email,
      this.firstName,
      this.secondName,
      this.tasksTitle,
      this.tasksText,
      this.tasksColor,
      this.tasksIsDone});

  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        firstName: map['first name'],
        secondName: map['second name'],
        tasksTitle: map['tasksTitle'],
        tasksText: map['tasksText'],
        tasksColor: map['tasksColor'],
        tasksIsDone: map['tasksIsDone']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'first name': firstName,
      'second name': secondName,
      'tasksTitle': tasksTitle,
      'tasksText': tasksText,
      'tasksColor': tasksColor,
      'tasksIsDone': tasksIsDone
    };
  }
}
