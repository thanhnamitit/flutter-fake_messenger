import 'package:flutter/material.dart';

class BounceButton extends StatefulWidget {
  final Widget child;
  final Function onTap;
  final int bounceDuration;

  BounceButton({@required this.child, this.onTap, this.bounceDuration = 200});

  @override
  _BounceButtonState createState() => _BounceButtonState();
}

class _BounceButtonState extends State<BounceButton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.bounceDuration),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown() {
    _controller.forward();
  }

  void _onTapUp() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: GestureDetector(
        onTapDown: (_) {
          _onTapDown();
        },
        onTapUp: (_) {
          _onTapUp();
        },
        onTapCancel: () {
          _onTapUp();
        },
        onTap: widget.onTap,
        child: widget.child,
      ),
      builder: (_, child) {
        final _scale = 1 - _controller.value;
        return Transform.scale(
          scale: _scale,
          child: child,
        );
      },
    );
  }
}
