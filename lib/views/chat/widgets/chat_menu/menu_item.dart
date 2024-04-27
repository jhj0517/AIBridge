import 'package:flutter/material.dart';

import 'package:aibridge/constants/color_constants.dart';

class MenuItem extends StatelessWidget {

  const MenuItem({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.iconPath
  });

  final String label;
  final void Function() onTap;
  final IconData? icon;
  final String? iconPath;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: double.infinity, // Take full width available in the cell
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon != null
              ? Icon(
                icon,
                color: ColorConstants.primaryColor
              )
              : SizedBox(
                width: 24,
                height: 24,
                child: Image(
                  fit: BoxFit.scaleDown,
                  image: AssetImage(iconPath!),
                ),
              ),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: ColorConstants.primaryColor
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}