import 'package:flutter/material.dart';

class MovieSearchDelegate extends SearchDelegate{

  @override
  String get searchFieldLabel => 'Buscar Pelicula';

  @override
  List<Widget>? buildActions(BuildContext context) {
    
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query='',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {

    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    return Text('results');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    
    if(query.isEmpty){
      return Container(
        child: Center(
          child: Icon(Icons.movie_creation_outlined,color: Colors.black38, size: 130,),
        ),
      );
    }

    return Container();
  }

}