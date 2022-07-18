import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/login_screen/authentication_bloc/authentication_bloc.dart';
import 'package:movie_app/login_screen/authentication_bloc/authentication_event.dart';
import 'package:movie_app/login_screen/register_bloc/register_bloc.dart';
import 'package:movie_app/login_screen/register_bloc/register_event.dart';
import 'package:movie_app/login_screen/register_bloc/register_state.dart';
import 'package:movie_app/style/Button_form.dart';


import 'package:movie_app/style/theme.dart' as Style;


class RegisterForm extends StatefulWidget {

  const RegisterForm({Key? key}) :super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordlController = TextEditingController();

  bool get isPopulated => emailController.text.isNotEmpty && passwordlController.text.isNotEmpty;

  bool isButtonEnable(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting!;
  }

  late RegisterBloc registerBloc;
  @override
  void initState() {
    super.initState();
    registerBloc = BlocProvider.of<RegisterBloc>(context);
    emailController.addListener(_onEmailChange);
    passwordlController.addListener(_onPasswordChange);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if(state.isFailure!) {
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
                SnackBar(
                    backgroundColor: Style.CustomColors.secondaryColor,
                    content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Register Failure! Please again"),
                          Icon(Icons.error)
                        ])));
        }
        if(state.isSubmitting!) {
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
                SnackBar(
                    backgroundColor: Style.CustomColors.secondaryColor,
                    content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Registering..."),
                          CircularProgressIndicator()]
                    )));
        }
        if(state.isSuccess!) {
          BlocProvider.of<AuthenticationBloc>(context).add(
            AuthenticatonLoggedIn(),
          );
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              child: Column(
                children: [
                  //email
                  TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      style: TextStyle(color: Style.CustomColors.titleColor1),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(width: 1,color: Style.CustomColors.secondaryColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(width: 1,color: Style.CustomColors.secondaryColor),
                        ),
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(color: Style.CustomColors.titleColor1),
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Style.CustomColors.secondaryColor),
                        icon: Icon(EvaIcons.email, color: Style.CustomColors.secondaryColor),
                      )
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  //password
                  TextFormField(
                    controller: passwordlController,
                    style: TextStyle(color: Style.CustomColors.titleColor1),
                    obscureText: true,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(width: 1,color: Style.CustomColors.secondaryColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(width: 1,color: Style.CustomColors.secondaryColor),
                        ),
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(color: Style.CustomColors.titleColor1),
                        labelText: 'Passoword',
                        labelStyle: TextStyle(color: Style.CustomColors.secondaryColor),
                        icon: Icon(EvaIcons.lock, color: Style.CustomColors.secondaryColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Style.CustomColors.secondaryColor, width: 1.0)
                        )
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  //confirm password
                  SizedBox(
                    height: 5.0,
                  ),
                  ButtonForm(
                    height: 40.0,
                    width: MediaQuery.of(context).size.width * 0.5,
                    colorButton: Style.CustomColors.secondaryColor,
                    titleButton: "Register",
                    function: (){
                      if(isButtonEnable(state)){
                      _onFormSubmitted();
                      }}
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("You have a account?", style: TextStyle(color: Style.CustomColors.titleColor1)),
                      TextButton(
                        onPressed: () { Navigator.pop(context);},
                        child: Text('Singin', style: TextStyle(color: Style.CustomColors.secondaryColor)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } ,
      ),
    );
  }
  void _onEmailChange() {
    registerBloc.add(RegisterEmailChanged(email: emailController.text));
  }

  void _onPasswordChange() {
    registerBloc.add(RegisterPasswordChanged(password: passwordlController.text));
  }
  void _onFormSubmitted() {
    registerBloc.add(RegisterSubmitted(email: emailController.text,password: passwordlController.text));
  }
  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordlController.dispose();
    super.dispose();
  }
}

