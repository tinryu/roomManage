import 'package:app_project/screens/tasks/task_detail_screen.dart';
import 'package:app_project/screens/tasks/task_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_project/providers/task_provider.dart';
import 'package:app_project/models/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class UpcomingTasks extends ConsumerStatefulWidget {
  const UpcomingTasks({super.key});

  @override
  ConsumerState<UpcomingTasks> createState() => _UpcomingTasksState();
}

class _UpcomingTasksState extends ConsumerState<UpcomingTasks> {
  bool isLoading = false;
  String? error;
  List<Task> monthlyTasks = [];

  @override
  void initState() {
    super.initState();
    _loadUpcomingTasks();
  }

  Future<void> _loadUpcomingTasks() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final taskNotifier = ref.read(taskProvider.notifier);
      final tasks = await taskNotifier.getUpcomingTasks(
        year: 2025,
        month: 8,
        limit: 2,
      );
      setState(() {
        monthlyTasks = tasks;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 8,
                children: [
                  Text(
                    "Upcoming Tasks",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  InkWell(
                    child: Text("View All", style: TextStyle(fontSize: 12)),
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TaskListScreen(),
                        ),
                      ),
                    },
                  ),
                ],
              ),
              SizedBox(height: 12),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : error != null
                  ? Center(child: Text('Lỗi: $error'))
                  : monthlyTasks.isEmpty
                  ? Center(child: Text('Không có task'))
                  : RefreshIndicator(
                      onRefresh: _loadUpcomingTasks,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: monthlyTasks.length,
                          separatorBuilder: (context, index) =>
                              const Divider(thickness: 0.3),
                          itemBuilder: (context, index) {
                            final task = monthlyTasks[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TaskDetailScreen(task: task),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 8,
                                  bottom: 8,
                                  left: 10,
                                  right: 10,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                        color: Colors.lightBlue,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.event_note,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            task.title,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            textScaler: TextScaler.linear(0.8),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            DateFormat(
                                              'dd/MM/yyyy - HH:mm',
                                            ).format(task.createdAt),
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            textScaler: TextScaler.linear(0.8),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
