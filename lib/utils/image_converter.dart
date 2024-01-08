import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageConverter{
  static Future<Uint8List> convertImageToBLOB(File imageFile) async {
    Uint8List imageBytes = await imageFile.readAsBytes();
    return imageBytes;
  }

  static Future<Uint8List> convertAssetImageToBLOB(String assetPath) async {
    ByteData byteData = await rootBundle.load(assetPath);
    Uint8List imageBytes = byteData.buffer.asUint8List();
    return imageBytes;
  }

  static Future<File> compressImage(File imageFile) async {
    final Directory tempDir = await getTemporaryDirectory();
    final String targetPath = '${tempDir.path}/tempimage.png';

    final File? compressedImage = await FlutterImageCompress.compressAndGetFile(
      imageFile.path,
      targetPath,
      minHeight: 480,
      minWidth: 640,
      quality: 60,
    );

    return compressedImage!;
  }
}