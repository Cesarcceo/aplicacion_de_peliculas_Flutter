import 'dart:async';

import 'package:aplicacion_de_peliculas/helpers/debouncer.dart';
import 'package:aplicacion_de_peliculas/models/search_response.dart';
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

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500)
    );

  final StreamController<List<Movie>> _sugestionsStreamController =StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => _sugestionsStreamController.stream;
  MoviesProvider(){

    print('MoviesProvider inicializando');
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page=1]) async{
    final url = Uri.https(_baseUrl, endpoint, {
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


    final jsonData =await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse =CreditsResponse.fromRowJson(jsonData);

    moviesCast[movieId]=creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async{

    final url = Uri.https(_baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query,
    });

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }

  void getSuggestionsByQuery( String searchTerm){
    debouncer.value='';
    debouncer.onValue= ( value )async {
      final results = await searchMovies(value);
      _sugestionsStreamController.add(results);
    };
    final timer =Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value=searchTerm;
     });

     Future.delayed(const Duration(milliseconds: 301)).then((_)=> timer.cancel());
  }
}