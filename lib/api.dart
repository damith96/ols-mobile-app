import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test_app/userSimplePreferences.dart';

class NetworkRequest{

  //final String _url = 'http://localhost:8000/api/v1'; //BASE_URL for our Laravel API
  final String _url = 'https://ols.devxtechnologies.com';
  //if you are using android studio emulator, change localhost to 10.0.2.2
  var token;

  Future postRequest(data,apiUrl) async{
    var fullUrl = _url + apiUrl;
    getToken();
    return await http.post(
      Uri.parse(fullUrl),
      body: jsonEncode(data),
      headers: _setHeaders()
    );
  }

  void getToken(){
    token = UserSimplePreferences.getToken();
  }

  Future getData(apiUrl) async{
    var fullUrl = _url + apiUrl;
    getToken();
    return await http.get(
      Uri.parse(fullUrl),
      headers: _setHeaders()
    );
  }

  Future putData(apiUrl) async{
    var fullUrl = _url + apiUrl;
    getToken();
    return await http.put(
      Uri.parse(fullUrl),
      headers: _setHeaders()
    );
  }
  _setHeaders() => {
    'Content-type' : 'application/json',
    'Accept' : 'application/json',
    'Authorization' : 'Bearer $token'
  };
}