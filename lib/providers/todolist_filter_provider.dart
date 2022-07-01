import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/todo.dart';
import 'todolist_provider.dart';

// The different ways to filter the list of todos
enum TodoListFilter {
  all,
  active,
  completed,
}

// The currently active filter.
final todoListFilter = StateProvider((_) => TodoListFilter.all);

// The number of uncompleted todos

final uncompletedTodosCount = Provider<int>((ref) {
  return ref.watch(todoListProvider).where((todo) => !todo.completed).length;
});

// The list of todos after applying of [todoListFilter].

final filteredTodos = Provider<List<Todo>>((ref) {
  final filter = ref.watch(todoListFilter);
  final todos = ref.watch(todoListProvider);

  switch (filter) {
    case TodoListFilter.completed:
      return todos.where((todo) => todo.completed).toList();
    case TodoListFilter.active:
      return todos.where((todo) => !todo.completed).toList();
    case TodoListFilter.all:
      return todos;
  }
});
