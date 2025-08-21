import 'package:app_project/screens/tasks/task_detail_screen.dart';
import 'package:app_project/screens/tasks/task_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' as p;
import 'package:app_project/providers/dashboard_provider.dart';
import 'package:app_project/utils/format.dart';

class UpcomingTasks extends StatefulWidget {
  const UpcomingTasks({super.key});

  @override
  State<UpcomingTasks> createState() => _UpcomingTasksState();
}

class _UpcomingTasksState extends State<UpcomingTasks> {
  @override
  Widget build(BuildContext context) {
    final dp = p.Provider.of<DashboardProvider>(context);
    final isLoading = dp.isLoading;
    final upcomingTasks = dp.upcomingTasks;
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
                  : upcomingTasks.isEmpty
                  ? Center(child: Text('Không có task'))
                  : RefreshIndicator(
                      onRefresh: () async {
                        await dp.fetchDashboard(taskLimit: 3);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: upcomingTasks.length,
                          separatorBuilder: (context, index) =>
                              const Divider(thickness: 0.3),
                          itemBuilder: (context, index) {
                            final task = upcomingTasks[index];
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
                                    SizedBox(width: 20),
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
                                            '${appFormatDate(context, task.createdAt)} - ${DateFormat('HH:mm').format(task.createdAt)}',
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
