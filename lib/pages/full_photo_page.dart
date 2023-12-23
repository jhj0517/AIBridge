import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../models/sqflite/character.dart';
import '../constants/color_constants.dart';

class FullPhotoPage extends StatelessWidget {
  final FullPhotoPageArguments arguments;

  const FullPhotoPage({Key? key, required this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          arguments.title,
          style: const TextStyle(
            color: ColorConstants.appbarTextColor
          ),
        ),
        backgroundColor: ColorConstants.appbarBackgroundColor,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: arguments.photoBLOB != null
        ? PhotoView(
            imageProvider: MemoryImage(arguments.photoBLOB!)
          )
        : PhotoView(
            imageProvider: NetworkImage(arguments.imageUrl!)
          )
    );
  }
}

class FullPhotoPageArguments {
  final String title;
  final Uint8List? photoBLOB;
  final String? imageUrl;

  FullPhotoPageArguments({required this.title, this.photoBLOB, this.imageUrl});
}