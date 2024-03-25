import 'package:aibridge/network/google_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as io;
import 'package:googleapis/drive/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path/path.dart';

import '../localdb/localdb.dart';

enum BackupStatus{
  uninitialized,
  initialized,
  isOnTask,
  failed,
  complete,
}

class GDriveProvider extends ChangeNotifier {

  BackupStatus _status = BackupStatus.uninitialized;
  BackupStatus get status => _status;

  DriveApi? driveApi;
  final SQFliteHelper localDB;

  GDriveProvider({
    required this.localDB,
  }){
    final key = dotenv.get("GOOGLE_API_ANDROID");
    driveApi = DriveApi(clientViaApiKey(key));
  }

  Future<void> setDrive(GoogleSignInAccount googleAuthData) async {
    final client = GoogleHttpClient(
        await googleAuthData.authHeaders
    );
    driveApi = DriveApi(client);
  }

  Future<File?> isFileExist(String displayName) async {
    final gDriveFile = File();
    gDriveFile.name = _fileName(displayName);
    final driveFileList = await driveApi!.files.list(
        q: "name = '${gDriveFile.name}'",
    );
    final files = driveFileList.files!;
    if (files.isNotEmpty) {
      return files.first;
    }
    return null;
  }

  Future<String?> _getFolderId() async {
    final mimeType = "application/vnd.google-apps.folder";
    String folderName = "AIBridge";

    final found = await driveApi!.files.list(
      q: "mimeType = '$mimeType' and name = '$folderName'",
      $fields: "files(id, name)",
    );
    final files = found.files;

    if (files == null) {
      return null;
    }

    if (files.isEmpty){
      File folder = File();
      folder.name = folderName;
      folder.mimeType = mimeType;
      final folderCreation = await driveApi!.files.create(folder);
      debugPrint("Folder ID: ${folderCreation.id}");
      return folderCreation.id;
    }

    return files.first.id;
  }

  // Future<void> upload(String displayName) async {
  //   debugPrint("executed");
  //   _setStatus(BackupStatus.initialized);
  //
  //   final dbPath = await localDB.getDBPath();
  //   final dbFile = io.File(dbPath);
  //   final gDriveFile = File();
  //   gDriveFile.name = _fileName(displayName);
  //
  //   final existingFile = await isFileExist(displayName);
  //
  //   _setStatus(BackupStatus.isOnTask);
  //   if(existingFile != null){
  //     try{
  //       await driveApi!.files.update(
  //           gDriveFile,
  //           existingFile.id!,
  //           uploadMedia: Media(dbFile.openRead(), dbFile.lengthSync())
  //       );
  //     } catch (err){
  //       _setStatus(BackupStatus.failed);
  //       debugPrint('G-Drive Error : $err');
  //     }
  //     _setStatus(BackupStatus.complete);
  //     return;
  //   }
  //
  //   try{
  //     await driveApi!.files.create(
  //         gDriveFile,
  //         uploadMedia: Media(dbFile.openRead(), dbFile.lengthSync())
  //     );
  //   } catch (err){
  //     _setStatus(BackupStatus.failed);
  //     debugPrint('G-Drive Error : $err');
  //   }
  //   _setStatus(BackupStatus.complete);
  // }

  Future<void> upload(GoogleSignInAccount auth) async {
    _setStatus(BackupStatus.initialized);
    await setDrive(auth);

    final dbPath = await localDB.getDBPath();
    final dbFile = io.File(dbPath);
    final gDriveFile = File();
    gDriveFile.name = _fileName(auth.displayName!);

    final folderId =  await _getFolderId();

    File fileToUpload = File();
    fileToUpload.parents = [folderId!];
    fileToUpload.name = basename(dbFile.absolute.path);

    _setStatus(BackupStatus.isOnTask);
    await driveApi!.files.create(
      fileToUpload,
      uploadMedia: Media(dbFile.openRead(), dbFile.lengthSync()),
    );

    _setStatus(BackupStatus.complete);
  }

  Future<void> download(String displayName) async{
    _setStatus(BackupStatus.initialized);

    final existingFile = await isFileExist(displayName);
    if(existingFile ==null){
      _setStatus(BackupStatus.failed);
      debugPrint('File not exist');
      return;
    }

    Media? gDriveFile;
    try {
      gDriveFile = await driveApi!.files.get(existingFile.id!,
          downloadOptions: DownloadOptions.fullMedia) as Media;
    } catch (err){
      _setStatus(BackupStatus.failed);
      debugPrint('G-Drive Error : $err');
    }

    if(gDriveFile==null){
      _setStatus(BackupStatus.failed);
      return;
    }

    await _overwriteLocalDB(gDriveFile);
    _setStatus(BackupStatus.complete);
  }

  String _fileName(String displayName){
    return 'AIBridge_$displayName';
  }

  Future<void> _overwriteLocalDB(Media gDriveFile) async {
    final dbPath = await localDB.getDBPath();
    final dbFile = io.File(dbPath);
    final allBytes = await gDriveFile.stream.expand((element) => element).toList();
    await dbFile.writeAsBytes(allBytes, flush: true);
  }

  void _setStatus(BackupStatus status){
    _status = status;
    notifyListeners();
  }

}