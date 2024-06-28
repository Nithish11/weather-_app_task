import 'package:flutter/material.dart';

class CityWeatherDetailScreen extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  CityWeatherDetailScreen({required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(weatherData['name']),
      ),
      backgroundColor: _getBackgroundColor(weatherData['weather'][0]['main']),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCityName(),
            SizedBox(height: 16),
            _buildDetailCard(
              icon: _getWeatherIcon(weatherData['weather'][0]['main']),
              iconColor: _getWeatherIconColor(weatherData['weather'][0]['main']),
              title: 'Weather Description',
              value: '${weatherData['weather'][0]['description']}',
            ),
            _buildDetailCard(
              icon: Icons.thermostat_outlined,
              iconColor: Colors.orange,
              title: 'Temperature',
              value: '${weatherData['main']['temp']} °C',
            ),
            _buildDetailCard(
              icon: Icons.water_outlined,
              iconColor: Colors.blue,
              title: 'Humidity',
              value: '${weatherData['main']['humidity']} %',
            ),
            _buildDetailCard(
              icon: Icons.air_outlined,
              iconColor: Colors.green,
              title: 'Wind Speed',
              value: '${weatherData['wind']['speed']} m/s',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityName() {
    return Center(
      child: Column(
        children: [
          Text(
            weatherData['name'],
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Divider(
            color: Colors.grey[400],
            thickness: 2,
            height: 20,
            indent: 50,
            endIndent: 50,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard({required IconData icon, required Color iconColor, required String title, required String value}) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.2),
          foregroundColor: iconColor,
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          value,
          style: TextStyle(color: Colors.grey[700]),
        ),
      ),
    );
  }

  IconData _getWeatherIcon(String weatherMain) {
    switch (weatherMain) {
      case 'Clear':
        return Icons.wb_sunny;
      case 'Clouds':
        return Icons.cloud;
      case 'Rain':
        return Icons.grain;
      case 'Thunderstorm':
        return Icons.flash_on;
      case 'Snow':
        return Icons.ac_unit;
      default:
        return Icons.help_outline;
    }
  }

  Color _getWeatherIconColor(String weatherMain) {
    switch (weatherMain) {
      case 'Clear':
        return Colors.yellow;
      case 'Clouds':
        return Colors.grey;
      case 'Rain':
        return Colors.blue;
      case 'Thunderstorm':
        return Colors.deepPurple;
      case 'Snow':
        return Colors.lightBlueAccent;
      default:
        return Colors.black;
    }
  }

  Color? _getBackgroundColor(String weatherMain) {
    switch (weatherMain) {
      case 'Clear':
        return Colors.lightBlue[100]; 
      case 'Clouds':
        return Colors.grey[300]; 
      case 'Rain':
        return Colors.blue[200]; 
      case 'Thunderstorm':
        return Colors.deepPurple[200]; 
      case 'Snow':
        return Colors.lightBlue[50]; 
      default:
        return Colors.white; 
    }
  }
}
