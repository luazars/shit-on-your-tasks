class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  List? tasks;

  UserModel(
      {this.uid, this.email, this.firstName, this.secondName, this.tasks});

  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        firstName: map['first name'],
        secondName: map['second name'],
        tasks: map['tasks']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'first name': firstName,
      'second name': secondName,
      'tasks': tasks
    };
  }
}
