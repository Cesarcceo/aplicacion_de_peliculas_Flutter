import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:aplicacion_de_peliculas/models/models.dart';

class MoviesProvider extends ChangeNotifier{
  
  final String _apiKey='1b645bb9a383a8408792fd98c5d058a3';
  final String _baseUrl='api.themoviedb.org';
  final String _language='es-ES';

  List<Movie> onDisplayMovies=[];
  List<Movie> popularMovies=[];
  // List<Cast> moviesCast=[];
  
  Map<int, List<Cast>> moviesCast ={};

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
    print(url);

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


    final jsonData =await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse =CreditsResponse.fromRowJson(jsonData);

    moviesCast[movieId]=creditsResponse.cast;

    return creditsResponse.cast;
  }
}