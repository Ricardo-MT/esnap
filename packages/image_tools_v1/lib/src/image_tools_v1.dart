import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:image_tools/image_tools.dart';

/// {@template image_tools_v1}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class ImageToolsV1 extends ImageTools {
  /// {@macro image_tools_v1}
  ImageToolsV1({
    required this.removeBackgroundServiceUrl,
    required this.removeBackgroundServiceApiKey,
  }) {
    _httpClient = Dio();
  }

  /// The URL of the remove background service
  final String removeBackgroundServiceUrl;

  /// The API key for the remove background service
  final String removeBackgroundServiceApiKey;

  late Dio _httpClient;

  @override
  Future<Uint8List> removeBackground(Uint8List image) async {
    final response = await _httpClient.post<String>(
      removeBackgroundServiceUrl,
      options: Options(
        contentType: 'multipart/form-data',
        headers: {
          'x-api-key': removeBackgroundServiceApiKey,
          'accept': 'image/png, application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
      data: FormData.fromMap({
        'image': MultipartFile.fromBytes(
          image,
          filename: 'image.png',
        ),
      }),
    );
    final file = Uint8List.fromList(base64Decode(response.data!));
    return file;
  }
}
