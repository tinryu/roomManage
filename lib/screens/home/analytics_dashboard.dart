import 'package:flutter/material.dart';

class AnalyticsDashboard extends StatelessWidget {
  final List<Map<String, dynamic>> stats;
  const AnalyticsDashboard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.transparent),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final spacing = 16.0;
          final int columns = width > 1000
              ? 6
              : width > 700
              ? 6
              : 3;
          final itemWidth = (width - spacing * (columns - 1)) / columns;

          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            alignment: WrapAlignment.start,
            children: stats.map((stat) {
              return SizedBox(
                width: itemWidth,
                child: _quickDash(
                  stat['icon'] as IconData,
                  stat['label'] as String,
                  stat['value'] as String,
                ),
              );
            }).toList(),
          );
        },
      ),

      // child: Column(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      //     LayoutBuilder(
      //       builder: (context, constraints) {
      //         final isSmall = (constraints.maxWidth > 300);
      //         final isWide = (constraints.maxWidth > 600);
      //         final isLarge = constraints.maxWidth > 1200;
      //         return GridView.builder(
      //           shrinkWrap: true,
      //           physics: NeverScrollableScrollPhysics(),
      //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //             crossAxisCount: isLarge ? 6 : 3,
      //             crossAxisSpacing: 16,
      //             mainAxisSpacing: 16,
      //             childAspectRatio: isLarge
      //                 ? 2.2
      //                 : isWide
      //                 ? 2.2
      //                 : isSmall
      //                 ? 1.2
      //                 : 1.1,
      //           ),
      //           itemCount: stats.length,
      //           itemBuilder: (context, index) {
      //             final stat = stats[index];
      //             return _quickDash(stat['icon'], stat['value'], stat['label']);
      //           },
      //         );
      //       },
      //     ),
      //   ],
      // ),
    );
  }
}

Widget _quickDash(IconData icon, String title, String textnumber) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(icon, color: Colors.lightBlue, size: 32),
      ),
      const SizedBox(height: 6),
      Text(
        textnumber,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      const SizedBox(height: 4),
      Text(
        title,
        style: const TextStyle(fontSize: 12),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    ],
  );
}
