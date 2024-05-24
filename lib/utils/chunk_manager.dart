import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:png_chunks_encode/png_chunks_encode.dart' as pngEncode;
import 'package:png_chunks_extract/png_chunks_extract.dart' as pngExtract;
import 'package:png_chunks_encode/src/etc32.dart';

import '../models/models.dart';
import '../utils/utils.dart';
import '../constants/path_constants.dart';

class ChunkManager{

  static List<Map<String, dynamic>>? readChunk({
    required Uint8List BLOB
  }) {
    try{
      return pngExtract.extractChunks(BLOB);
    } catch(e){
      debugPrint("readChunk error : ${e}");
      return null;
    }
  }

  static Future<bool> saveImageWithChunk({
    required Character character
  }) async {
    try {
      List<Map<String, dynamic>>? newChunks = readChunk(BLOB: character.photoBLOB);
      final v2Card = character.toV2Card();

      newChunks = addTextChunk(
          originalChunk: newChunks!,
          keyword: "chara",
          newValue: base64.encode(utf8.encode(json.encode(v2Card)))
      );
      final newBuffer = pngEncode.encodeChunks(newChunks);

      final file = File(p.join(Directory.systemTemp.path, 'tempimage.png'));
      await file.create();
      await file.writeAsBytes(newBuffer);

      await ImageGallerySaver.saveFile(
          file.path,
          name: "${character.characterName}",
      );
      return true;
    } catch (e) {
      debugPrint("saveImageWithChunk error : ${e}");
      return false;
    }
  }

  static List<Map<String, dynamic>> addTextChunk({
    required List<Map<String, dynamic>> originalChunk,
    required String keyword,
    required String newValue
  }) {
    List<Map<String, dynamic>> newChunks = List.from(
        originalChunk.map((chunk) => Map<String, dynamic>.from(chunk)),
        growable: true
    );
    bool chunkUpdated = false;

    for (var chunk in newChunks) {
      if (chunk['name'] == 'tEXt') {
        String existingData = utf8.decode(chunk['data']);
        if (existingData.startsWith(keyword)) {

          List<int> keywordBytes = utf8.encode(keyword);
          List<int> newTextBytes = utf8.encode(newValue);
          List<int> updatedData = [...keywordBytes, 0, ...newTextBytes];

          Uint8List chunkType = Uint8List.fromList(utf8.encode('tEXt'));
          Uint8List dataBytes = Uint8List.fromList(updatedData);
          Uint8List crcInput = Uint8List.fromList([...chunkType, ...dataBytes]);
          int newCrc = Crc32.getCrc32(crcInput);

          chunk['data'] = Uint8List.fromList(updatedData);
          chunk['crc'] = newCrc;
          chunkUpdated = true;
          break;
        }
      }
    }

    if (!chunkUpdated) {
      List<int> keywordBytes = utf8.encode(keyword);
      List<int> textBytes = utf8.encode(newValue);
      List<int> data = [...keywordBytes, 0, ...textBytes];

      Uint8List chunkType = Uint8List.fromList(utf8.encode('tEXt'));
      Uint8List dataBytes = Uint8List.fromList(data);
      Uint8List crcInput = Uint8List.fromList([...chunkType, ...dataBytes]);
      int crc = Crc32.getCrc32(crcInput);

      Map<String, dynamic> textChunk = {
        'name': 'tEXt',
        'data': Uint8List.fromList(data),
        'crc': crc
      };

      int iendIndex = newChunks.indexWhere((chunk) => chunk['name'] == 'IEND');
      newChunks.insert(iendIndex, textChunk);
    }
    return newChunks;
  }

  static Future<Character?> decodeCharacter({
    required File? pickedFile
  }) async {
    try{
      final pickedBLOB = await ImageConverter.convertImageToBLOB(pickedFile!);
      final List<Map<String, dynamic>>? chunks = readChunk(BLOB: pickedBLOB);
      for (var chunk in chunks!) {
        if (chunk['name'] == 'tEXt') {
          String encodedData = utf8.decode(chunk["data"]);
          String keyword = "chara";

          if (encodedData.startsWith(keyword)) {
            String base64Data = encodedData.substring(keyword.length + 1);
            final v2Map = json.decode(utf8.decode(base64.decode(base64Data)));
            final v2Card = V2.fromMap(v2Map);
            Uint8List backgroundPhotoBLOB = await ImageConverter.convertAssetImageToBLOB(PathConstants.charactersPageBackgroundImage);
            return Character.fromV2Card(
              v2Card: v2Card,
              backgroundPhotoBLOB: backgroundPhotoBLOB,
              photoBLOB: pickedBLOB
            );
          }
        }
      }
      debugPrint("no chunk data for v2 card has found");
      return null;
    } catch (e) {
      debugPrint("decodeCharacter error : ${e}");
      return null;
    }
  }
}