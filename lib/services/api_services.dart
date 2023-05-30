import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_ai/constant/colors.dart';
import 'package:open_ai/constant/urls.dart';
import 'package:open_ai/models/message_model.dart';

import '../models/models_model.dart';

class ApiServices {
  static Future<List<Models>> getModels() async {
    List<Models> tempList = [];
    try {
      final response = await http.get(Uri.parse(getModelsUrl),
          headers: {'Authorization': 'Bearer $apiKey'});

      Map jsonData = jsonDecode(response.body);

      // log(jsonData['data'].toString());
      List<dynamic> fetchedList = jsonData['data'];

      tempList = fetchedList.map<Models>((e) => Models.fromJson(e)).toList();

      // log(tempList.toString());
      // log(fetchedList.toString());
    } catch (err) {
      log('ERROR FOUND :${err.toString()}');

      rethrow;
    }

    return tempList;
  }

  static Future<List<MessageModel>> sendMessage({
    required String message,
    required String modelId,
    required BuildContext ctx,
  }) async {
    List<MessageModel> msgList = [];
    String errorText = 'Something went wrong!try again...';
    try {
      const apiUrl = '$baseUrl/chat/completions';

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      };

      final requestBody = {
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'system', 'content': 'You are a user'},
          {'role': 'user', 'content': message},
        ],
      };

      final response = await http.post(Uri.parse(apiUrl),
          headers: headers, body: json.encode(requestBody));

      if (response.statusCode == 200) {
        // API call succeeded
        final responseData = json.decode(response.body);

        msgList = List.generate(
            responseData['choices'].length,
            (index) => MessageModel(
                message: responseData['choices'][index]['message']['content'],
                createAt: DateTime.now().toIso8601String(),
                chatIndex: 1)).toList();

        log(requestBody.toString());
      } else {
        // API call failed
        log('Failed to post message. Status code: ${response.statusCode}');
      }
    } catch (err) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            errorText,
            style: const TextStyle(color: whiteColor),
          )));
    }

    return msgList;
  }
}
