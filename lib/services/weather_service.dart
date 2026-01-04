import 'package:dio/dio.dart';
import 'package:smart_travel_planner/config/api_constant.dart';
import 'package:smart_travel_planner/models/weather_model.dart';

class WeatherService {
  final Dio _dio = Dio();

  Future<WeatherModel?> getWeather(String city) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.weatherBaseUrl}/weather',
        queryParameters: {
          'q': city,
          'appid': ApiConstants.weatherApiKey,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return WeatherModel.fromJson(response.data);
      } else {
        throw Exception('Invalid weather response');
      }
    } catch (e) {
      print('Weather API Error: $e');
      return null;
    }
  }
}
