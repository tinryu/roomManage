import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_project/providers/activity_provider.dart';
import 'package:app_project/screens/recentactive/recentlist.dart'
    show RecentList;
import 'package:intl/intl.dart';

class RecentActivityScreen extends ConsumerWidget {
  const RecentActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeState = ref.watch(activityProvider); // All alway init data
    // final activityNotifier = ref.read(activityProvider); //call notifier if u want all another func

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
                    "Recent Activity",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  InkWell(
                    child: Text(
                      "View All",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RecentList(onLocaleChange: (Locale locale) {}),
                        ),
                      ),
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              activeState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('Lỗi: $error')),
                data: (activities) {
                  if (activities.isEmpty) {
                    return const Center(
                      child: Text('Không có hoạt động gần đây'),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(activityProvider);
                    },
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 16,
                        children: activities.map((act) {
                          return Container(
                            width: 160,
                            height: 80,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade100),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  spacing: 12,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.lightBlue,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.history,
                                        size: 24,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Column(
                                      spacing: 4,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          act.action,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          textScaler: TextScaler.linear(0.8),
                                        ),
                                        Text(
                                          act.userid == "1" ? 'admin' : 'user',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          textScaler: TextScaler.linear(0.8),
                                        ),
                                        Text(
                                          DateFormat(
                                            'dd/MM/yyyy HH:mm',
                                          ).format(act.timestamp),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          textScaler: TextScaler.linear(0.8),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
