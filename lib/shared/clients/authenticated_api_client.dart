import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthenticatedApiClient {
  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Utilisateur non connecté.');
    }

    // Obtenez ou rafraîchissez le token Firebase
    final token = await user.getIdToken(true);

    // Envoyez la requête POST avec le token
    final response = await http.post(
      Uri.parse("${dotenv.env['API_URL']}/$url"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    return response;
  }
}
