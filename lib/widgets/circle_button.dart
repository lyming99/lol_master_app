import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final double radius;
  final Widget? child;
  final VoidCallback? onTap;

  const CircleButton({
    super.key,
    this.child,
    this.radius = 10,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xfff6dba6)),
        borderRadius: BorderRadius.circular(radius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}
