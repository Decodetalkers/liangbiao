enum User {
  student,
  teacher,
}

class Message {
  User person;
  String id;
  Message({required this.person, required this.id});
}
