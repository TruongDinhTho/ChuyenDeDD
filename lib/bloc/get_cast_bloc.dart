import 'package:flutter/cupertino.dart';
import 'package:movie_app/model/cast_response.dart';
import 'package:movie_app/repository/repository.dart';
import 'package:rxdart/subjects.dart';

class CastsBloc{
  final MovieRepository _repository = MovieRepository();
  BehaviorSubject<CastResponse> _subject = BehaviorSubject<CastResponse>();

  getGenres(int id) async{
    CastResponse response = await _repository.getCasts(id);
    _subject.sink.add(response);
  }

  void drainStream(){_subject = BehaviorSubject<CastResponse>();}
  @mustCallSuper
  dispose() async {
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<CastResponse> get subject => _subject;

  getCasts(int id) {}
}

final castBloc = CastsBloc();