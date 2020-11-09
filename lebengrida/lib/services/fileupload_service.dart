import 'package:http/http.dart' as http;

class FileUploadServices {
  static Future<String> uploadAudioFile(String mobile, String idx, String filePath) async {
    var client = new http.Client();
    var uri = Uri.parse('http://dl1.youtubot.co.kr/lebenGrida/save.php');

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
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print('File upload successful');
        print('### response body -> $responseBody');
        return responseBody;
      } else {
        print('File upload failed');
        return 'File upload failed -> ${response.statusCode}';
      }
    } catch(e) {
      throw Exception('Failed to file upload: $e');
    } finally {
      client.close();
    }
  }
}