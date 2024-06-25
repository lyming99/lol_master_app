import 'package:flutter/material.dart';

class HorizontalButtonWidget extends StatelessWidget {
  final Widget icon;
  final String? text;
  final VoidCallback? onPressed;

  const HorizontalButtonWidget({
    super.key,
    required this.icon,
    this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Row(
        children: [
          icon,
          const SizedBox(
            width: 4,
          ),
          Text(
            text ?? "",
            style: onPressed != null
                ? null
                : TextStyle(
                    color: Colors.grey.shade500,
                  ),
          ),
        ],
      ),
    );
  }
}
