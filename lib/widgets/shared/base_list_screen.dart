import 'package:flutter/material.dart';

class BaseListScreen extends StatelessWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget body;
  final Widget? floatingActionButton;
  final bool showBackButton;
  final bool showAppBar;
  final VoidCallback? onBackPressed;

  const BaseListScreen({
    super.key,
    this.title,
    this.actions,
    required this.body,
    this.floatingActionButton,
    this.showBackButton = true,
    this.showAppBar = true,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              backgroundColor: Colors.lightBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              title: Text(
                title ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              leading: showBackButton
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed:
                          onBackPressed ?? () => Navigator.of(context).pop(),
                    )
                  : null,
              actions: actions,
            )
          : null,
      body: SafeArea(child: body),
      floatingActionButton: floatingActionButton,
    );
  }
}

class BaseListTile extends StatelessWidget {
  final String title;
  final bool showTitle;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool selected;
  final Color? tileColor;

  const BaseListTile({
    super.key,
    required this.title,
    this.showTitle = true,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.selected = false,
    this.tileColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 1,
      color: selected ? Colors.white.withAlpha(10) : tileColor,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: leading,
        title: showTitle
            ? Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textScaler: TextScaler.linear(0.8),
              )
            : null,
        subtitle: subtitle,
        trailing: trailing,
        onTap: onTap,
        selected: selected,
        selectedTileColor: Colors.lightBlue.withAlpha(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: selected ? Colors.white : Colors.grey.shade300,
            width: selected ? 1.1 : 1,
          ),
        ),
      ),
    );
  }
}
