library flutter_hold_button;

import 'dart:async';

import 'package:flutter/material.dart';

const _step = Duration(milliseconds: 100);

class HoldButton extends StatefulWidget {
  const HoldButton({
    Key? key,
    this.size = const Size.fromHeight(40),
    required this.onTap,
    required this.duration,
    required this.child,
  }) : super(key: key);

  final Size size;
  final VoidCallback onTap;
  final Duration duration;
  final Widget child;

  @override
  State<HoldButton> createState() => _HoldButtonState();
}

class _HoldButtonState extends State<HoldButton> {
  Duration _currentDuration = const Duration();
  Timer? _timer;
  bool _isActive = false;

  void _reset() {
    setState(() {
      _currentDuration = const Duration();
    });
  }

  void _start() {
    setState(() {
      _isActive = true;
    });
    _timer = Timer.periodic(
      _step,
      (t) {
        setState(() {
          _currentDuration +=  _step;

          if (_currentDuration >= widget.duration) {
            stop();
            widget.onTap();
          }
        });
      },
    );
  }

  void stop() {
    _timer?.cancel();
    setState(() {
      _isActive = false;
    });
  }

  void _tapUp(TapUpDetails details) {
    stop();
  }

  void _tapDown(TapDownDetails details) {
    _reset();
    _start();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 100,
        minWidth: 100,
        maxHeight: 100,
        maxWidth: double.infinity,
      ),
      child: GestureDetector(
        onTapDown: _tapDown,
        onTapUp: _tapUp,
        child: Stack(
          children: [
            AnimatedScale(
              duration: _isActive ? widget.duration : const Duration(),
              scale: _isActive ? 0.8 : 1,
              child: Container(
                decoration: _isActive
                    ? BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(.7),
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      )
                    : null,
              ),
            ),
            AnimatedScale(
              duration: const Duration(milliseconds: 75),
              scale: _isActive ? 0.8 : 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: widget.child),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
