import 'dart:convert';
import 'package:http/http.dart' as http;

// 🔹 Fonction pour envoyer les données au serveur
Future<void> sendDataToServer(double temperature, double humidity) async {
  var url = Uri.parse("http://localhost:8080/data"); // a tester en local ou remplace par l'IP correcte

  var data = {
    "temperature": temperature.toStringAsFixed(1),
    "humidity": humidity.toStringAsFixed(0),
  };

  try {
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print("Données envoyées : Température = $temperature°C, Humidité = $humidity%");
    } else {
      print("Erreur serveur : ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("🚨 Exception : $e");
  }
}

// 🔹 Fonction pour récupérer les données stockées sur le serveur
Future<void> fetchStoredData() async {
  var url = Uri.parse("http://localhost:8080/display");

  try {
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("Données stockées sur le serveur : $data");
    } else {
      print("Erreur de récupération : ${response.statusCode}");
    }
  } catch (e) {
    print("🚨 Exception lors de la récupération : $e");
  }
}
