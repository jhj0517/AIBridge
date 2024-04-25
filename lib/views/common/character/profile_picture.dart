import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../constants/color_constants.dart';

class ProfilePicture extends StatelessWidget {
  final double width;
  final double height;
  final Future<void> Function()? onPickImage;
  final String? photoURL;
  final Uint8List? imageBLOBData;
  final bool? isMutable;

  const ProfilePicture({
    super.key,
    required this.width,
    required this.height,
    this.imageBLOBData,
    this.photoURL,
    this.onPickImage,
    this.isMutable,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onPickImage,
          child: Material(
            color: Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(40)),
            clipBehavior: Clip.hardEdge,
            child: _buildPhoto(),
          ),
        ),
        isMutable != null && isMutable!
        ? Positioned(
          right: 0,
          bottom: 0,
          child: FloatingActionButton(
            mini: true,
            onPressed: () => onPickImage!(),
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.photo_library,
              color: ColorConstants.primaryColor,
            ),
          ),
        )
        : const SizedBox.shrink()
      ],
    );
  }

  Widget _buildPhoto(){
    if(photoURL?.isNotEmpty ?? false){
      return SizedBox(
        width: width,
        height: height,
        child: Image.network(
          photoURL!, // Replace with the actual URL of the image
          fit: BoxFit.cover,
          errorBuilder: (context, object, stackTrace) {
            return Icon(
              Icons.account_circle_rounded,
              size: width,
              color: ColorConstants.greyColor,
            );
          },
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) return child;
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: frame != null ? child : const CircularProgressIndicator(),
            );
          },
        ),
      );
    }

    if(imageBLOBData?.isNotEmpty ?? false){
      return SizedBox(
        width: width,
        height: height,
        child: Image.memory(
          imageBLOBData!,
          fit: BoxFit.cover,
          errorBuilder: (context, object, stackTrace) {
            return Icon(
              Icons.account_circle_rounded,
              size: width,
              color: ColorConstants.greyColor,
            );
          },
        ),
      );
    }

    return Icon(
      Icons.account_circle_rounded,
      size: width,
      color: ColorConstants.greyColor,
    );
  }
}
