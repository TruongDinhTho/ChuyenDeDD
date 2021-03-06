
import 'package:flutter/material.dart';
import 'package:movie_app/widgets/genre_movie.dart';
import 'package:movie_app/bloc/get_movie_byGenre_bloc.dart';
import 'package:movie_app/model/genre.dart';
import 'package:movie_app/style/theme.dart' as Style;

class GenresList extends StatefulWidget {
  final List<Genre> genres;
  
  const GenresList({ Key? key, required this.genres }) 
  : super(key: key);

  @override
  _GenresListState createState() => _GenresListState(genres);
}

class _GenresListState extends State<GenresList> with SingleTickerProviderStateMixin{
   final List<Genre> genres;
   late TabController _tabController;

   _GenresListState(this.genres);

  
  
  @override 
  void initState(){
    super.initState();
    _tabController = TabController(length: genres.length, vsync: this);
    _tabController.addListener(() { 
      if(_tabController.indexIsChanging){
        moviesByGenreBloc..drainStream();
      }
    });
  }

  @override 
  void dispose(){
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 307.0,
      child: DefaultTabController(
        length: genres.length,
        child: Scaffold(
          backgroundColor: Style.CustomColors.mainColor,
          appBar: PreferredSize(
            child: AppBar(
              backgroundColor: Style.CustomColors.mainColor,
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Style.CustomColors.secondaryColor,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3.0,
                unselectedLabelColor: Style.CustomColors.titleColor1,
                labelColor: Colors.white,
                isScrollable: true,
                tabs: genres.map((Genre genre){
                  return Container(
                    padding: EdgeInsets.only(bottom: 15.0, top: 10.0),
                    child: Text(genre.name.toLowerCase(),
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold
                    )),
                  );
                }).toList(),
              ),
            ),
            preferredSize: Size.fromHeight(50),  
          ),
          body: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: genres.map((Genre genre){
                return GenreMovies(genreId: genre.id);
              }).toList(),
            ),
        ),
      ),
    );
  }
}