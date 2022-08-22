class ToDo {
  String id;
  String todoName;
  int priority;
  bool todoDone;

  ToDo(
      {required this.id,
      required this.todoName,
      required this.priority,
      this.todoDone = false});
  void toggleDone() {
    todoDone = !todoDone;
  }
}
