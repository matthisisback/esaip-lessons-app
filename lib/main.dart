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
      home: const MyHomePage(title: 'Capteur de Température - Interface Technicien'),
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
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTemperatureSimulation();
  }

  void _startTemperatureSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
      setState(() {
        _temperature = Random().nextDouble() * 40; // Simulation entre 0 et 40°C
      });
      _sendTemperatureToServer();
    });
  }

  Future<void> _sendTemperatureToServer() async {
    final response = await http.post(
      Uri.parse('https://example.com/api/temperature'), // Remplace par ton URL serveur
      body: {'temperature': _temperature.toString()},
    );

    if (response.statusCode == 200) {
      print('Température envoyée: $_temperature°C');
    } else {
      print('Erreur lors de l\'envoi');
    }
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
            const Text(
              'Température actuelle:',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '$_temperature °C',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendTemperatureToServer,
              child: const Text('Envoyer Température'),
            ),
          ],
        ),
      ),
    );
  }
}
