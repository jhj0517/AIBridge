import 'package:flutter/material.dart';

class DeleteCheckBox extends StatelessWidget {
  const DeleteCheckBox({
    super.key,
    required this.isChecked,
  });

  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Theme(
        data: ThemeData(
          unselectedWidgetColor: Theme.of(context).textTheme.bodyMedium!.color,
        ),
        child: Checkbox(
          shape: const CircleBorder(),
          value: isChecked,
          onChanged: (bool? newValue) {},
        ),
      ),
    );
  }
}