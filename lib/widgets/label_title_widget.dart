import 'package:flutter/material.dart';

class LabelTitleWidget extends StatelessWidget {
  final String? title;
  final Widget? action;

  const LabelTitleWidget({super.key, this.title, this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 32,
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 32,
            color: Colors.blue,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "$title",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          action ??
              const SizedBox(
                width: 1,
              ),
        ],
      ),
    );
  }
}
