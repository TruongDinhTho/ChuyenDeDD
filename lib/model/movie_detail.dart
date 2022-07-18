import 'package:movie_app/model/genre.dart';

class MovieDatail{
  final int id;
  final bool adult;
  final int budget;
  final List<Genre> gerens;
  final String releaseDate;
  final int runtime;

  MovieDatail(
    this.id, 
    this.adult, 
    this.budget, 
    this.gerens, 
    this.releaseDate, 
    this.runtime);

  MovieDatail.fromJson(Map<String, dynamic> json)
  : id = json["id"],
    adult = json["adult"],
    budget = json["budget"],
    gerens = (json["genres"] as List).map((i) => new Genre.fromJson(i)).toList(),
    releaseDate = json["release_date"],
    runtime = json["runtime"];

}