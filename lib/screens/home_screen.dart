import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/login_screen/authentication_bloc/authentication_bloc.dart';
import 'package:movie_app/login_screen/authentication_bloc/authentication_event.dart';
import 'package:movie_app/login_screen/authentication_bloc/authentication_state.dart';
import 'package:movie_app/login_screen/screens/login/login_screen.dart';
import 'package:movie_app/repository/user_repository.dart';
import 'package:movie_app/search/search.dart';
import 'package:movie_app/style/theme.dart' as Style;
import 'package:movie_app/widgets/genre.dart';
import 'package:movie_app/widgets/now_playing.dart';
import 'package:movie_app/widgets/person.dart';
import 'package:movie_app/widgets/top_movies.dart';

class HomeScreen extends StatefulWidget {
  final UserRepository userRepository;
  const HomeScreen({ Key? key, required UserRepository userRepository }) 
  :userRepository = userRepository, 
  super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedIndex = 0;
  List<Widget> widgetOptions = <Widget>[
    ListView(
      children: [
          NowPlaying(),
          GenresScreen(),
          PersonList(),
          TopMovies(),
        ]),
    BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
        if(state is AuthenticationFailure) {
        return LoginScreen();
      }
      if (state is AuthenticationSuccess) {
        return Container(color: Colors.red);
      }
      return Scaffold(
          appBar: AppBar(),
          body: Container(
              child: Container(
            color: Colors.blue,
          )
        ));
    })
  ];

   void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

   void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Style.CustomColors.mainColor,
      appBar: AppBar(
        backgroundColor: Style.CustomColors.mainColor,
        centerTitle: true,
        leading: Icon(EvaIcons.menu2Outline, color: Colors.white),
        title: Text('App Movie'),
        actions: [
          IconButton(
            onPressed: _openEndDrawer, 
            icon: Icon(EvaIcons.searchOutline, color: Colors.white)
          ),
          IconButton(
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(AuthenticatonLoggedOut());
            }, 
            icon: Icon(EvaIcons.logOut, color: Colors.white)
          ),
        ],
      ),
      endDrawer: Drawer(
        child: SafeArea(
          child: Container(
            color: Style.CustomColors.mainColor,
            padding: EdgeInsets.all(16),
            child: SearchMovie(),
            
          ),
        ),
      ),


      endDrawerEnableOpenDragGesture: false,

      body: Container(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      
       bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Login',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Style.CustomColors.fourthColor,
        onTap: _onItemTapped,
      ),
    );
  }

  
}