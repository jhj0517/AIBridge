import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:png_chunks_encode/png_chunks_encode.dart' as pngEncode;

import '../models/models.dart';
import '../utils/utils.dart';
import '../localdb/localdb.dart';
import '../constants/path_constants.dart';

// Tavern은 keyword 가 chara 다.
// Risu는 keyword가 persona 다.

class ChunkManager{

  static List<Map<String, dynamic>>? readChunk({
    required Uint8List BLOB
  }) {
    /*
    * BLOB : bytes data of the image
    * -------
    * returns List of the chunk data
    * */
    try{
      return extractChunks(BLOB);
    } catch(e){
      debugPrint("readChunk error : ${e}");
      return null;
    }
  }

  /*
  RisuAI Template
  {"spec":"chara_card_v2","spec_version":"2.0","data":{"name":"Sooah","description":"<char> is 24 years old girl. \n<char> likes to dominate and order someone around.\n<char> has a small height of 155 cm.\n<char> has a complex about her short stature and is quite concerned that someone will look down on her for it.\nIf someone belittles <char> about <char>'s height, <char> will never let that person get away with it. <char> will try to dominate them by trampling them.\n<char> is definitely sparing when it comes to people she loves or is close to.","personality":"","scenario":"","first_mes":"Hello, What's the matter.","mes_example":"","creator_notes":"","system_prompt":"","post_history_instructions":"","alternate_greetings":[],"character_book":{"extensions":{"risu_fullWordMatching":false},"entries":[]},"tags":[],"creator":"","character_version":"","extensions":{"risuai":{"emotions":[],"bias":[],"viewScreen":"none","customScripts":[],"utilityBot":false,"sdData":[["always","solo, 1girl"],["negative",""],["|character's appearance",""],["current situation",""],["$character's pose",""],["$character's emotion",""],["current location",""]],"triggerscript":[],"additionalText":"","largePortrait":false,"lorePlus":true,"newGenData":{"prompt":"","negative":"","instructions":"","emotionInstructions":""}},"depth_prompt":{"depth":0,"prompt":""}}}}
   */

  /*
  TavernAI Template
  {"name":"Character A","description":"She's sooo cute","personality":"summary","scenario":"scenario","first_mes":"Hi","mes_example":"","creatorcomment":"","avatar":"none","chat":"Character A - 2024-1-4 @19h 06m 48s 518ms","talkativeness":"0.5","fav":false,"spec":"chara_card_v2","spec_version":"2.0","data":{"name":"Character A","description":"She's sooo cute","personality":"summary","scenario":"scenario","first_mes":"Hi","mes_example":"","creator_notes":"","system_prompt":"","post_history_instructions":"","tags":[],"creator":"","character_version":"","alternate_greetings":[],"extensions":{"talkativeness":"0.5","fav":false,"world":"","depth_prompt":{"prompt":"note","depth":4}}},"create_date":"2024-1-4 @19h 06m 48s 932ms"}
  * */

  static Future<void> saveImageWithChunk({
    required Character character
  }) async {
    /*
    * Save new image with json character data as chunk data
    * character : Character data to add exif data in the image
    * Note : Only specific EXIF is writable in both Android and iOS. Using the key "UserComment" is safe for both OS. see more info: https://pub.dev/packages/native_exif
    * Note : Only temp image is EXIF editable, so you should make temp image -> edit EXIF -> move it to Gallery
    * */
    try {
      Map<String, dynamic> characterMap = character.toMap();
      characterMap.remove(SQFliteHelper.charactersColumnCharacterPhotoBLOB);
      characterMap.remove(SQFliteHelper.charactersColumnCharacterBackgroundPhotoBLOB);

      final newChunks = readChunk(BLOB: character.photoBLOB);
      debugPrint("saveImageWithChunk newChunks ${newChunks!.length}");
      debugPrint("saveImageWithChunk newChunks ${newChunks}");
      printChunkNames(newChunks);
      updateChunk(originalChunk: newChunks, key: "chara", value: "example");
      final newBuffer = pngEncode.encodeChunks(newChunks!);
      debugPrint("saveImageWithChunk updatedChunks ${newChunks.length}");
      debugPrint("saveImageWithChunk updatedChunks ${newChunks}");
      printChunkNames(newChunks);

      final file = File(p.join(Directory.systemTemp.path, 'tempimage.png'));
      await file.create();
      await file.writeAsBytes(newBuffer);

      await ImageGallerySaver.saveFile(
          file.path,
          name: "${character.characterName}"
      );
    } catch (e) {
      debugPrint("saveImageWithChunk error : ${e}");
    }
  }

