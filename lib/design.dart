import 'package:flutter/material.dart';

Widget citySection(String city, double cityTemperature, TextEditingController cityController, Function updateCity) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Column(
      children: [
        const Text('📍 Ville actuelle:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(city, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        TextField(controller: cityController, decoration: const InputDecoration(labelText: "Entrez votre ville")),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: () => updateCity(), child: const Text('Valider la ville')),
        
        const SizedBox(height: 20),
        const Text('🌡️ Température réelle:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text('${cityTemperature.toStringAsFixed(1)} °C', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

void toggleMode() {
  print('Mode toggled');
}

Widget sensorSection(double temperature, double humidity, bool isActiveMode, Function updateTemperature, Function updateHumidity, Function onModeToggle ,Function sendData) {
  return Column(
    children: [
      Text('🔬 Température du capteur: ${temperature.toStringAsFixed(1)} °C'),
      Slider(value: temperature, min: 0, max: 48, divisions: 400, onChanged: (value) => updateTemperature(value)),
      Text('💧 Humidité actuelle: ${humidity.toStringAsFixed(0)} %'),
      Slider(value: humidity, min: 0, max: 100, divisions: 100, onChanged: (value) => updateHumidity(value)),

      ElevatedButton(onPressed: () => onModeToggle(), child: Text(isActiveMode ? 'Passer en mode veille' : 'Passer en mode actif')),
      
      const SizedBox(height: 20),
      ElevatedButton(onPressed: () => sendData(), child: const Text('Envoyer Température & Humidité')),
    ],
  );
}
