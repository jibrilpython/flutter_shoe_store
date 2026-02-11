import 'package:flutter/material.dart';

class ListLengths extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets padding;
  const ListLengths({super.key, required this.children, this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(children: children),
    );
  }
}