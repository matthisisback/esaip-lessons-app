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
      title: 'Capteur de Température & Humidité',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Capteur Température & Humidité'),
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
  double _temperature = 20.0;
  double _humidity = 50.0;
  bool _isActiveMode = true;
  late Timer _temperatureTimer;
  late Timer _humidityTimer;
  late Timer _serverQueryTimer;

  @override
  void initState() {
    super.initState();
    _startSimulation();
  }

  void _startSimulation() {
    _temperatureTimer = Timer.periodic(
      Duration(seconds: _isActiveMode ? 10 : 20),
      (timer) {
        setState(() {
          _temperature = Random().nextDouble() * 40; 
        });
        _sendDataToServer();
      },
    );

    _humidityTimer = Timer.periodic(
      Duration(seconds: _isActiveMode ? 20 : 50),
      (timer) {
        setState(() {
          _humidity = Random().nextDouble() * 100; 
        });
        _sendDataToServer();
      },
    );

    _serverQueryTimer = Timer.periodic(
      Duration(seconds: _isActiveMode ? 10 : 20),
      (timer) {
        _querySensorAttributes();
      },
    );
  }

  Future<void> _sendDataToServer() async {
    final response = await http.post(
      Uri.parse('https://example.com/api/sensor-data'),
      body: {
        'temperature': _temperature.toStringAsFixed(1),
        'humidity': _humidity.toStringAsFixed(0),
      },
    );

    if (response.statusCode == 200) {
      print('Données envoyées: Température: $_temperature°C, Humidité: $_humidity%');
    } else {
      print('Erreur lors de l\'envoi');
    }
  }

  Future<void> _querySensorAttributes() async {
    final response = await http.get(Uri.parse('https://example.com/api/sensor-attributes'));

    if (response.statusCode == 200) {
      print('Attributs du capteur récupérés.');
    } else {
      print('Erreur lors de la récupération des attributs.');
    }
  }

  void _toggleMode() {
    setState(() {
      _isActiveMode = !_isActiveMode;
      _temperatureTimer.cancel();
      _humidityTimer.cancel();
      _serverQueryTimer.cancel();
      _startSimulation();
    });
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

  @override
  void dispose() {
    _temperatureTimer.cancel();
    _humidityTimer.cancel();
    _serverQueryTimer.cancel();
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
            Text('${_temperature.toStringAsFixed(1)} °C', style: Theme.of(context).textTheme.headlineMedium),
            Slider(
              value: _temperature,
              min: 0,
              max: 40,
              divisions: 400,
              label: '${_temperature.toStringAsFixed(1)} °C',
              onChanged: _updateTemperature,
            ),

            const SizedBox(height: 20),
            
            const Text('Humidité actuelle:', style: TextStyle(fontSize: 18)),
            Text('${_humidity.toStringAsFixed(0)} %', style: Theme.of(context).textTheme.headlineMedium),
            Slider(
              value: _humidity,
              min: 0,
              max: 100,
              divisions: 100,
              label: '${_humidity.toStringAsFixed(0)} %',
              onChanged: _updateHumidity,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _toggleMode,
              child: Text(_isActiveMode ? 'Passer en mode veille' : 'Passer en mode actif'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: _sendDataToServer,
              child: const Text('Envoyer Température & Humidité'),
            ),

            const SizedBox(height: 20),
            const Text('Unités: °C et %'),
            Text(_isActiveMode ? 'Mode actif' : 'Mode veille', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
