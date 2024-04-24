import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:aplicacion_de_peliculas/models/models.dart';
import 'package:aplicacion_de_peliculas/providers/movies_provider.dart';

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

  Widget _emptyContainer(){
    return Container(
        child: Center(
          child: Icon(Icons.movie_creation_outlined,color: Colors.black38, size: 130,),
        ),
      );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    
    if(query.isEmpty){
      return _emptyContainer();
    }

    final moviesProvider=Provider.of<MoviesProvider>(context);

    return FutureBuilder(
      future: moviesProvider.searchMovies(query),
      builder: ( _ , AsyncSnapshot<List<Movie>> snapshot){
        if(!snapshot.hasData) return _emptyContainer() ;

        final movies=snapshot.data!;

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (_, int index)=> _MovieItem(movie: movies[index])
        );
      }
    );
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;

  const _MovieItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {

    movie.heroId='search-${movie.id}';

    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          placeholder: const AssetImage('assets/loading.gif'),
          image: NetworkImage(movie.fullPosterImg),
          width: 50,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(movie.title),
      subtitle: Text(movie.originalLanguage),
      onTap: () {
        Navigator.pushNamed(context, 'details', arguments: movie);
      },
    );
  }
}