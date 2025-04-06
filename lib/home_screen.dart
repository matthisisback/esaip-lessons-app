import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'client.dart';
import 'design.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String apiKey = "8df3dd77bef24506b5c140403250104"; // API météo

  double _temperature = 20.0;
  double _humidity = 50.0;
  double _cityTemperature = 20.0;
  String _city = "Paris";
  final TextEditingController _cityController = TextEditingController();
  late Timer _temperatureTimer, _humidityTimer;
  bool _isActiveMode = true; // Mode actif par défaut


  @override
  void initState() {
    super.initState();
    _fetchCityTemperature();
    _startSimulation();
  }

  // 🔹 Simulation des capteurs
  void _startSimulation() {
  _temperatureTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
    setState(() {
      // 🔹 La température varie uniquement de ±2° autour de la température réelle
      double variation = Random().nextBool() ? 2 : -2;
      _temperature = (_cityTemperature + variation).clamp(_cityTemperature - 2, _cityTemperature + 2);
    });
  });

  _humidityTimer = Timer.periodic(const Duration(seconds: 20), (timer) {
    setState(() {
      // 🔹 L'humidité varie uniquement de ±2% autour de l'humidité réelle
      double variation = Random().nextBool() ? 2 : -2;
      _humidity = (_humidity + variation).clamp(_humidity - 2, _humidity + 2);
    });
  });
}


  // 🔹 Récupération de la température réelle via API
  Future<void> _fetchCityTemperature() async {
    final url = Uri.parse("https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$_city");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _cityTemperature = (data["current"]["temp_c"] as num?)?.toDouble() ?? 20.0;
        });
      }
    } catch (e) {
      print("❌ Erreur API météo : $e");
    }
  }

  void _updateCity() {
    setState(() {
      _city = _cityController.text;
    });
    _fetchCityTemperature();
  }

  void _updateTemperature(double value) {
    setState(() {
      _temperature = value;
    });
  }

  void _updateHumidity(double value) {
    setState(() {
      _humidity = value;
    });
  }

  void _toggleMode() {
  setState(() {
    _isActiveMode = !_isActiveMode; // 🔄 Alterne entre mode actif et veille

    // 🔹 Annule les timers existants et relance la simulation si actif
    _temperatureTimer.cancel();
    if (_isActiveMode) {
      _startSimulation();
    }
  });
}



  void _sendDataToServer() {
    sendDataToServer(_temperature, _humidity);
  }

  @override
  void dispose() {
    _temperatureTimer.cancel();
    _humidityTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Capteur Température et Météo')),
      body: Column(
        children: [
          citySection(_city, _cityTemperature, _cityController, _updateCity),
          const Divider(thickness: 2),
          sensorSection(_temperature, _humidity, _isActiveMode, _updateTemperature, _updateHumidity, _toggleMode, _sendDataToServer),
        ],
      ),
    );
  }
}
