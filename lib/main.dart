import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String apiKey = "8df3dd77bef24506b5c140403250104";  //  API Key from WeatherAPI
  double? temperature;
  String city = "Paris"; // default Localisation choose to test the API 
  @override
  void initState() {
    super.initState();
    fetchTemperature();
  }
Future<void> fetchTemperature() async {
  final url = Uri.parse(
      "https://api.weatherapi.com/v1/current.json?key=8df3dd77bef24506b5c140403250104&q=Paris");

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        temperature = data["current"]["temp_c"];
      });
    } else {
      throw Exception("Impossible de récupérer les données");
    }
  } catch (e) {
    print("Erreur : $e");
  }
}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Température Actuelle")),
        body: Center(
          child: temperature != null
              ? Text("Température : ${temperature!.toStringAsFixed(1)} °C",
                  style: TextStyle(fontSize: 20))
              : Text("Chargement...", style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}

