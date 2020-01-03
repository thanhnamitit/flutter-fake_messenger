import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Emoji extends StatefulWidget {
  final String path;
  final Color color;
  final double size;
  final double opacity;

  Emoji(this.path, {this.color, this.size, this.opacity = 1});

  @override
  _EmojiState createState() => _EmojiState();
}

class _EmojiState extends State<Emoji> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Opacity(
        opacity: widget.opacity,
        child: SvgPicture.asset(
          widget.path,
          color: widget.color,
        ),
      ),
    );
  }
}