  static Future<void> testChunk({
    required Character character
  }) async {
    /*
    * Save new image with json character data as chunk data
    * */
    try {
      Map<String, dynamic> characterMap = character.toMap();
      characterMap.remove(SQFliteHelper.charactersColumnCharacterPhotoBLOB);
      characterMap.remove(SQFliteHelper.charactersColumnCharacterBackgroundPhotoBLOB);

      final newChunks = readChunk(BLOB: character.photoBLOB);
      debugPrint("saveImageWithChunk newChunks ${newChunks!.length}");
      debugPrint("saveImageWithChunk newChunks ${newChunks}");
      printChunkNames(newChunks);
    } catch (e) {
      debugPrint("saveImageWithChunk error : ${e}");
    }
  }

  static updateChunk({
    required originalChunk,
    required String key,
    required String value
  }){
    Uint8List newValue = Uint8List.fromList(utf8.encode(value));
    bool chunkFound = false;

    for (var chunk in originalChunk) {
      if (chunk['name'] == key) {
        // Update the chunk data
        chunk['data'] = newValue;

        // Recalculate CRC
        List<int> crcInput = List.from(Uint8List.fromList(utf8.encode(key)))..addAll(newValue);
        chunk['crc'] = Crc32.getCrc32(crcInput);

        chunkFound = true;
        break;
      }
    }

    if (!chunkFound) {
      List<int> crcInput = List.from(Uint8List.fromList(utf8.encode(key)))..addAll(newValue);
      int crc = Crc32.getCrc32(crcInput);

      Map<String, dynamic> newChunk = {
        'name': key,
        'data': newValue,
        'crc': crc,
      };
      originalChunk.insert(originalChunk.length - 1, newChunk);
    }
  }

  static printChunkNames(List<Map<String, dynamic>> chunks) {
    debugPrint("chunk");
    for (var chunk in chunks) {
      if (chunk.containsKey('name')) {
        debugPrint(chunk['name']);
      }
    }
  }

