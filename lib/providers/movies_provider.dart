import 'dart:convert';
import 'package:aplicacion_de_peliculas/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MoviesProvider extends ChangeNotifier{
  
  String _apiKey='6c39d0721c26c0eda41d05d6caef56a8';
  String _baseUrl='api.themoviedb.org';
  String _language='es-ES';

  MoviesProvider(){

    print('MoviesProvider inicializando');
    this.getOnDisplayMovies();
  }

  getOnDisplayMovies() async {
    var url = Uri.https(_baseUrl, '3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _language,
      'page': '1',
    });

  // Await the http get response, then decode the json-formatted response.
  final response = await http.get(url);
  final nowPlayinResponse = NowPlayingResponse.fromJson(response.body);

  print(nowPlayinResponse.results[1].title);
  }
}