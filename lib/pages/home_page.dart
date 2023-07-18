import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_to_do_app/data/local_storage.dart';
import 'package:flutter_to_do_app/datahelper/translation_helper.dart';
import 'package:flutter_to_do_app/main.dart';
import 'package:flutter_to_do_app/model/task_model.dart';
import 'package:flutter_to_do_app/widgets/list_item.dart';
import 'package:flutter_to_do_app/widgets/custom_search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTask;
  late LocalStorage _localStroge;

  @override
  void initState() {
    super.initState();
    _allTask = <Task>[];
    _localStroge = locator<LocalStorage>();

    getAllTaskFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'title',
          style: TextStyle(color: Colors.black),
        ).tr(),
        actions: [
          IconButton(
              onPressed: () {
                addAllSearch();
              },
              icon: Icon(Icons.search)),
          IconButton(
              onPressed: () {
                addAlLTask();
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: _allTask.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, index) {
                var _oankiListeElemani = _allTask[index];
                return Dismissible(
                  background: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'delete_task',
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ).tr(),
                    ],
                  ),
                  key: Key(_oankiListeElemani.id),
                  onDismissed: (direction) {
                    _allTask.removeAt(index);
                    _localStroge.deleteTask(task: _oankiListeElemani);
                    setState(() {});
                  },
                  child: ListItem(task: _oankiListeElemani),
                );
              },
              itemCount: _allTask.length,
            )
          : Center(child: const Text('isEmpty_list_task').tr()),
    );
  }

  addAlLTask() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListTile(
              title: TextField(
                autofocus: true,
                style: TextStyle(fontSize: 22),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'add_task'.tr(),
                ),
                onSubmitted: (value) {
                  Navigator.of(context).pop();
                  if (value.length > 3) {
                    DatePicker.showTimePicker(
                      context,
                      locale: TranslationHelper.getDeviceLanguage(context),
                      showSecondsColumn: false,
                      onConfirm: (time) async {
                        var yeniDeger =
                            Task.created(name: value, createAt: time);
                        _allTask.insert(0, yeniDeger);
                        await _localStroge.addTask(task: yeniDeger);

                        setState(() {});
                      },
                    );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void getAllTaskFromDB() async {
    _allTask = await _localStroge.getAllTask();
    setState(() {});
  }

  void addAllSearch() async{
   await showSearch(
        context: context, delegate: CustomSearchDelegate(allTask: _allTask));
    getAllTaskFromDB();
  }
}