  static List<Map<String, dynamic>> extractChunks(Uint8List data) {
    var uint8 = Uint8List(4);
    var int32 = Int32List.view(uint8.buffer);
    var uint32 = Uint32List.view(uint8.buffer);

    // if (data[0] != 0x89) throw ArgumentError('Invalid .png file header 0x89');
    // if (data[1] != 0x50) throw ArgumentError('Invalid .png file header 0x50');
    // if (data[2] != 0x4E) throw ArgumentError('Invalid .png file header 0x4E');
    // if (data[3] != 0x47) throw ArgumentError('Invalid .png file header 0x47');
    // if (data[4] != 0x0D) {
    //   throw ArgumentError(
    //       'Invalid .png file header: possibly caused by DOS-Unix line ending conversion?');
    // }
    // if (data[5] != 0x0A) {
    //   throw ArgumentError(
    //       'Invalid .png file header: possibly caused by DOS-Unix line ending conversion?');
    // }
    // if (data[6] != 0x1A) throw ArgumentError('Invalid .png file header');
    // if (data[7] != 0x0A) {
    //   throw ArgumentError(
    //       'Invalid .png file header: possibly caused by DOS-Unix line ending conversion?');
    // }

    var ended = false;
    var chunks = <Map<String, dynamic>>[];
    var idx = 8;

    while (idx < data.length) {
      // Read the length of the current chunk,
      // which is stored as a Uint32.
      uint8[3] = data[idx++];
      uint8[2] = data[idx++];
      uint8[1] = data[idx++];
      uint8[0] = data[idx++];

      // Chunk includes name/type for CRC check (see below).
      var length = uint32[0] + 4;
      var chunk = Uint8List(length);
      chunk[0] = data[idx++];
      chunk[1] = data[idx++];
      chunk[2] = data[idx++];
      chunk[3] = data[idx++];

      // Get the name in ASCII for identification.
      var name = (String.fromCharCode(chunk[0]) +
          String.fromCharCode(chunk[1]) +
          String.fromCharCode(chunk[2]) +
          String.fromCharCode(chunk[3]));

      // The IHDR header MUST come first.
      if (chunks.isEmpty && name != 'IHDR') {
        throw UnsupportedError('IHDR header missing');
      }

      // The IEND header marks the end of the file,
      // so on discovering it break out of the loop.
      if (name == 'IEND') {
        ended = true;
        chunks.add({
          'name': name,
          'data': Uint8List(0),
        });

        break;
      }

      // Read the contents of the chunk out of the main buffer.
      for (var i = 4; i < length; i++) {
        chunk[i] = data[idx++];
      }

      // Read out the CRC value for comparison.
      // It's stored as an Int32.
      uint8[3] = data[idx++];
      uint8[2] = data[idx++];
      uint8[1] = data[idx++];
      uint8[0] = data[idx++];

      var crcActual = int32[0];
      var crcExpect = Crc32.getCrc32(chunk);
      if (crcExpect != crcActual) {
        throw UnsupportedError(
            'CRC values for $name header do not match, PNG file is likely corrupted');
      }

      // The chunk data is now copied to remove the 4 preceding
      // bytes used for the chunk name/type.

      var chunkData = Uint8List.fromList(chunk.sublist(4));

      chunks.add({'name': name, 'data': chunkData});
    }

    if (!ended) {
      throw UnsupportedError(
          '.png file ended prematurely: no IEND header was found');
    }

    return chunks;
  }


// static Future<Character?> decodeCharacter({
  //   required XFile? pickedFile
  // }) async {
  //   /*
  //   * Get character data from exif data in the image.
  //   * pickedFile : picked image file with image picker
  //   * -------
  //   * returns Character model data
  //   * */
  //   try{
  //     Map<String, Object>? attributes = await readAttributes(imageFilePath: pickedFile!.path);
  //     final exifBase64 = attributes?["UserComment"] as String;
  //
  //     final characterJson = json.decode(utf8.decode((base64.decode(exifBase64))));
  //
  //     final File imageFile = File(pickedFile.path);
  //     final File compressedImageFile = await ImageConverter.compressImage(imageFile);
  //     Uint8List photoBLOB = await ImageConverter.convertImageToBLOB(compressedImageFile);
  //     Uint8List backgroundPhotoBLOB = await ImageConverter.convertAssetImageToBLOB(PathConstants.defaultCharacterBackgroundImage);
  //     characterJson.addAll({
  //       SQFliteHelper.charactersColumnCharacterPhotoBLOB: photoBLOB,
  //       SQFliteHelper.charactersColumnCharacterBackgroundPhotoBLOB: backgroundPhotoBLOB
  //     });
  //
  //     return Character.fromMap(characterJson);
  //   } catch (e) {
  //     debugPrint("decodeCharacter error : ${e}");
  //     return null;
  //   }
  // }

}

class Crc32 {
  /// Calculate a CRC32 value for the given input.
  ///
  /// The return value is an unsigned integer.
  ///
  /// You may optionally specify the beginning CRC value.
  static int getCrc32(List<int> array, [int crc = 0]) {
    var len = array.length;
    crc = crc ^ 0xffffffff;
    var ip = 0;
    while (len >= 8) {
      crc = _crc32Table[(crc ^ array[ip++]) & 0xff] ^ (crc >> 8);
      crc = _crc32Table[(crc ^ array[ip++]) & 0xff] ^ (crc >> 8);
      crc = _crc32Table[(crc ^ array[ip++]) & 0xff] ^ (crc >> 8);
      crc = _crc32Table[(crc ^ array[ip++]) & 0xff] ^ (crc >> 8);
      crc = _crc32Table[(crc ^ array[ip++]) & 0xff] ^ (crc >> 8);
      crc = _crc32Table[(crc ^ array[ip++]) & 0xff] ^ (crc >> 8);
      crc = _crc32Table[(crc ^ array[ip++]) & 0xff] ^ (crc >> 8);
      crc = _crc32Table[(crc ^ array[ip++]) & 0xff] ^ (crc >> 8);
      len -= 8;
    }
    if (len > 0) {
      do {
        crc = _crc32Table[(crc ^ array[ip++]) & 0xff] ^ (crc >> 8);
      } while (--len > 0);
    }
    final int32List = Int32List.fromList([crc ^ 0xffffffff]);
    return int32List[0];
  }

