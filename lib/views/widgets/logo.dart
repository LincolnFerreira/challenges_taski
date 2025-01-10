import 'package:challenges_taski/views/widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final MainAxisAlignment logoAlignment;
  final double scale;
  const Logo(
      {super.key,
      this.logoAlignment = MainAxisAlignment.start,
      this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Row(
        mainAxisAlignment: logoAlignment,
        children: [
          CustomCheckbox(
            initialValue: true,
            onChanged: (value) => print(value),
            disableOnChanged: true,
          ),
          const SizedBox(width: 8),
          const Text('Taski',
              style: TextStyle(color: Colors.black, fontSize: 18)),
        ],
      ),
    );
  }
}
