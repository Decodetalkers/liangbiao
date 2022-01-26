enum User {
  student,
  teacher,
}
enum Logintype {
  anonymous,
  email,
}

class Message {
  User person;
  String id;
  Message({required this.person, required this.id});
}
