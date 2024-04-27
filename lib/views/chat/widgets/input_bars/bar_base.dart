import 'package:flutter/material.dart';

abstract class BarBase extends StatelessWidget {
  final Future<void> Function()? onPressed;

  const BarBase({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: buildInputBar(context),
    );
  }

  Widget buildInputBar(BuildContext context);
}