import 'package:dio/dio.dart';
import 'package:smart_travel_planner/config/api_constant.dart';
import 'package:smart_travel_planner/models/images_model.dart';

class ImageService {
  final Dio _dio = Dio();

  Future<List<ImageModel>> searchImages(String query) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.unsplashBaseUrl}/search/photos',
        queryParameters: {
          'query': query,
          'per_page': 10,
        },
        options: Options(
          headers: {
            'Authorization': 'Client-ID ${ApiConstants.unsplashApiKey}',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final List results = response.data['results'];

        return results
            .map((json) => ImageModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Invalid Unsplash response');
      }
    } catch (e) {
      print('Unsplash API Error: $e');
      return [];
    }
  }
}
