import 'package:flutter/material.dart';

/// A customizable loading indicator that can be used throughout the app
class LoadingIndicator extends StatelessWidget {
  /// The size of the indicator
  final double size;

  /// The color of the indicator
  final Color? color;

  /// The stroke width of the indicator
  final double strokeWidth;

  /// A custom message to display below the indicator
  final String? message;

  /// The style of the message text
  final TextStyle? messageStyle;

  const LoadingIndicator({
    super.key,
    this.size = 24.0,
    this.color,
    this.strokeWidth = 2.0,
    this.message,
    this.messageStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.primaryColor;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
              strokeWidth: strokeWidth,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16.0),
            Text(
              message!,
              style: messageStyle ?? theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// A full-screen loading indicator with optional background
class FullScreenLoading extends StatelessWidget {
  /// The message to display below the indicator
  final String? message;

  /// Whether to show a semi-transparent background
  final bool showBackground;

  /// The color of the indicator
  final Color? color;

  /// The size of the indicator
  final double size;

  const FullScreenLoading({
    super.key,
    this.message,
    this.showBackground = true,
    this.color,
    this.size = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        if (showBackground)
          ModalBarrier(
            color: Colors.black.withValues(alpha: 0.3),
            dismissible: false,
          ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: size,
                      height: size,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          color ?? theme.primaryColor,
                        ),
                        strokeWidth: 3.0,
                      ),
                    ),
                    if (message != null) ...[
                      const SizedBox(height: 16.0),
                      Text(
                        message!,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.textTheme.titleMedium?.color,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
