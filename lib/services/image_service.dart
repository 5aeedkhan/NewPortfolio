import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ImageService {
  // ImgBB API key
  static const String _apiKey = '33d9e195e85ea1b11f6853ff2c331ac8';
  static const String _uploadUrl = 'https://api.imgbb.com/1/upload';

  Future<String> uploadImageBytes(Uint8List imageBytes) async {
    try {
      final base64Image = base64Encode(imageBytes);
      
      final response = await http.post(
        Uri.parse(_uploadUrl),
        body: {
          'key': _apiKey,
          'image': base64Image,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return data['data']['url'];
        } else {
          throw Exception('Failed to upload image: ${data['error']['message']}');
        }
      } else {
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }
} 