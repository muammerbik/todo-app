import 'package:flutter_to_do_app/model/task_model.dart';
import 'package:hive/hive.dart';

abstract class LocalStorage {
  Future<List<Task>> getAllTask();
  Future<void> addTask({required Task task});
  Future<Task?> getTask({required String id});
  Future<bool> deleteTask({required Task task});
  Future<Task> upDateTask({required Task task});
}

class HiveLocalStroge extends LocalStorage {
  late Box<Task> _taskBox;
  HiveLocalStroge() {
    _taskBox = Hive.box<Task>('tasks');
  }
  @override
  Future<void> addTask({required Task task}) async {
    await _taskBox.put(task.id, task);
  }

  @override
  Future<bool> deleteTask({required Task task}) async {
    await task.delete();
    return true;
  }

  @override
  Future<List<Task>> getAllTask() async {
    List<Task> _allTask = <Task>[];
    _allTask = _taskBox.values.toList();

    if (_allTask.isNotEmpty) {
      _allTask.sort((Task a, Task b) => b.createAt.compareTo(a.createAt));
    }
    return _allTask;
  }

  @override
  Future<Task?> getTask({required String id}) async {
    if (_taskBox.containsKey(id)) {
      _taskBox.get(id);
    }
  }

  @override
  Future<Task> upDateTask({required Task task}) async {
   await task.save();
   return task;
  }
}
