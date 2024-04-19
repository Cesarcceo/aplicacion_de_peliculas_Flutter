import 'package:aplicacion_de_peliculas/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MoviesProvider extends ChangeNotifier{
  
  String _apiKey='6c39d0721c26c0eda41d05d6caef56a8';
  String _baseUrl='api.themoviedb.org';
  String _language='es-ES';

  List<Movie> onDisplayMovies=[];
  List<Movie> popularMovies=[];

  MoviesProvider(){

    print('MoviesProvider inicializando');
    this.getOnDisplayMovies();
    this.getPopularMovies();
  }

  getOnDisplayMovies() async {
    var url = Uri.https(_baseUrl, '3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _language,
      'page': '1',
    });

  final response = await http.get(url);
  final nowPlayinResponse = NowPlayingResponse.fromJson(response.body);

  onDisplayMovies=nowPlayinResponse.results;
  
  notifyListeners();
  }

  getPopularMovies()async{
    var url = Uri.https(_baseUrl, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _language,
      'page': '1',
    });

  final response = await http.get(url);
  final populaResponse = PopulaResponse.fromJson(response.body);

  popularMovies=[...popularMovies, ...populaResponse.results];
  notifyListeners();
  }
}