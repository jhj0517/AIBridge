import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:native_exif/native_exif.dart';
import 'package:path/path.dart' as p;
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../models/models.dart';
import '../utils/utils.dart';
import '../localdb/localdb.dart';
import '../constants/path_constants.dart';

class ExifManager{

  static Future<Map<String, Object>?> readAttributes({
    required String imageFilePath
  }) async {
    try{
      Exif exif = await Exif.fromPath(imageFilePath);
      return await exif.getAttributes();
    } catch(e){
      debugPrint("readAttributes error : ${e}");
      return null;
    }
  }

  static Future<void> saveImageWithExif({
    required Character character
  }) async {
    try {
      final file = File(p.join(Directory.systemTemp.path, 'tempimage.png'));
      await file.create();
      await file.writeAsBytes(character.photoBLOB);

      Map<String, dynamic> characterMap = character.toMap();
      characterMap.remove(SQFliteHelper.charactersColumnCharacterPhotoBLOB);
      characterMap.remove(SQFliteHelper.charactersColumnCharacterBackgroundPhotoBLOB);

      final newExif = await Exif.fromPath(file.path);
      await newExif.writeAttributes({
        "UserComment": base64.encode(utf8.encode(json.encode(characterMap)))
      });
      debugPrint("saveImageWithExif exif : ${await readAttributes(imageFilePath: file.path)}");

      await ImageGallerySaver.saveFile(
        file.path,
        name: "${character.characterName}-${Utilities.getTimestamp()}"
      );
    } catch (e) {
      debugPrint("saveImageWithExif error : ${e}");
    }
  }

  static Future<Character?> decodeCharacter({
    required XFile? pickedFile
  }) async {
    try{
      Map<String, Object>? attributes = await readAttributes(imageFilePath: pickedFile!.path);
      final exifBase64 = attributes?["UserComment"] as String;

      final characterJson = json.decode(utf8.decode((base64.decode(exifBase64))));

      final File imageFile = File(pickedFile.path);
      final File compressedImageFile = await ImageConverter.compressImage(imageFile);
      Uint8List photoBLOB = await ImageConverter.convertImageToBLOB(compressedImageFile);
      Uint8List backgroundPhotoBLOB = await ImageConverter.convertAssetImageToBLOB(PathConstants.defaultCharacterBackgroundImage);
      characterJson.addAll({
        SQFliteHelper.charactersColumnCharacterPhotoBLOB: photoBLOB,
        SQFliteHelper.charactersColumnCharacterBackgroundPhotoBLOB: backgroundPhotoBLOB
      });

      return Character.fromMap(characterJson);
    } catch (e) {
      debugPrint("decodeCharacter error : ${e}");
      return null;
    }
  }

}