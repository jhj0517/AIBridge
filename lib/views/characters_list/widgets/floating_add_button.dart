import 'package:flutter/material.dart';

class FloatingAddButton extends StatelessWidget{

  final void Function() onTap;

  const FloatingAddButton({
    super.key,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onTap,
      backgroundColor: Colors.black,
      shape: const CircleBorder(),
      child: const Icon(
        color: Colors.white,
        Icons.add
      ),
    );
  }

}