import 'package:flutter/material.dart';

class CustomButtonIconLabel extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final double fontSize;
  final double iconSize;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;

  const CustomButtonIconLabel({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.backgroundColor = const Color(0xFFDCE8F4),
    this.textColor = const Color(0xFF007FFF),
    this.iconColor = const Color(0xFF007FFF),
    this.fontSize = 16.0,
    this.iconSize = 20.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: iconSize,
        color: iconColor,
      ),
      label: Text(
        text,
        style: TextStyle(fontSize: fontSize, color: textColor),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        elevation: 0,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}