  static final List<int> _crc32Table = ([
    0,
    1996959894,
    3993919788,
    2567524794,
    124634137,
    1886057615,
    3915621685,
    2657392035,
    249268274,
    2044508324,
    3772115230,
    2547177864,
    162941995,
    2125561021,
    3887607047,
    2428444049,
    498536548,
    1789927666,
    4089016648,
    2227061214,
    450548861,
    1843258603,
    4107580753,
    2211677639,
    325883990,
    1684777152,
    4251122042,
    2321926636,
    335633487,
    1661365465,
    4195302755,
    2366115317,
    997073096,
    1281953886,
    3579855332,
    2724688242,
    1006888145,
    1258607687,
    3524101629,
    2768942443,
    901097722,
    1119000684,
    3686517206,
    2898065728,
    853044451,
    1172266101,
    3705015759,
    2882616665,
    651767980,
    1373503546,
    3369554304,
    3218104598,
    565507253,
    1454621731,
    3485111705,
    3099436303,
    671266974,
    1594198024,
    3322730930,
    2970347812,
    795835527,
    1483230225,
    3244367275,
    3060149565,
    1994146192,
    31158534,
    2563907772,
    4023717930,
    1907459465,
    112637215,
    2680153253,
    3904427059,
    2013776290,
    251722036,
    2517215374,
    3775830040,
    2137656763,
    141376813,
    2439277719,
    3865271297,
    1802195444,
    476864866,
    2238001368,
    4066508878,
    1812370925,
    453092731,
    2181625025,
    4111451223,
    1706088902,
    314042704,
    2344532202,
    4240017532,
    1658658271,
    366619977,
    2362670323,
    4224994405,
    1303535960,
    984961486,
    2747007092,
    3569037538,
    1256170817,
    1037604311,
    2765210733,
    3554079995,
    1131014506,
    879679996,
    2909243462,
    3663771856,
    1141124467,
    855842277,
    2852801631,
    3708648649,
    1342533948,
    654459306,
    3188396048,
    3373015174,
    1466479909,
    544179635,
    3110523913,
    3462522015,
    1591671054,
    702138776,
    2966460450,
    3352799412,
    1504918807,
    783551873,
    3082640443,
    3233442989,
    3988292384,
    2596254646,
    62317068,
    1957810842,
    3939845945,
    2647816111,
    81470997,
    1943803523,
    3814918930,
    2489596804,
    225274430,
    2053790376,
    3826175755,
    2466906013,
    167816743,
    2097651377,
    4027552580,
    2265490386,
    503444072,
    1762050814,
    4150417245,
    2154129355,
    426522225,
    1852507879,
    4275313526,
    2312317920,
    282753626,
    1742555852,
    4189708143,
    2394877945,
    397917763,
    1622183637,
    3604390888,
    2714866558,
    953729732,
    1340076626,
    3518719985,
    2797360999,
    1068828381,
    1219638859,
    3624741850,
    2936675148,
    906185462,
    1090812512,
    3747672003,
    2825379669,
    829329135,
    1181335161,
    3412177804,
    3160834842,
    628085408,
    1382605366,
    3423369109,
    3138078467,
    570562233,
    1426400815,
    3317316542,
    2998733608,
    733239954,
    1555261956,
    3268935591,
    3050360625,
    752459403,
    1541320221,
    2607071920,
    3965973030,
    1969922972,
    40735498,
    2617837225,
    3943577151,
    1913087877,
    83908371,
    2512341634,
    3803740692,
    2075208622,
    213261112,
    2463272603,
    3855990285,
    2094854071,
    198958881,
    2262029012,
    4057260610,
    1759359992,
    534414190,
    2176718541,
    4139329115,
    1873836001,
    414664567,
    2282248934,
    4279200368,
    1711684554,
    285281116,
    2405801727,
    4167216745,
    1634467795,
    376229701,
    2685067896,
    3608007406,
    1308918612,
    956543938,
    2808555105,
    3495958263,
    1231636301,
    1047427035,
    2932959818,
    3654703836,
    1088359270,
    936918000,
    2847714899,
    3736837829,
    1202900863,
    817233897,
    3183342108,
    3401237130,
    1404277552,
    615818150,
    3134207493,
    3453421203,
    1423857449,
    601450431,
    3009837614,
    3294710456,
    1567103746,
    711928724,
    3020668471,
    3272380065,
    1510334235,
    755167117
  ]);
}