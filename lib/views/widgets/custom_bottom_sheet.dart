import 'package:flutter/material.dart';

import 'custom_checkbox.dart';

void showCustomBottomSheet({
  required BuildContext context,
  required Widget content,
  required Function(String title, String description) onTapCreateTask,
}) {
  // Controladores para os campos de texto
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        // Calculando a altura com base no MediaQuery
        padding: EdgeInsets.only(
          left: 40,
          right: 40,
          top: 40,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CustomCheckbox(
                      initialValue: false,
                      onChanged: (value) => print(value),
                      isDisabled: true,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: "What’s in your mind?",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              content,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Icon(
                      Icons.edit,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      maxLines: 4,
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: "Add a note",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Passa os textos para o método onTapCreateTask
                    onTapCreateTask(
                        titleController.text, descriptionController.text);
                  },
                  child: const Text(
                    'Create',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
