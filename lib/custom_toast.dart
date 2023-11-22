import 'dart:async';

import 'package:flutter/material.dart';

class CustomToast extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const CustomToast({super.key, required this.child, required this.duration});

  @override
  _CustomToastState createState() => _CustomToastState();
}

class _CustomToastState extends State<CustomToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
    Timer(widget.duration, () {
      //_controller.dispose();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: widget.child,
    );
  }
}

void showCustomToast(BuildContext context, String msg) {
  OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomToast(
          duration: const Duration(seconds: 2),
          child: Container(
              padding: const EdgeInsets.fromLTRB(8.0, 40, 8.0, 16.0),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning,
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  DefaultTextStyle(
                    style:
                        const TextStyle(fontSize: 14, color: Colors.white),
                    child: Text(msg),
                  ),
                ],
              )),
        ),
      ],
    );
  });

  Overlay.of(context).insert(overlayEntry);

  Future.delayed(const Duration(seconds: 2)).then((value) {
    overlayEntry.remove();
  });
}
