import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:whetherapp/models/weather_response_model.dart';
import 'package:whetherapp/secrets/api.dart';
import 'package:http/http.dart' as http;

class WeatherServiceProvider extends ChangeNotifier{
  WeatherModel?_weather;
  WeatherModel? get weather=>_weather;

  bool _isloading=false;
  bool get isLoading=>_isloading;
  String _error="";
  String get Error=>_error;

  Future<void>FetchWeatherDataByCity(String city)async{
    _isloading=true;
    _error="";
    try{
      final  String apiUrl="${APIEndpoints().cityUrl}${city}&appid=${APIEndpoints().apikey}${APIEndpoints().unit}";

      print(apiUrl);
      final response= await  http.get(Uri.parse(apiUrl));

      if(response.statusCode==200){
        final data=jsonDecode(response.body);
        print(data);

        _weather=WeatherModel.fromJson(data);
        notifyListeners();
      } else{
      _error="failed to load data";
    }
    }catch(e){
      _error="failed to load data $e";
      
    }finally{
      _isloading=false;
      notifyListeners();
    }
   
  }
}