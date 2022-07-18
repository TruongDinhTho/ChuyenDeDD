import 'package:flutter/material.dart';
import 'package:movie_app/model/video_response.dart';
import 'package:movie_app/repository/repository.dart';
import 'package:rxdart/subjects.dart';

class MovieVideosBloc{
  final MovieRepository _repository = MovieRepository();
  BehaviorSubject<VideoResponse> _subject = BehaviorSubject<VideoResponse>();

  getMovieVideo(int id) async{
    VideoResponse response = await _repository.getMoviesVideos(id);
    _subject.sink.add(response);
  }

  void drainStream(){_subject = BehaviorSubject<VideoResponse>();}
  @mustCallSuper
  dispose() async {
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<VideoResponse> get subject => _subject;

}

final movieVideosBloc = MovieVideosBloc();