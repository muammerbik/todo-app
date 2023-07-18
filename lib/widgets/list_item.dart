import 'package:flutter/material.dart';
import 'package:flutter_to_do_app/data/local_storage.dart';
import 'package:flutter_to_do_app/main.dart';
import 'package:flutter_to_do_app/model/task_model.dart';
import 'package:intl/intl.dart';

class ListItem extends StatefulWidget {
  Task task;
  ListItem({required this.task, super.key});

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  late LocalStorage _localStorage;

  TextEditingController _TextController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
   
  }

  @override
  Widget build(BuildContext context) {
     _TextController.text = widget.task.name;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)
              ]),
          child: ListTile(
              leading: GestureDetector(
                onTap: () async {
                  widget.task.upcomplate = !widget.task.upcomplate;
                  await _localStorage.upDateTask(task: widget.task);
                  setState(() {});
                },
                child: Container(
                  decoration: BoxDecoration(
                      color:
                          widget.task.upcomplate ? Colors.green : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.8,
                      )),
                  child: Icon(Icons.check, color: Colors.white),
                ),
              ),
              title: widget.task.upcomplate
                  ? Text(
                      widget.task.name,
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    )
                  : TextField(
                      textInputAction: TextInputAction.done,
                      minLines: 1,
                      maxLines: null,
                      style: TextStyle(),
                      controller: _TextController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      onSubmitted: (yeniAtananDeger) async {
                        if (yeniAtananDeger.length > 3) {
                          widget.task.name = yeniAtananDeger;
                         await _localStorage.upDateTask(task: widget.task);
                        }
                      },
                    ),
              trailing: Text(
                DateFormat('hh:mm a').format(widget.task.createAt),
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ))),
    );
  }
}
