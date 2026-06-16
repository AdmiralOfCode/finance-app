import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_shadows.dart';

class NeumorphicCard extends StatelessWidget {
  const NeumorphicCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.color,
    this.shadows,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? color;
  final List<BoxShadow>? shadows;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color ?? AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(borderRadius ?? 20),
        boxShadow: shadows ?? AppShadows.neumorphicRaised,
      ),
      child: child,
    );
  }
}

class NeumorphicButton extends StatefulWidget {
  const NeumorphicButton({
    super.key,
    required this.child,
    required this.onTap,
    this.padding,
    this.borderRadius,
    this.color,
  });

  final Widget child;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? color;

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: widget.padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.color ?? AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 16),
          boxShadow:
              _isPressed ? AppShadows.neumorphicPressed : AppShadows.neumorphicRaised,
        ),
        child: widget.child,
      ),
    );
  }
}
