import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:project_transdata/my_globals.dart' as globals;

import 'package:crypto/crypto.dart';
import 'package:project_transdata/model/request_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RequestService {
  Future<List<RequestModel>?> getRequests() async {
    try {
      SharedPreferencesAsync? prefs = SharedPreferencesAsync();
      final String username = await prefs.getString('username') ?? '';
      final String useremail = await prefs.getString('useremail') ?? '';
      var bytes = utf8.encode(username+useremail);
      var digest = sha256.convert(bytes);
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/requests');
      var response = await client.get(uri,
        headers: {
          "x-api-key": digest.toString()
        }
      ).timeout(Duration(seconds: 5));
      if (response.statusCode == 200) {
        return requestModelFromJson(const Utf8Decoder().convert(response.bodyBytes));
      }
    } on TimeoutException catch (e) {
      log(e.toString());
      return null;
    }
    catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<List<RequestModel>?> getRequestsByName() async {
    try{
      SharedPreferencesAsync? prefs = SharedPreferencesAsync();
      final String username = await prefs.getString('username') ?? '';
      final String useremail = await prefs.getString('useremail') ?? '';
      var bytes = utf8.encode(username+useremail);
      var digest = sha256.convert(bytes);
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/requests/name');
      var response = await client.get(uri,
          headers: {
            "x-api-key": digest.toString()
          }
      ).timeout(Duration(seconds: 5));
      if (response.statusCode == 200) {
        return requestModelFromJson(const Utf8Decoder().convert(response.bodyBytes));
      }
    } on TimeoutException catch (e) {
      log(e.toString());
      return null;
    }
    catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<bool> saveRequests(String title, String description) async {
    try {
      SharedPreferencesAsync? prefs = SharedPreferencesAsync();
      final String username = await prefs.getString('username') ?? '';
      final String useremail = await prefs.getString('useremail') ?? '';
      var bytes = utf8.encode(username+useremail);
      var digest = sha256.convert(bytes);
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/requests');
      var response = await client.post(uri,
          headers: {
            "Content-Type": "application/json",
            "x-api-key": digest.toString()
          },
          body: jsonEncode({
            "title": title,
            "description": description,
          })).timeout(Duration(seconds: 5));
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      log(e.toString());
    }
    return false;
  }

  Future<String> deleteRequests(int request_id) async{
    try {
      SharedPreferencesAsync? prefs = SharedPreferencesAsync();
      final String username = await prefs.getString('username') ?? '';
      final String useremail = await prefs.getString('useremail') ?? '';
      var bytes = utf8.encode(username+useremail);
      var digest = sha256.convert(bytes);
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/requests/$request_id');
      var response = await client.delete(uri,
          headers: {
            "x-api-key": digest.toString()
          }).timeout(Duration(seconds: 5));
      if (response.statusCode == 201) {
        return 'Message supprimé avec succès!';
      }
    } catch (e) {
      log(e.toString());
    }
    return 'Erreur lors de la suppression';
  }

  Future<List<RequestModel>?> getArchiveRequest() async {
    try{
      print("hey");
      SharedPreferencesAsync? prefs = SharedPreferencesAsync();
      final String username = await prefs.getString('username') ?? '';
      final String useremail = await prefs.getString('useremail') ?? '';
      var bytes = utf8.encode(username+useremail);
      var digest = sha256.convert(bytes);
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/requests/archived');
      var response = await client.get(uri,
          headers: {
            "x-api-key": digest.toString()
          }).timeout(Duration(seconds: 5));
      if (response.statusCode == 200) {
        return requestModelFromJson(const Utf8Decoder().convert(response.bodyBytes));
      }
    } on TimeoutException catch (e) {
      log(e.toString());
      return null;
    }
    catch (e) {
      log(e.toString());
    }
    return null;
  }
}