// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:challenges_taski/views/widgets/custom_circular_progress.dart';
import 'package:flutter/material.dart';

import 'package:challenges_taski/models/task.dart';
import 'package:challenges_taski/view_models/todo_view_model.dart';

import '../../widgets/deletable_task_item.dart';

class DoneView extends StatefulWidget {
  final String userId;
  final TodoViewModel viewModel;

  const DoneView({
    super.key,
    required this.viewModel,
    required this.userId,
  });

  @override
  State<DoneView> createState() => _DoneViewState();
}

class _DoneViewState extends State<DoneView> {
  List<Task>? doneList;

  @override
  void initState() {
    super.initState();
    getDoneList();
  }

  getDoneList() async {
    await widget.viewModel.fetchDoneList(widget.userId);
    doneList = widget.viewModel.doneList;
    setState(() {});
  }

  onDeleteAll() async {
    await widget.viewModel.deleteAllTasks(widget.userId);
    getDoneList();
  }

  onDelete(String taskId) async {
    await widget.viewModel.deleteTask(widget.userId, taskId);
    getDoneList();
  }

  @override
  Widget build(BuildContext context) {
    if (doneList == null) {
      return Center(
        child: CustomCircularProgress(),
      );
    }

    if (doneList!.isEmpty) {
      return Center(
        child: Text('No tasks completed.'),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Completed Tasks',
                style: TextStyle(fontSize: 20),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onDeleteAll,
                  child: Text(
                    'Delete all',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              doneList == null || doneList!.isEmpty
                  ? 'Create tasks to achieve more'
                  : 'You\'ve completed ${doneList!.length} tasks.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: doneList!.length,
              itemBuilder: (context, index) {
                return DeletableTaskItem(
                  taskName: doneList![index].title,
                  onDelete: () => onDelete(doneList![index].id!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
