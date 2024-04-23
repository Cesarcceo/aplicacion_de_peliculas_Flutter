import 'package:aplicacion_de_peliculas/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MoviesProvider extends ChangeNotifier{
  
  final String _apiKey='6c39d0721c26c0eda41d05d6caef56a8';
  final String _baseUrl='api.themoviedb.org';
  final String _language='es-ES';

  List<Movie> onDisplayMovies=[];
  List<Movie> popularMovies=[];
  
  Map <int, List<Cast>> moviesCast ={};

  int _popularPage=0;

  MoviesProvider(){

    print('MoviesProvider inicializando');
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page=1]) async{
    var url = Uri.https(_baseUrl, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
    });

    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    final jsonData =await _getJsonData('3/movie/now_playing');
    final nowPlayinResponse = NowPlayingResponse.fromJson(jsonData);

    onDisplayMovies=nowPlayinResponse.results;
    
    notifyListeners();
  }

  getPopularMovies()async{
    _popularPage=_popularPage+1;
    final jsonData =await _getJsonData('3/movie/popular', _popularPage);
    final populaResponse = PopulaResponse.fromJson(jsonData);

    popularMovies=[...popularMovies, ...populaResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async{
    print('pidinedo hattp -> cast');

    final jsonData =await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse =CreditsResponse.fromJson(jsonData);

    moviesCast[movieId]=creditsResponse.cast;

    return creditsResponse.cast;
  }
}