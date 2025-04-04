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
  String apiKey = "8df3dd77bef24506b5c140403250104"; // API Key
  TextEditingController locationController = TextEditingController();
  double? temperature;
  String location = "Paris"; // Emplacement par défaut

  Future<void> fetchTemperature(String newLocation) async {
    final url = Uri.parse(
        "https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$newLocation");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          temperature = data["current"]["temp_c"];
          location = newLocation;
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
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: "Entrez un lieu",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (locationController.text.isNotEmpty) {
                    fetchTemperature(locationController.text);
                  }
                },
                child: Text("Obtenir la température"),
              ),
              SizedBox(height: 20),
              temperature != null
                  ? Text(
                      "Température à $location : ${temperature!.toStringAsFixed(1)} °C",
                      style: TextStyle(fontSize: 20),
                    )
                  : Text("Aucune donnée disponible",
                      style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
