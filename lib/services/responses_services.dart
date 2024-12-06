import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:project_transdata/my_globals.dart' as globals;

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:project_transdata/model/response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResponsesService {
  Future<List<ResponseModel>?> getResponsesByRequestId(int request_id) async {
    try {
      SharedPreferencesAsync? prefs = SharedPreferencesAsync();
      final String username = await prefs.getString('username') ?? '';
      final String useremail = await prefs.getString('useremail') ?? '';
      var bytes = utf8.encode(username+useremail);
      var digest = sha256.convert(bytes);
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/responses/$request_id');
      var response = await client.get(uri,
          headers: {
            "x-api-key": digest.toString()
          }).timeout(Duration(seconds: 5));
      if (response.statusCode == 200) {
        return responseModelFromJson(const Utf8Decoder().convert(response.bodyBytes));
      }
    }
    catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<String> saveResponses(int request_id, String description) async {
    try {
      SharedPreferencesAsync? prefs = SharedPreferencesAsync();
      final String username = await prefs.getString('username') ?? '';
      final String useremail = await prefs.getString('useremail') ?? '';
      var bytes = utf8.encode(username+useremail);
      var digest = sha256.convert(bytes);
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/responses');
      var response = await client.post(uri,
          headers: {
            "Content-Type": "application/json",
            "x-api-key": digest.toString()
          },
          body: jsonEncode({
            "request_id": request_id,
            "description": description,
          })).timeout(Duration(seconds: 5));
      if (response.statusCode == 201) {
        return 'Réponse envoyé avec succès!';
      }
    } catch (e) {
      log(e.toString());
    }
    return 'Erreur lors de l\'envoie de la réponse';
  }
}

