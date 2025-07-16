import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherApi {
  static const String baseUrl = 'http://192.168.38.126:3000/weather'; //

  static Future<List<dynamic>> getHourlyWeather(String city) async {
    final uri = Uri.parse('$baseUrl/hourly?city=$city&cnt=24');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['forecast']; //
    } else {
      throw Exception('Failed to load hourly weather');
    }
  }

  static Future<List<dynamic>> getDailyWeather(String city) async {
    final uri = Uri.parse('$baseUrl/daily?city=$city');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['forecast'];
    } else {
      throw Exception('Failed to load daily forecast');
    }
  }
}
