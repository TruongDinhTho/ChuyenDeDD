import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/login_screen/authentication_bloc/authentication_bloc.dart';
import 'package:movie_app/login_screen/authentication_bloc/authentication_event.dart';
import 'package:movie_app/login_screen/simple_bloc_obsever.dart';
import 'package:movie_app/repository/user_repository.dart';
import 'package:movie_app/screens/home_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  BlocOverrides.runZoned(
    () {},
    blocObserver: SimpleBlocObserver(),
  );
  final UserRepository userRepository = UserRepository();

  runApp(
      BlocProvider(
        create: (context) => AuthenticationBloc(userRepository)..add(AuthenticatonStarted()),
        child: MyApp(userRepository: userRepository),
      )
  );
}

class MyApp extends StatefulWidget {
  final UserRepository _userRepository;

  MyApp({required UserRepository userRepository}) : _userRepository = userRepository;

  @override
  _MyAppState createState() => _MyAppState(userRepository: _userRepository);
}

class _MyAppState extends State<MyApp> {
  final UserRepository _userRepository;

  _MyAppState({required UserRepository userRepository}) : _userRepository = userRepository;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(userRepository: _userRepository),
    );
  }
}