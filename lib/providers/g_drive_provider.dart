import 'package:aibridge/network/google_api.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:googleapis/drive/v3.dart';
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

  static const folderName = "AIBridge";
  static const folderMime = "application/vnd.google-apps.folder";

  BackupStatus _status = BackupStatus.uninitialized;
  BackupStatus get status => _status;

  DriveApi? driveApi;

  final SQFliteHelper localDB;

  GDriveProvider({
    required this.localDB,
  }){}

  Future<void> _setDrive(GoogleSignInAccount googleAuthData) async {
    final client = GoogleHttpClient(
        await googleAuthData.authHeaders
    );
    driveApi = DriveApi(client);
  }

  Future<void> upload(GoogleSignInAccount auth) async {
    _setStatus(BackupStatus.initialized);
    await _setDrive(auth);

    final dbFile = await localDB.getDBFile();

    final File gDriveFile = File();
    gDriveFile.name = basename(dbFile.absolute.path);

    final existingFile = await _isFileExist(gDriveFile.name!);

    _setStatus(BackupStatus.isOnTask);
    if (existingFile != null){
      try{
        await driveApi!.files.update(
            gDriveFile,
            existingFile.id!,
            uploadMedia: Media(dbFile.openRead(), dbFile.lengthSync())
        );
      } catch (err){
        _setStatus(BackupStatus.failed);
        debugPrint('G-Drive Error : $err');
      }
      _setStatus(BackupStatus.complete);
      return;
    }

    final folderId =  await _folderId();
    gDriveFile.parents = [folderId!];

    try{
      await driveApi!.files.create(
        gDriveFile,
        uploadMedia: Media(dbFile.openRead(), dbFile.lengthSync()),
      );
    } catch (err){
      _setStatus(BackupStatus.failed);
      debugPrint('G-Drive Error : $err');
    }
    _setStatus(BackupStatus.complete);
  }

  Future<void> download(GoogleSignInAccount auth) async{
    _setStatus(BackupStatus.initialized);
    await _setDrive(auth);

    final dbFile = await localDB.getDBFile();

    final File gDriveFile = File();
    gDriveFile.name = basename(dbFile.absolute.path);

    final existingFile = await _isFileExist(gDriveFile.name!);

    if(existingFile ==null){
      _setStatus(BackupStatus.failed);
      return;
    }

    _setStatus(BackupStatus.isOnTask);
    Media? downloadedFile;
    try {
      downloadedFile = await driveApi!.files.get(
          existingFile.id!,
          downloadOptions: DownloadOptions.fullMedia
      ) as Media;
    } catch (err){
      _setStatus(BackupStatus.failed);
      debugPrint('G-Drive Error : $err');
    }

    if(downloadedFile==null){
      _setStatus(BackupStatus.failed);
      return;
    }

    await _overwriteLocalDB(downloadedFile);
    _setStatus(BackupStatus.complete);
  }

  Future<File?> _isFileExist(String fileName) async {
    final folderId =  await _folderId();
    if (folderId == null){
      return null;
    }

    final query = "name = '$fileName' and '$folderId' in parents and trashed = false";
    final driveFileList = await driveApi!.files.list(
      q: query,
      spaces: 'drive',
      $fields: 'files(id, name, mimeType, parents)',
    );

    if (driveFileList.files == null || driveFileList.files!.isEmpty) {
      return null;
    }

    return driveFileList.files!.first;
  }

  Future<String?> _folderId() async {
    final found = await driveApi!.files.list(
      q: "mimeType = '$folderMime' and name = '$folderName'",
      $fields: "files(id, name)",
    );
    final files = found.files;

    if (files == null) {
      return null;
    }
    if (files.isEmpty){
      final newFolder = await _createNewFolder();
      return newFolder.id;
    }

    return files.first.id;
  }

  Future<File> _createNewFolder() async{
    final File folder = File();
    folder.name = folderName;
    folder.mimeType = folderMime;
    return await driveApi!.files.create(folder);
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