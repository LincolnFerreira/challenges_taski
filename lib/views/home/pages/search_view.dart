import '../../../core/theme/custom_color.dart';
import '../../../view_models/todo_view_model.dart';
import '../../widgets/custom_circular_progress.dart';
import '../../widgets/task_list.dart';
import 'package:flutter/material.dart';
import '../../../models/task.dart';

class SearchView extends StatefulWidget {
  final String userId;
  final TodoViewModel viewModel;

  const SearchView({super.key, required this.userId, required this.viewModel});

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  List<Task> searchResults = [];
  bool isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _searchTasks(String query) async {
    setState(() {
      isLoading = true;
    });

    searchResults = await widget.viewModel.searchTasks(widget.userId, query);

    setState(() {
      isLoading = false;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _searchTasks('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('Search Tasks')),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                labelText: 'Search tasks',
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.search,
                  color:
                      _focusNode.hasFocus ? CustomColor.primary : Colors.grey,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: _clearSearch,
                      )
                    : null,
              ),
              onChanged: (query) {
                _searchTasks(query);
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CustomCircularProgress())
                : searchResults.isEmpty
                    ? Center(child: Text('No tasks found.'))
                    : TaskList(
                        tasks: searchResults,
                        onTaskModified: (value) {},
                      ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
