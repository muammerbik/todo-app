import 'package:hive_flutter/adapters.dart';
import 'package:uuid/uuid.dart';
 part 'task_model.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject{
  @HiveField(0)
  final String id;
   @HiveField(1)
   String name;
    @HiveField(2)
  final DateTime createAt;
   @HiveField(3)
   bool upcomplate;

  Task({required this.id,required this.name,required this.createAt,required this.upcomplate});

 factory Task.created({required String name,required DateTime createAt}){
  return Task(id: const Uuid().v1(), name: name, createAt: createAt, upcomplate: false);
 }
}
