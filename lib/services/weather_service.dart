import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey =
      "84bd587ceeab312b7561d32eb9986d72"; // Thay API key của bạn vào đây
  final String apiUrl = "https://api.openweathermap.org/data/2.5/weather";
  final String forecastUrl = "https://api.openweathermap.org/data/2.5/forecast";

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final response = await http.get(
      Uri.parse("$apiUrl?q=$city&appid=$apiKey&units=metric&lang=vi"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Không thể tải dữ liệu thời tiết");
    }
  }

  Future<List> fetchForecast(String city) async {
    final response = await http.get(
      Uri.parse("$forecastUrl?q=$city&appid=$apiKey&units=metric"),
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      return result["list"];
    } else {
      throw Exception("Không thể tải dữ liệu dự báo thời tiết");
    }
  }
}
