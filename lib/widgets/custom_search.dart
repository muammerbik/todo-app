import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_to_do_app/data/local_storage.dart';
import 'package:flutter_to_do_app/main.dart';
import 'package:flutter_to_do_app/model/task_model.dart';

import 'list_item.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Task> allTask;

  CustomSearchDelegate({required this.allTask});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back_ios));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> ListFiltered = allTask
        .where(
            (gorev) => gorev.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListFiltered.length>0 ? ListView.builder(
      itemBuilder: (context, index) {
        var _oankiListeElemani = ListFiltered[index];
        return Dismissible(
          background: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              SizedBox(
                width: 5,
              ),
              Text(
                'delete_task',
              
              ).tr(),
            ],
          ),
          key: Key(_oankiListeElemani.id),
          onDismissed: (direction) {
            ListFiltered.removeAt(index);
            locator<LocalStorage>().deleteTask(task: _oankiListeElemani);
            
          
          },
          child: ListItem(task: _oankiListeElemani),
        );
      },
      itemCount: ListFiltered.length,
    ): Center(child: Text('search_not_found').tr());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
