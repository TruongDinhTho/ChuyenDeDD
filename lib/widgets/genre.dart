import 'package:flutter/material.dart';
import 'package:movie_app/bloc/get_genres_bloc.dart';
import 'package:movie_app/model/genre.dart';
import 'package:movie_app/model/genre_response.dart';
import 'package:movie_app/widgets/genres_list.dart';

class GenresScreen extends StatefulWidget {
  const GenresScreen({ Key? key }) : super(key: key);

  @override
  State<GenresScreen> createState() => _GenresScreenState();
}



class _GenresScreenState extends State<GenresScreen> {
  @override
  void initState(){
    super.initState();
    genresBloc..getGenres();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GenreResponse>(
      stream: genresBloc.subject.stream,
      builder: (context, AsyncSnapshot<GenreResponse> snapshot){
        if(snapshot.hasData){
          if(snapshot.data!.error != null && snapshot.data!.error.length > 0){
            return _buildErrorWidget(snapshot.data!.error);
          }
          return _buildGenresWidget(snapshot.data!);
        } else if (snapshot.hasError){
          return _buildErrorWidget(snapshot.error.toString());
        } else {
          return _buildLoadingWidget(); 
        }
      },
    );
  }

  Widget _buildLoadingWidget(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 25.0,
            width: 25.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 4.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Error occured: $error")
        ],
      ),
    );
  }

  Widget _buildGenresWidget(GenreResponse data){
    List<Genre> genres = data.genres;
    if(genres.length == 0){
      return Container(
        child: Text("No Genre"),
      );
    }else return GenresList(genres: genres);
  }
}