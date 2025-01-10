import 'package:challenges_taski/view_models/todo_view_model.dart';
import 'package:challenges_taski/views/home/pages/done_view.dart';
import 'package:challenges_taski/views/home/pages/search_view.dart';
import 'package:challenges_taski/views/widgets/custom_bottom_sheet.dart';
import 'package:challenges_taski/views/widgets/custom_app_bar.dart';
import 'package:challenges_taski/views/home/pages/todo_view.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  final String userName;
  final String userId;
  final String? profileImageUrl;
  final TodoViewModel todoViewModel;
  final Function(String name, String description, String userId)
      onTapCreateTask;

  const HomeView({
    super.key,
    required this.userName,
    required this.profileImageUrl,
    required this.userId,
    required this.todoViewModel,
    required this.onTapCreateTask,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  void _showBottomSheet() {
    showCustomBottomSheet(
      context: context,
      content: SizedBox.shrink(),
      onTapCreateTask: (title, description) {
        widget.onTapCreateTask(title, description, widget.userId);
        widget.todoViewModel.fetchTodoList(widget.userId);
        Navigator.pop(context);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _pages = [
      TodoView(
        userName: widget.userName,
        userId: widget.userId,
        viewModel: widget.todoViewModel,
        onTapIconCreateTask: _showBottomSheet,
      ),
      const CreateScreen(),
      SearchView(
        userId: widget.userId,
        viewModel: widget.todoViewModel,
      ),
      DoneView(
        userId: widget.userId,
        viewModel: widget.todoViewModel,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        userName: widget.userName,
        profileImageUrl:
            'https://miro.medium.com/v2/resize:fit:739/1*RscyfcRsHkY9F6nK7cQQAg.jpeg',
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            if (index == 1) {
              _showBottomSheet();
            } else {
              _currentIndex = index;
            }
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Todo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done),
            label: 'Done',
          ),
        ],
      ),
    );
  }
}

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Create Task'),
    );
  }
}
