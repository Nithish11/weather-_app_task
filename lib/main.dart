import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'google_sign_in_button.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50], // Light blue background
      appBar: AppBar(
        title: Text('Welcome to Weather App '),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Image.asset(
                'assets/w_logo1.png', 
                height: 120,
                width: 120,
              ),
              SizedBox(height: 20),
              Text(
                'Weather App',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Stay updated with the latest weather information.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blueGrey[700],
                ),
              ),
              SizedBox(height: 40),
              GoogleSignInButton(),
              SizedBox(height: 40),
              Text(
                'How to Use the App',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              SizedBox(height: 10),
              Text(
                '1. Sign in with your Google account\n'
                '2. View your profile and weather information on the same screen\n'
                '3. Click on a city to see detailed weather information',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueGrey[700],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Enjoy your day!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
