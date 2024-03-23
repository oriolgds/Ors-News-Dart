import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:open_file/open_file.dart';

Future<bool> upgrade() async {
  // Get the release url
  final response = await http.get(Uri.parse('https://api.github.com/repos/oriolgds/Ors-News-Dart/releases'));
  final json = jsonDecode(response.body);

  final releaseURL = json[0]['assets_url'];
  final releaseVersion = json[0]['name'];
  final responseRelease = await http.get(Uri.parse(releaseURL));
  final jsonRelease = jsonDecode(responseRelease.body);

  for (final asset in jsonRelease){
    if(asset['name'] == 'app-release.apk'){
      debugPrint(asset['browser_download_url']);
      if((await compareVersions(releaseVersion))){
        downloadTheFile(asset['browser_download_url']);
        return true;
      }

    }
  }
  return false;
}

Future<bool> compareVersions(String cloudVersion) async {
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  final String version = packageInfo.version;
  debugPrint("The version is: $version");
  return cloudVersion == version;
}

Future<void> downloadTheFile(String url) async {
  final Directory tempDir = await getTemporaryDirectory();

  debugPrint(tempDir.path);
  final taskId = await FlutterDownloader.enqueue(
    url: url,
    headers: {}, // optional: header send with url (auth token etc)
    savedDir: tempDir.path,
    showNotification: true, // show download progress in status bar (for Android)
    openFileFromNotification: true, // c
    saveInPublicStorage: true// lick on notification to open downloaded file (for Android)
  );
  final allDownloadTasks = await FlutterDownloader.loadTasks();

  var allCompleted = true;
  for (final downloadTask in allDownloadTasks!) {
    if (downloadTask.status == DownloadTaskStatus.complete) {
      debugPrint('this task is finished');
    } else {
      allCompleted = false;
    }

    if (allCompleted) {
      debugPrint('all downloads are complete');

      if (taskId != null) {
        FlutterDownloader.open(taskId: taskId);
      }
    }

    if (taskId != null) {
      FlutterDownloader.open(taskId: taskId);
      OpenFile.open("${tempDir.path}/apk-release.apk");
    }

    //final tasks = await FlutterDownloader.loadTasks();
  }
}