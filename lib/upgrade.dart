import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

import 'package:package_info_plus/package_info_plus.dart';

Future<void> upgrade() async {
  // Get the release url
  final response = await http.get(Uri.parse('https://api.github.com/repos/oriolgds/Ors-News-Dart/releases'));
  final json = jsonDecode(response.body);

  final releaseURL = json[0]['assets_url'];

  final responseRelease = await http.get(Uri.parse(releaseURL));
  final jsonRelease = jsonDecode(responseRelease.body);

  for (final asset in jsonRelease){
    if(asset['name'] == 'app-release.apk'){
      debugPrint(asset['browser_download_url']);
      compareVersions('');
      //downloadTheFile(asset['browser_download_url']);
    }
  }
}

Future<bool> compareVersions(String cloudVersion) async {
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;
  debugPrint("The version is: $version");
  return true;
}

Future<void> downloadTheFile(String url) async {
  final Directory? tempDir = await getDownloadsDirectory();

  debugPrint(tempDir?.path);
  final taskId = await FlutterDownloader.enqueue(
    url: url,
    headers: {}, // optional: header send with url (auth token etc)
    savedDir: tempDir!.path,
    showNotification: true, // show download progress in status bar (for Android)
    openFileFromNotification: true, // c
    saveInPublicStorage: true// lick on notification to open downloaded file (for Android)
  );
  //final tasks = await FlutterDownloader.loadTasks();

}