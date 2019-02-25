import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

class NetworkUtils {
  static final String endPoint = "http://www.json-generator.com/api/json/get/cfdYJUZthK?indent=2";

  static dynamic authenticateUser(String email, String password) async {
    var url = endPoint;

    try{
      final response = await http.post(
        url,
        body: {
          "password": password,
          "email": email
        }
      );

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception){
      print(exception);
      if(exception.toString().contains('SocketException')){
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }
//Esta funcion sirve solo para mostrar un snackbar
  static showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message) {
		scaffoldKey.currentState.showSnackBar(
			new SnackBar(
				content: new Text(message ?? 'You are offline'),
			)
		);
}


}