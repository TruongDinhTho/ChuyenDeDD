import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_app/bloc/get_movie_videos_bloc.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/model/video.dart';
import 'package:movie_app/model/video_response.dart';
import 'package:movie_app/screens/video_screen.dart';
import 'package:movie_app/style/theme.dart' as Style;
import 'package:movie_app/widgets/movie_info.dart';
import 'package:movie_app/widgets/similar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  const MovieDetailScreen({ Key? key, required this.movie }) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState(movie);
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final Movie movie;
  _MovieDetailScreenState(this.movie);
  @override 
  void initState(){
    super.initState();
    movieVideosBloc..getMovieVideo(movie.id!);
  }

  @override 
  void dispose(){
    super.dispose();
    movieVideosBloc..drainStream();
  }
  @override
  Widget build(BuildContext context) {
    bool _pinned = true;
    bool _snap = false;
    bool _floating = false;
    return Scaffold(
        backgroundColor: Style.CustomColors.mainColor,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: _pinned,
              snap: _snap,
              floating: _floating,
              backgroundColor: Style.CustomColors.mainColor,
              expandedHeight: 200.0,
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0.0),
                  child: Transform.translate(
                    offset: const Offset(150, 30),
                    child: StreamBuilder<VideoResponse>(
                      stream: movieVideosBloc.subject.stream,
                      builder:
                          (context, AsyncSnapshot<VideoResponse> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.error.length > 0) {
                            return _buildErrorWidget(snapshot.data!.error);
                          }
                          return _buildHomeWidget(snapshot.data!);
                        } else if (snapshot.hasError) {
                          return _buildErrorWidget(snapshot.error.toString());
                        } else {
                          return _buildLoadingWidget();
                        }
                      },
                    ),
                  )),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  movie.title!.length > 40
                      ? movie.title!.substring(0, 37) + "..."
                      : movie.title!,
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                ),
                background: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://image.tmdb.org/t/p/original/" +
                                      movie.backPoster!))),
                      child: Container(
                        decoration:
                            BoxDecoration(color: Colors.black.withOpacity(0.3)),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                            Colors.black.withOpacity(0.9),
                            Colors.black.withOpacity(0.0)
                          ])),
                    )
                  ],
                ),
              ),
            ),
            SliverPadding(
                padding: EdgeInsets.all(0.0),
                sliver: SliverList(
                    delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            (movie.rating! / 2).toString().substring(0, 3),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          RatingBar.builder(
                            itemSize: 10.0,
                            initialRating: movie.rating! / 2,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              EvaIcons.star,
                              color: Style.CustomColors.secondaryColor,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 20.0),
                      child: Text(
                        "OVERVIEW",
                        style: TextStyle(
                            color: Style.CustomColors.titleColor1,
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        movie.overview!,
                        style: TextStyle(
                            color: Colors.white, fontSize: 12.0, height: 1.5),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    MovieInfo(
                      id: movie.id!,
                    ),
                    SimilarMovies(
                      id: movie.id!,
                    )
                  ],
                )))
          ],
        ));
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
          )
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error){
    return Center(
      child: Column(
        children: [
          Text("$error")
        ],
      ),
    );
  }

  Widget _buildHomeWidget(VideoResponse data) {
    List<Video> videos = data.videos;
    return FloatingActionButton(
      backgroundColor: Style.CustomColors.secondaryColor,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(
              controller: YoutubePlayerController(
                initialVideoId: videos[0].key,
                flags: YoutubePlayerFlags(
                  autoPlay: true,
                  mute: true,
                ),
              ),
            ),
          ),
        );
      },
      child: Icon(Icons.play_arrow),
    );
  }
}