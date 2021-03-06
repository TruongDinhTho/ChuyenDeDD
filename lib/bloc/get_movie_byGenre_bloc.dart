import 'package:flutter/material.dart';
import 'package:movie_app/model/movie_response.dart';
import 'package:movie_app/repository/repository.dart';
import 'package:rxdart/subjects.dart';


class MoviesListByGenreBloc{
  final MovieRepository _repository = MovieRepository();
  BehaviorSubject<MovieResponse> _subject = 
  BehaviorSubject<MovieResponse>();

  getMoviesByGenre(int id) async{
    MovieResponse response = await _repository.getMovieByGenre(id);
    _subject.sink.add(response);
  }

  void drainStream(){
    _subject =  BehaviorSubject<MovieResponse>();}
  @mustCallSuper
  void dispose() async{
    await _subject.drain();
    _subject.close();
  }



  BehaviorSubject<MovieResponse> get subject => _subject;
}

final moviesByGenreBloc = MoviesListByGenreBloc();
