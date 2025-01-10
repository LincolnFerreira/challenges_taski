import 'package:challenges_taski/core/theme/custom_color.dart';
import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;
  final bool isDisabled;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? checkColor;
  final Color? disabledColor;
  final bool disableOnChanged;

  const CustomCheckbox({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.isDisabled = false,
    this.activeColor = CustomColor.primary,
    this.inactiveColor = Colors.transparent,
    this.checkColor = Colors.white,
    this.disabledColor = Colors.grey,
    this.disableOnChanged = false,
  });

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  void _toggleCheckbox() {
    if (widget.isDisabled) return;

    setState(() {
      _isChecked = !_isChecked;
      if (!widget.disableOnChanged) {
        widget.onChanged(_isChecked);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          widget.isDisabled || widget.disableOnChanged ? null : _toggleCheckbox,
      child: Container(
        decoration: BoxDecoration(
          color: widget.isDisabled
              ? widget.disabledColor
              : (_isChecked ? widget.activeColor : widget.inactiveColor),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                _isChecked ? Colors.transparent : Colors.grey, // Cor da borda
            width: 2, // Espessura da borda
          ),
        ),
        width: 24,
        height: 24,
        child: _isChecked
            ? Icon(
                Icons.check,
                size: 18,
                color: widget.isDisabled ? Colors.white70 : widget.checkColor,
              )
            : null,
      ),
    );
  }
}
