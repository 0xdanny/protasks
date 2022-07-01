import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:protasks/models/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final sharedUtilityProvider = Provider<SharedUtility>((ref) {
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  return SharedUtility(sharedPreferences: sharedPrefs);
});

const String sharedPrefTodoListKey = 'todolist';
final demoTaskStringData = jsonEncode({
  'data': [
    const Todo(id: 'demoid1', description: 'example task'),
    const Todo(id: 'demoid2', description: 'water plants')
  ].map((todo) => todo.toJson()).toList(),
});

class SharedUtility {
  SharedUtility({
    required this.sharedPreferences,
  });

  final SharedPreferences sharedPreferences;

  List<Todo> loadSharedTodoData() {
    Map<String, dynamic> stored = jsonDecode(
        sharedPreferences.getString(sharedPrefTodoListKey) ??
            demoTaskStringData);
    // iterate over the stored data and create a new list of todos
    return List<Todo>.from(stored['data']
        .map((todo) => Todo.fromJson(todo as Map<String, dynamic>)));
  }

  void saveSharedTodoData(List<Todo> todolist) {
    if (todolist.isNotEmpty) {
      final todoListJson = jsonEncode({
        'data': todolist.map((todo) => todo.toJson()).toList(),
      });
      sharedPreferences.setString(sharedPrefTodoListKey, todoListJson);
    } else {
      sharedPreferences.setString(sharedPrefTodoListKey, demoTaskStringData);
    }
  }
}
