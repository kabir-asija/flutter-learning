import 'package:flutter/material.dart';
import 'package:weather_app/weather_api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherApi _weatherApi = WeatherApi();
  final TextEditingController _controller = TextEditingController();

  Map<String, dynamic>? weatherData;
  String error = '';
  bool isLoading = false;

  Future<void> fetchWeather() async {
    setState(() {
      isLoading = true;
      error = '';
      weatherData = null;
    });

    try {
      final locationData = await _weatherApi.getLocation(_controller.text);
      if (locationData['results'] == null) {
        throw 'City not found';
      }

      final lat = locationData['results'][0]['latitude'];
      final lon = locationData['results'][0]['longitude'];

      final data = await _weatherApi.getWeather(lat, lon);

      setState(() {
        weatherData = data;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade300,
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.all(10),
          child: const Text(
            'Weather App',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.amber.shade200,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                width: 300,
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Enter city name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: fetchWeather,
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.black,
                backgroundColor: const Color.fromARGB(255, 240, 188, 20),
              ),
              child: const Text(
                'Get Weather',
                style: TextStyle(color: Colors.black),
              ),
            ),

            const SizedBox(height: 20),

            if (isLoading) const CircularProgressIndicator(),

            if (error.isNotEmpty)
              Text(error, style: const TextStyle(color: Colors.red)),

            if (weatherData != null)
              Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    '${weatherData!['current_weather']['temperature']} °C',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Wind Speed: ${weatherData!['current_weather']['windspeed']} km/h',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
