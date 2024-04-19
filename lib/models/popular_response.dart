import 'dart:convert';

import 'package:aplicacion_de_peliculas/models/models.dart';

class PopulaResponse {
    int page;
    List<Movie> results;
    int totalPages;
    int totalResults;

    PopulaResponse({
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    factory PopulaResponse.fromJson(String str) => PopulaResponse.fromMap(json.decode(str));

    factory PopulaResponse.fromMap(Map<String, dynamic> json) => PopulaResponse(
        page: json["page"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );

}