import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file/file.dart';

class FileUploadServices {
  static Future<void> uploadAudioFile(String mobile, String idx, File audioFile, String filePath) async {
    var client = new http.Client();
    var uri = Uri.parse('http://dl1.youtubot.co.kr/lebengrida/save.php');

    try {
      // var map = Map<String, dynamic>();
      // map['action'] = _FILE_UPLOAD_ACTION;
      //
      // // convert file audio to Base64 encoding
      // List<int> audioBytes = audioFile.readAsBytesSync();
      // String baseAudio = base64Encode(audioBytes);
      // map['file'] = baseAudio;
      //
      // final response = await http.post(ROOT, body: map);

      http.MultipartRequest request = new http.MultipartRequest('POST', uri)
        ..fields['rbval1'] = mobile
        ..fields['rbval2'] = idx
        ..files.add(await http.MultipartFile.fromPath('rbfile', filePath));

      var response = await request.send();

      if (response.statusCode == 200) {
        print('File upload successful');
        // response.stream.toString();
      } else {
        print('File upload failed');
      }
    } catch(e) {
      throw Exception('Failed to file upload: $e');
    } finally {
      client.close();
    }
  }
}