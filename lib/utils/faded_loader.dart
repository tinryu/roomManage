import 'package:flutter/material.dart';

class FadedLoader extends StatefulWidget {
  const FadedLoader({
    super.key,
    this.duration = const Duration(milliseconds: 2600),
  });

  final Duration duration;

  @override
  State<FadedLoader> createState() => _FadedLoaderState();
}

class _FadedLoaderState extends State<FadedLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _opacity = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: const CircularProgressIndicator(),
    );
  }
}
