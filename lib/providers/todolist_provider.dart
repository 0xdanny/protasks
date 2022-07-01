import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/todo.dart';
import 'sharedprefs_provider.dart';

/// Creates a [TodoList] and initialise it with pre-defined values.
///
/// We are using [StateNotifierProvider] here as a `List<Todo>` is a complex
/// object, with advanced business logic like how to edit a todo.
final todoListProvider = StateNotifierProvider<TodoList, List<Todo>>((ref) {
  final shareutil = ref.watch(sharedUtilityProvider);
  return TodoList(shareutil, const [
    Todo(id: 'todo-0', description: 'hi'),
    Todo(id: 'todo-1', description: 'hello'),
    Todo(id: 'todo-2', description: 'bonjour'),
  ]);
});
