class Todo {
  final String todoId;
  final String title;
  final String description;
  final String label;
  final String userid;
  final DateTime date;

  Todo({
    required this.todoId,
    required this.title,
    required this.description,
    required this.label,
    required this.userid,
    required this.date,
  });

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      todoId: map['todoId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      label: map['label'].toString() ?? '',
      userid: map['userid'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(int.parse(map['timestamp'].toString() ?? '0')),
    );
  }

}