import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:png_chunks_encode/png_chunks_encode.dart' as pngEncode;
import 'package:png_chunks_extract/png_chunks_extract.dart' as pngExtract;

import '../models/models.dart';
import '../utils/utils.dart';
import '../constants/path_constants.dart';

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
      return pngExtract.extractChunks(BLOB);
    } catch(e){
      debugPrint("readChunk error : ${e}");
      return null;
    }
  }

  static Future<bool> saveImageWithChunk({
    required Character character
  }) async {
    /*
    * Save new image with json character data as chunk data
    * ------------
    * character : Character data to add exif data in the image
    * Note : Only specific EXIF is writable in both Android and iOS. Using the key "UserComment" is safe for both OS. see more info: https://pub.dev/packages/native_exif
    * Note : Only temp image is EXIF editable, so you should make temp image -> edit EXIF -> move it to Gallery
    * ------------
    * returns a bool value that indicates whether the result was successful or not.
    * */
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
    /*
    * add tEXt type data in the chunk of the PNG.
    * ------------
    * originalChunk : original chunk data to add new data
    * keyword : keyword for the data
    * newValue : value for the data
    * ------------
    * returns list of new chunk data with tEXt data
    * */
    // Deep copy
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
    /*
    * Get character data from chunk data in the PNG.
    * ------------
    * pickedBLOB : picked image BLOB data with image picker
    * ------------
    * returns Character model data
    * */
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