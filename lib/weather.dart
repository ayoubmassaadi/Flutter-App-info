import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class Weather extends StatefulWidget {
  final String city;

  Weather({required this.city});

  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  List<dynamic> weatherData = [];

  Future<void> getData(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        setState(() {
          weatherData = json.decode(response.body)['list'];  // Assurez-vous que 'list' est correct pour les prévisions
        });
      } else {
        print('Failed to load weather data');
      }
    } catch (err) {
      print('Error: $err');
    }
  }

  @override
  void initState() {
    super.initState();
    // Modifiez pour utiliser /forecast pour correspondre à 'list'
    String apiKey = '59a7759723df548d48fed7234dde585a';
    String url = 'https://api.openweathermap.org/data/2.5/forecast?q=${widget.city}&appid=${apiKey}';
    print(url);
    getData(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.city),
        backgroundColor: Colors.orange,
      ),
      body: weatherData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: weatherData.length,
              itemBuilder: (context, index) {
                var weather = weatherData[index]['weather'][0];
                var main = weatherData[index]['main'];
                return Card(
                  color: Colors.deepOrangeAccent,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('images/${weather['main'].toLowerCase()}.png'),
                    ),
                    title: Text(DateFormat('E, dd MMM yyyy HH:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(weatherData[index]['dt'] * 1000))),
                    subtitle: Text("${weather['description']}"),
                    trailing: Text("${main['temp'].toStringAsFixed(1)} °C"),
                  ),
                );
              },
            ),
    );
  }
}
