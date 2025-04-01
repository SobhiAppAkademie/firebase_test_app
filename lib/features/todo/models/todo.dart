class Todo {
  // Attribute
  final String docID;
  final String title;
  final String text;
  final bool isDone;

  // Konstruktor
  Todo(
      {required this.title,
      required this.text,
      required this.isDone,
      required this.docID});

  // Factory
  factory Todo.fromMap(Map<String, dynamic> map, String docID) {
    return Todo(
        title: map["title"] as String,
        text: map["text"] as String,
        isDone: map["isDone"] as bool,
        docID: docID);
  }

  Map<String, dynamic> toMap() {
    return {"title": title, "text": text, "isDone": isDone};
  }
}
