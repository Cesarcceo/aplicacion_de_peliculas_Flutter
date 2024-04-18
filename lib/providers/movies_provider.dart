import 'package:flutter/material.dart';

class MoviesProvider extends ChangeNotifier{

  MoviesProvider(){
    
    print('MoviesProvider inicializando');
    this.getOnDisplayMovies();
  }

  getOnDisplayMovies() async {
    print('getOnDisplayMovies');
  }
}