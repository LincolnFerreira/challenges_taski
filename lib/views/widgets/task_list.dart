import 'package:challenges_taski/models/task.dart';
import 'package:flutter/material.dart';
import 'task_item.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) onTaskModified;
  const TaskList({
    super.key,
    required this.tasks,
    required this.onTaskModified,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return TaskItem(
          task: tasks[index],
          isChecked: tasks[index].isCompleted,
          onChanged: (bool? value) {
            final task = tasks[index];
            onTaskModified(task.copyWith(
              isCompleted: value,
              isModified: true,
              isSynced: false,
            ));
          },
        );
      },
    );
  }
}
