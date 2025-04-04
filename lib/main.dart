import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Capteur de Température',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Capteur Température'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _temperature = 20.0; // Température initiale
  bool _isActiveMode = true; // Mode actif ou veille
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTemperatureSimulation();
  }

  void _startTemperatureSimulation() {
    _timer = Timer.periodic(
      Duration(seconds: _isActiveMode ? 10 : 20),
      (timer) {
        setState(() {
          _temperature = Random().nextDouble() * 40; // Simulation entre 0 et 40°C
        });
        _sendTemperatureToServer();
      },
    );
  }

  Future<void> _sendTemperatureToServer() async {
    final response = await http.post(
      Uri.parse('https://example.com/api/temperature'), // Remplace par ton URL serveur
      body: {'temperature': _temperature.toStringAsFixed(1)}, // Respect de la précision 0.1°C
    );

    if (response.statusCode == 200) {
      print('Température envoyée: $_temperature°C');
    } else {
      print('Erreur lors de l\'envoi');
    }
  }

  void _toggleMode() {
    setState(() {
      _isActiveMode = !_isActiveMode;
      _timer.cancel();
      _startTemperatureSimulation();
    });
  }

  void _updateTemperature(double value) {
    setState(() {
      _temperature = value;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Température actuelle:', style: TextStyle(fontSize: 18)),
            Text(
              '${_temperature.toStringAsFixed(1)} °C', // Affichage avec précision 0.1°C
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            
            // Slider pour modifier la température
            Slider(
              value: _temperature,
              min: 0,
              max: 40,
              divisions: 400, // Précision de 0.1°C
              label: '${_temperature.toStringAsFixed(1)} °C',
              onChanged: _updateTemperature,
            ),
            
            const SizedBox(height: 20),

            // Bouton pour changer entre mode actif et veille
            ElevatedButton(
              onPressed: _toggleMode,
              child: Text(_isActiveMode ? 'Passer en mode veille' : 'Passer en mode actif'),
            ),
            
            const SizedBox(height: 10),

            // Bouton pour envoyer la température manuellement
            ElevatedButton(
              onPressed: _sendTemperatureToServer,
              child: const Text('Envoyer Température'),
            ),

            const SizedBox(height: 20),
            const Text('Unité: °C'),
            Text(_isActiveMode ? 'Mode actif (10 sec)' : 'Mode veille (20 sec)', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
