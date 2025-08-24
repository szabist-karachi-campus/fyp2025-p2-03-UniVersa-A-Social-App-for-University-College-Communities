// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart';

import '../../../app/app.locator.dart';
import '../../../services/fire_service.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

import 'apihelper.dart';

class FirebaseHelper {
  static Future<String> uploadFile(File? file, String phone) async {
    final fireService = locator<FireService>();

    String filename = path.basename(file!.path);
    String extension = path.extension(file.path);
    String randomChars = DateTime.now().millisecondsSinceEpoch.toString();
    String uniqueFilename = '$filename-$randomChars$extension';

    UploadTask uploadTask = fireService.storage
        .child('user')
        .child(phone)
        .child(uniqueFilename)
        .putFile(file);
    await uploadTask;
    String downloadURL = await fireService.storage
        .child('user')
        .child(phone)
        .child(uniqueFilename)
        .getDownloadURL();
    return downloadURL;
  }

  static Future<void> sendallnotification(String title, String des) async {
    List datauser = await ApiHelper.allusers();
    datauser.forEach((element) async {
      FirebaseHelper.sendPushMessage(element['deviceid'], title, des);
    });
  }

  
}
