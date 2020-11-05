import 'package:http/http.dart' as http;

class FileUploadServices {
  static Future<void> uploadAudioFile(String mobile, String idx, String filePath) async {
    var client = new http.Client();
    var uri = Uri.parse('http://dl1.youtubot.co.kr/lebengrida/save.php');

    try {
      print('### request post parameter ###');
      print('- mobile : $mobile');
      print('- idx : $idx');
      print('- filePath : $filePath');

      http.MultipartRequest request = new http.MultipartRequest('POST', uri)
        ..fields['rbval1'] = mobile
        ..fields['rbval2'] = idx
        ..files.add(await http.MultipartFile.fromPath('rbfile', filePath));

      var response = await request.send();

      if (response.statusCode == 200) {
        print('File upload successful');
        print('### response body -> ${await response.stream.bytesToString()}');
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