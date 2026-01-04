import 'package:dio/dio.dart';
import 'package:smart_travel_planner/config/api_constant.dart';
import 'package:smart_travel_planner/models/places_model.dart';

class PlacesService {
  final Dio _dio = Dio();

  Future<List<PlaceModel>> getPlaces({
    required String region,
    required List<String> interests,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.placesBaseUrl}/check',
        queryParameters: {'noqueue': 1},
        data: {
          "region": region,
          "language": "en",
          "interests": interests,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-rapidapi-host': ApiConstants.rapidApiHost,
            'x-rapidapi-key': ApiConstants.rapidApiKey,
          },
        ),
      );

      if (response.statusCode == 200 &&
          response.data != null &&
          response.data['result'] != null) {
        final List placesJson = response.data['result'];

        return placesJson
            .map((json) => PlaceModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Invalid API response');
      }
    } catch (e) {
      print('Places API Error: $e');
      return [];
    }
  }
}
