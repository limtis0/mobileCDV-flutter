/*
import '../../main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_cdv/src/lib/localization/localization_manager.dart';
import 'package:mobile_cdv/src/logic/globals.dart' as globals;
import '../logic/main_activity.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  String _login = '';
  String _password = '';

  String _error = '';

  void processLogin(String log, String pass) async {
    try{
      await activitySignIn(log, pass);
      showTimetable();
    } catch(e){
      _error = getTextFromKey("Login.Page.error");
    }
  }

  @override
  Widget build(BuildContext context) {
    if(globals.isLoggined){
      return Profile()
    }else {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Image(
                  image: AssetImage('./assets/images/logo-text.png'),
                  width: 170,
                  height: 170,
                ),
                Text(
                  _error,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
                Form(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                            getTextFromKey("Login.Page.Email")
                        ),
                      ),
                      SizedBox(
                        width: 230,
                        child: TextField(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: getTextFromKey("Login.Page.Hint.login"),
                          ),
                          onChanged: (value){
                            _login = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                            getTextFromKey("Login.Page.Password")
                        ),
                      ),
                      SizedBox(
                        width: 230,
                        child: TextField(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: getTextFromKey("Login.Page.Hint.password"),
                          ),
                          onChanged: (value){
                            _password = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: (){
                            processLogin(_login, _password);

                          },
                          child: Text(
                              getTextFromKey("Login.Page.btn")
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            processLogin("izakharov@edu.cdv.pl", "34r+KktH3VA");
          },
          child: Text(
              "Debug"
          ),
        ),
      );
    }
  }
}
 */