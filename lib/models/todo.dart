import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:protasks/providers/sharedprefs_provider.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

// A read-only description of a todo-item
@immutable
class Todo {
  const Todo({
    required this.description,
    required this.id,
    this.completed = false,
  });

  final String id;
  final String description;
  final bool completed;

  @override
  String toString() {
    return 'Todo(description: $description, completed: $completed)';
  }

  Todo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        description = json['description'],
        completed = json['completed'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'completed': completed,
      };
}

// An object that controls a list of [Todo].
class TodoList extends StateNotifier<List<Todo>> {
  TodoList(this._sharedUtility, [List<Todo>? initialTodos])
      : super(initialTodos ?? <Todo>[]);

  final SharedUtility _sharedUtility;

  void saveData() {
    _sharedUtility.saveSharedTodoData(state);
  }

  void loadData() {
    final data = _sharedUtility.loadSharedTodoData();
    state = data;
  }

  void add(String description) {
    state = [
      ...state,
      Todo(
        id: _uuid.v4(),
        description: description,
      ),
    ];
    saveData();
  }

  void toggle(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            completed: !todo.completed,
            description: todo.description,
          )
        else
          todo,
    ];
    saveData();
  }

  void edit({required String id, required String description}) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            completed: todo.completed,
            description: description,
          )
        else
          todo,
    ];
    saveData();
  }

  void remove(Todo target) {
    state = state.where((todo) => todo.id != target.id).toList();
    saveData();
  }
}
