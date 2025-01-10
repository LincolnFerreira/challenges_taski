import '../../../core/theme/custom_color.dart';
import '../../../models/task.dart';
import '../../../view_models/todo_view_model.dart';
import '../../widgets/custom_button_icon_label.dart';
import '../../widgets/custom_circular_progress.dart';
import '../../widgets/task_list.dart';
import 'package:flutter/material.dart';

class TodoView extends StatefulWidget {
  final String userName;
  final String userId;
  final TodoViewModel viewModel;
  final VoidCallback onTapIconCreateTask;

  const TodoView({
    super.key,
    required this.userName,
    required this.userId,
    required this.viewModel,
    required this.onTapIconCreateTask,
  });

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.fetchTodoList(widget.userId);
    setState(() {});
  }

  Future<void> onTaskModified(Task task) async {
    await widget.viewModel.updateTask(widget.userId, task);
    await widget.viewModel.fetchTodoList(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (context, _) {
        final todoList = widget.viewModel.todoList;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 26),
                  Text.rich(
                    TextSpan(
                      text: 'Welcome, ',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: '${widget.userName}.',
                          style: const TextStyle(
                            color: CustomColor.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    todoList == null || todoList.isEmpty
                        ? 'Create tasks to achieve more'
                        : 'You\'ve got ${todoList.length} tasks to do.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: todoList == null
                  ? Center(child: CustomCircularProgress())
                  : todoList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 20,
                            children: [
                              Image.asset(
                                'assets/images/clipboard.png',
                                opacity: AlwaysStoppedAnimation<double>(0.4),
                                height: 80,
                              ),
                              Text('You have no tasks listed.'),
                              SizedBox(height: 10),
                              CustomButtonIconLabel(
                                text: 'Create task',
                                fontSize: 20,
                                icon: Icons.add,
                                onPressed: widget.onTapIconCreateTask,
                              ),
                            ],
                          ),
                        )
                      : TaskList(
                          tasks: todoList,
                          onTaskModified: onTaskModified,
                        ),
            ),
          ],
        );
      },
    );
  }
}
