import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final String apiKey = "8df3dd77bef24506b5c140403250104"; // API Key
  final TextEditingController locationController = TextEditingController();
  double? temperature;
  String location = "Paris"; // Emplacement par défaut

  /// Fonction permettant de récupérer la température d'un lieu via l'API
  Future<void> fetchTemperature(String newLocation) async {
    final url = Uri.parse(
        "https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$newLocation");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          temperature = (data["current"]["temp_c"] as num?)?.toDouble();
          location = newLocation;
        });
      } else {
        debugPrint("Erreur API : Impossible de récupérer les données.");
      }
    } catch (e) {
      debugPrint("Erreur réseau : $e");
    }
  }

  /// Définition de la couleur de l'arrière-plan selon la température
  Color getBackgroundColor() {
    if (temperature == null) return Colors.grey;
    if (temperature! < 5) return Colors.blueAccent;
    if (temperature! < 20) return Colors.lightBlue;
    if (temperature! < 30) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Température Actuelle")),
        body: DecoratedBox(
          decoration: BoxDecoration(color: getBackgroundColor()),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: "Entrez un lieu",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (locationController.text.isNotEmpty) {
                      fetchTemperature(locationController.text);
                    }
                  },
                  child: const Text("Obtenir la température"),
                ),
                const SizedBox(height: 20),
                if (temperature != null)
                  Text(
                    "Température à $location : ${temperature!.toStringAsFixed(1)} °C",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  )
                else
                  const Text("Aucune donnée disponible", style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
