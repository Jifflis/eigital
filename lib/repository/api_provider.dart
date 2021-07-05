import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiProvider {


  Future<dynamic> get(String url,{Map<String,String>? headers}) async {
    http.Response responseJson;
    try {
      final http.Response response = await http.get(Uri.parse(url),headers: headers);
      responseJson = _response(response);
    } on SocketException {
      throw const HttpException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url) async {
    return null;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 400:
        throw HttpException(response.body.toString());
      case 401:

      case 403:
        throw HttpException(response.body.toString());
      case 500:

      default:
        throw HttpException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
