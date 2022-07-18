import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/model/movie_response.dart';
import 'package:movie_app/screens/detail_screen.dart';
import 'package:movie_app/search/search_bloc.dart';
import 'package:movie_app/style/inputfiled.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:movie_app/style/theme.dart' as Style;

class SearchMovie extends StatefulWidget {
  const SearchMovie({Key? key}) : super(key: key);

  @override
  _SearchMovieState createState() => _SearchMovieState();
}

class _SearchMovieState extends State<SearchMovie> {
  TextEditingController searchController = TextEditingController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  String searchNull = "khongcogi";
  String isLoadMore = "more ...";
  int page = 1;

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 500));
    page += 1;
    MovieResponse response =
        await moviesSearchBloc.getMovieSearchMore(searchNull, page);
    if (response.movies.isEmpty) {
      isLoadMore = "Can't load more";
    }
    //moviesSearchBloc.getMovieSearchMore(searchNull, page);
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _refreshController.loadComplete();
    //if (mounted) setState(() {});
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    page += 1;
    moviesSearchBloc.getMovieSearchMore(searchNull, page);
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    moviesSearchBloc.getMoviesSearch(searchNull, 1);
    //moviesSearchBloc.getMovieSearchMore(searchNull, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.0, top: 20.0),
          child: Column(children: [
            TextFieldContainer(
              color: Style.CustomColors.titleColor1,
              child: TextField(
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0),
                onChanged: (text) async {
                  Future.delayed(Duration(milliseconds: 500));
                  if (text.isEmpty == false) {
                    page = 1;

                    await moviesSearchBloc.getMoviesSearch(text, page);

                    searchNull = text;
                  }
                },
                controller: searchController,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    EvaIcons.searchOutline,
                    color: Style.CustomColors.secondaryColor,
                  ),
                  hintText: 'Enter Your Name',
                  hintStyle: TextStyle(
                      color: Style.CustomColors.secondaryColor,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0),
                  border: InputBorder.none,
                ),
              ),
            ),
          ]),
        ),
        SizedBox(
          height: 5.0,
        ),
        StreamBuilder<MovieResponse>(
          stream: moviesSearchBloc.subject.stream,
          builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.error.length > 0) {
                return _buildErrorWidget(searchNull);
              }
              return _buildHomeWidget(snapshot.data!);
            } else if (snapshot.hasError) {
              return _buildErrorWidget(searchNull);
            } else {
              return _buildLoadingWidget();
            }
          },
        )
      ],
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 25.0,
          width: 25.0,
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 4.0,
          ),
        )
      ],
    ));
  }

  Widget _buildErrorWidget(String? nameNull) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [],
    ));
  }

  Widget _buildHomeWidget(MovieResponse data) {
    final List<Movie>? movies = data.movies;
    if (movies!.isEmpty) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                Text(
                  (() {
                    if (searchNull == "khongcogi") {
                      return "What is your find?";
                    }
                    return "Can't find this name";
                  })(),
                  style: TextStyle(
                      color: Style.CustomColors.secondaryColor,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0),
                ),
              ],
            )
          ],
        ),
      );
    } else {
      return Expanded(
        child: SmartRefresher(
          enablePullDown: false,
          enablePullUp: true,
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus? mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = Text(
                  isLoadMore,
                  style: TextStyle(color: Colors.white),
                );
              } else if (mode == LoadStatus.loading) {
                body = Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Loading...",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 12.0,
                      width: 12.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ],
                );
              } else if (mode == LoadStatus.failed) {
                body = Text("Load Failed!Click retry!");
              } else if (mode == LoadStatus.canLoading) {
                body = Text("release to load more");
              } else {
                body = Text("No more Data");
              }
              return Container(
                height: 55.0,
                child: Center(child: body),
              );
            },
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.only(top: 10.0, right: 8.0),
                width: 100.0,
                child: GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MovieDetailScreen(
                                  movie: movies[index],
                                )));
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      movies[index].backPoster == null
                          ? Hero(
                              tag: movies[index].id!,
                              child: Container(
                                margin: EdgeInsets.only(left: 25.0, top: 10.0),
                                width: 40.0,
                                height: 40.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Style.CustomColors.secondaryColor),
                                child: Icon(
                                  FontAwesomeIcons.userAlt,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : Hero(
                              tag: movies[index].id!,
                              child: Container(
                                  margin: EdgeInsets.only(left: 25.0),
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    image: new DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            "https://image.tmdb.org/t/p/w300/" +
                                                movies[index].backPoster!)),
                                  )),
                            ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 25.0),
                          child: Text(
                            movies[index].title!,
                            maxLines: 2,
                            style: TextStyle(
                                height: 1.4,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 3.0,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
  }
}