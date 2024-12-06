import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:project_transdata/my_globals.dart' as globals;

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_transdata/model/user_model.dart';
import 'package:project_transdata/screens/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/verify_code.dart';
import 'firebase_api.dart';

class UsersService {
  Future<Widget?> login(String name, String email) async {
    try {
      SharedPreferencesAsync? prefs = SharedPreferencesAsync();
      var token = await FirebaseApi().initNotifications();
      await prefs.setString('username', name);
      await prefs.setString('useremail', email);
      var bytes = utf8.encode(name+email);
      var digest = sha256.convert(bytes);
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/login');
      var response = await client.post(uri,
          headers: {
            "Content-Type": "application/json",
            "x-api-key": digest.toString()
          },
          body: jsonEncode({
            "name": name,
            "email": email,
            "token": token,
          })).timeout(Duration(seconds: 5));
      if (response.statusCode == 200 || response.statusCode == 201) {
        await prefs.setBool('verify', true);
        await prefs.setBool('admin', false);
        return const MainPage();
      }
      if (response.statusCode == 202) {
        await prefs.setBool('verify', false);
        return const VerifyCodePage();
      }
    }
    catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<bool> logout() async {
    try {
      SharedPreferencesAsync? prefs = SharedPreferencesAsync();
      final String username = await prefs.getString('username') ?? '';
      final String useremail = await prefs.getString('useremail') ?? '';
      var bytes = utf8.encode(username+useremail);
      var digest = sha256.convert(bytes);
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/login');
      var response = await client.get(uri,
          headers: {
            "x-api-key": digest.toString()
          }).timeout(Duration(seconds: 5));
      if (response.statusCode == 200) {
        return true;
      }
      if (response.statusCode == 401) {
        return false;
      }
    }
    catch (e) {
      log(e.toString());
    }
    return false;
  }

  Future<UserModel?> getUserById(int id) async {
    try {
      SharedPreferencesAsync? prefs = SharedPreferencesAsync();
      final String username = await prefs.getString('username') ?? '';
      final String useremail = await prefs.getString('useremail') ?? '';
      var bytes = utf8.encode(username+useremail);
      var digest = sha256.convert(bytes);
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/users/$id');
      var response = await client.get(uri,
          headers: {
            "x-api-key": digest.toString()
          }).timeout(Duration(seconds: 5));
      if (response.statusCode == 200){
        return userModelFromJson(const Utf8Decoder().convert(response.bodyBytes))[0];
      }
    }
    catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<bool> verify(codeInput) async {
    try {
      SharedPreferencesAsync? prefs = SharedPreferencesAsync();
      final String username = await prefs.getString('username') ?? '';
      final String useremail = await prefs.getString('useremail') ?? '';
      var bytes = utf8.encode(username+useremail);
      var digest = sha256.convert(bytes);
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/users/verify');
      var response = await client.post(uri,
          headers: {
            "Content-Type": "application/json",
            "x-api-key": digest.toString()
          },
          body: jsonEncode({
            "codeInput": codeInput,
          })).timeout(Duration(seconds: 5));
      if (response.statusCode == 200){
        await prefs.setBool('verify', true);
        return true;
      }
      if (response.statusCode == 401){
        await prefs.setBool('verify', false);
        return false;
      }
    }
    catch (e) {
      log(e.toString());
    }
    return false;
  }

  Future<bool> changeNotification() async {
    try {
      SharedPreferencesAsync? prefs = SharedPreferencesAsync();
      final String username = await prefs.getString('username') ?? '';
      final String useremail = await prefs.getString('useremail') ?? '';
      var bytes = utf8.encode(username+useremail);
      var digest = sha256.convert(bytes);
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/users/notify');
      var response = await client.get(uri,
          headers: {
            "x-api-key": digest.toString()
          }).timeout(Duration(seconds: 5));
      if (response.statusCode == 200){
        return true;
      }
      if (response.statusCode == 401){
        return false;
      }
    }
    catch (e) {
      log(e.toString());
    }
    return false;
  }
}