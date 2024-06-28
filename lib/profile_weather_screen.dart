import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:weather_app/main.dart';
import 'services/weather_service.dart';
import 'CityWeatherDetailScreen.dart';

class ProfileWeatherScreen extends StatelessWidget {
  final User? user;

  ProfileWeatherScreen(this.user);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.logout, color: Colors.red, size: 30),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Section
            ProfileSection(user: user),
            Divider(height: 1, color: Colors.grey),
            // Horizontal divider
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Weather',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(height: 4, color: Colors.grey),
            Expanded(
              child: Container(
                color: Colors.lightBlue[50],
                child: Consumer<WeatherProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 103, 143, 211),
                        ),
                      );
                    }
                    if (provider.errorMessage != null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              provider.errorMessage!,
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                            SizedBox(height: 10),
                            IconButton(
                              icon: Icon(Icons.refresh, color: Colors.blue, size: 30),
                              onPressed: () {
                                provider.fetchWeatherData();
                              },
                            ),
                          ],
                        ),
                      );
                    }
                    if (provider.weatherData == null) {
                      provider.fetchWeatherData();
                      return Center(
                        child: Text(
                          'No weather data available.',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: provider.weatherData!.length,
                      itemBuilder: (context, index) {
                        final weather = provider.weatherData![index];
                        return WeatherListItem(weatherData: weather);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherListItem extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  const WeatherListItem({required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        title: Text(
          'Country: ${weatherData['name']}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              'Weather: ${weatherData['weather'][0]['description']}',
              style: TextStyle(color: Colors.grey[700]),
            ),
            SizedBox(height: 4),
            Text(
              'Temperature: ${weatherData['main']['temp']} °C',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[700]), // Trailing icon for navigation
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CityWeatherDetailScreen(weatherData: weatherData),
            ),
          );
        },
      ),
    );
  }
}

class ProfileSection extends StatelessWidget {
  final User? user;

  ProfileSection({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.lightBlue[100], // Changed background color
        borderRadius: BorderRadius.circular(10), // Added rounded corners
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (user?.photoURL != null)
            CircleAvatar(
              backgroundImage: NetworkImage(user!.photoURL!),
              radius: 40,
            ),
          SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${user?.displayName ?? 'N/A'}',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(height: 8),
                Text(
                  'Email',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${user?.email ?? 'N/A'}',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherProvider with ChangeNotifier {
  List<Map<String, dynamic>>? weatherData;
  bool isLoading = false;
  String? errorMessage;

  void fetchWeatherData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      errorMessage = 'No network connection. Please check your internet connection.';
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final cities = [
        'New York', 'London', 'Tokyo', 'Delhi', 'Sydney',
        'Paris', 'Berlin', 'Moscow', 'Beijing', 'Rio de Janeiro',
        'Cairo', 'Rome', 'Madrid', 'Seoul', 'Toronto'
      ];
      weatherData = await WeatherService().fetchWeatherForCities(cities);
    } catch (error) {
      errorMessage = 'Failed to fetch weather data. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
