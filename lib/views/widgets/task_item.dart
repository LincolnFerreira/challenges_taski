// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:challenges_taski/models/task.dart';
import 'package:challenges_taski/views/widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final bool isChecked;
  final bool showDescription;
  final ValueChanged<bool?>? onChanged;

  const TaskItem({
    super.key,
    required this.task,
    this.isChecked = false,
    this.showDescription = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    var Task(:id, :title, :description, :isCompleted) = task;

    return Card(
      color: const Color.fromARGB(123, 224, 224, 224),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CustomCheckbox(
                initialValue: isCompleted,
                onChanged: (value) => onChanged?.call(value),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (showDescription && description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      task.isSynced ? 'Synced' : 'Not Synced',
                      style: TextStyle(
                        fontSize: 12,
                        color: task.isSynced ? Colors.green : Colors.red,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Icon(Icons.more_horiz)
          ],
        ),
      ),
    );
  }
}
