import 'package:challenges_taski/views/widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';

class DeletableTaskItem extends StatelessWidget {
  final String taskName;
  final VoidCallback? onDelete;

  const DeletableTaskItem({
    super.key,
    required this.taskName,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(123, 224, 224, 224),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomCheckbox(
              initialValue: true,
              onChanged: (value) => print(value),
              isDisabled: true,
              disabledColor: Colors.grey,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                taskName,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red, size: 22),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
