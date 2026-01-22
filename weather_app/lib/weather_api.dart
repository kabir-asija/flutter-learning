import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherApi {
  Future<Map<String, dynamic>> getLocation(String city) async {
    final url = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?name=$city&count=1',
    );

    final response = await http.get(url);
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getWeather(double lat, double lon) async {
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true',
    );

    final response = await http.get(url);
    return json.decode(response.body);
  }
}
