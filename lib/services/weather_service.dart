import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = '66497fa66d431ef831ca8312be09fe4b';

  Future<Map<String, dynamic>> fetchWeather(String cityName) async {
    final url = 'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';

    try {
      // Make HTTP GET request
      final response = await http.get(Uri.parse(url));

      // Check if request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse JSON response
        return json.decode(response.body);
      } else {
        // Handle non-successful response (e.g., 404 Not Found, 401 Unauthorized)
        print('HTTP Error: ${response.statusCode}');
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or API call exceptions
      print('Exception during API call: $e');
      throw Exception('Failed to load weather data: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchWeatherForCities(List<String> cityNames) async {
    List<Map<String, dynamic>> weatherData = [];

    try {
      // Iterate over list of city names and fetch weather data for each
      for (String city in cityNames) {
        final data = await fetchWeather(city);
        weatherData.add(data);
      }
      return weatherData;
    } catch (e) {
      // Handle any exceptions that occur during fetching weather for cities
      print('Exception during fetching weather for cities: $e');
      throw Exception('Failed to load weather data for cities: $e');
    }
  }
}
