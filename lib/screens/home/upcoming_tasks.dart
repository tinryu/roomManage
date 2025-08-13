import 'package:flutter/material.dart';

class UpcomingTasks extends StatelessWidget {
  final List<Map<String, String>> tasks;
  const UpcomingTasks({super.key, required this.tasks});

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
                children: [
                  Text(
                    "Upcoming Tasks",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  InkWell(
                    child: Text(
                      "View All",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    onTap: () => {},
                  ),
                ],
              ),
              SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tasks.length,
                  separatorBuilder: (context, index) =>
                      const Divider(color: Colors.black12, thickness: 0.3),
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.lightBlue,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task['title'] ?? '',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textScaler: TextScaler.linear(1),
                              ),
                              SizedBox(height: 4),
                              Text(
                                task['date'] ?? '',
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
