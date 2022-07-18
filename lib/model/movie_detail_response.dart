import 'package:movie_app/model/movie_detail.dart';

class MovieDetailResponse{
  final MovieDatail movieDatail;
  final String error;

  MovieDetailResponse(this.movieDatail, this.error);

  MovieDetailResponse.fromJson(Map<String, dynamic> json)
  : movieDatail = MovieDatail.fromJson(json),
    error = "";

  MovieDetailResponse.withError(String errorValue)
  : movieDatail = MovieDatail(0, false, 0, List.empty(), "", 0),
    error = errorValue;

}