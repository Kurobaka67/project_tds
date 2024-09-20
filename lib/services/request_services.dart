import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:project_transdata/model/request_model.dart';

List<RequestModel> requests = [];

class RequestService {
  Future<void> getAllRequests() async {
    try {
      var response = await rootBundle.loadString('assets/data/requests.json');
      if (response.isNotEmpty) {
        requests = requestModelFromJson(response);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<RequestModel>?> getRequests() async {
    try {
      if (requests.isNotEmpty) {
        return requests;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<RequestModel?> saveRequests(String title, String description) async {
    try {
      var nextId = await getNextIdRequest();
      if(nextId != -1){
        RequestModel rm = RequestModel(id: nextId, title: title, description: description, person: 'Jonathan', response: []);
        requests.add(rm);
        return rm;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<int> getNextIdRequest() async {
    try {
      var nextId = 1;
      List<RequestModel> lr = [];
      for (var r in requests) {
        lr.add(RequestModel(id: r.id, title: r.title, description: r.description, person: r.person, response: r.response));
      }
      lr.sort((a, b) => a.id-b.id);
      for(var r in lr) {
        if(r.id != nextId){
          return nextId;
        }
        nextId++;
      }
      return nextId;
    } catch (e) {
      log(e.toString());
    }
    return -1;
  }
}