import 'package:flutter/material.dart';
import 'package:mobile_cdv/src/lib/localization/localization_manager.dart';
import 'package:mobile_cdv/src/logic/storage/globals.dart' as globals;
import 'package:mobile_cdv/src/logic/theme_manager.dart';
import 'package:mobile_cdv/src/widgets/utils.dart';
import '../logic/main_activity.dart';

class ProfilePage extends StatefulWidget {
  final Function callback;
  const ProfilePage(this.callback, {Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            backgroundColor: themeOf(context).functionalObjectsColor,
            radius: 72,
            child: CircleAvatar(
              radius: 70,
              backgroundImage: globals.avatar
            ),
          ),
          const SizedBox(height: 20),
          Text(
            globals.name,
            style: const TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
          Text(
            globals.type.capitalize(),
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          Text(
            'Numer albumu: ${globals.album}',
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),

          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    themeOf(context).buttonColor!
                )
            ),
            child: Text(
              getTextFromKey("Profile.signOut"),
              style: const TextStyle(color: Colors.white),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) { return LogoutDialogue(widget.callback); }
              );
            },
          ),
        ],
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  final Function callback;
  const LoginPage(this.callback, {Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void _processSignIn() async {
    try{
      showDialog(
          context: context,
          builder: (BuildContext dialogContext){
            return const LoadingIndicator();
          }
      );
      await activitySignIn(_loginField, _passwordField);
      globals.isLoggedIn = true;
      setState(() { _errorMessage = ''; });
      widget.callback();
    } catch(e) {
      setState(() {
        _errorMessage = getTextFromKey('Login.Page.error');
      });
    }
    Navigator.pop(context);
  }

  String _errorMessage = '';

  String _loginField = '';
  String _passwordField = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            _errorMessage,
            style: const TextStyle(color: Colors.red)
          ),

          const SizedBox(height: 16),
          const Image(
            image: AssetImage('./assets/images/logo-text.png'),
            width: 170,
            height: 170,
          ),

          Form(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 5),
                  child: Text(getTextFromKey("Login.Page.Email")),
                ),
                SizedBox(
                  width: 230,
                  child:
                  TextField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: themeOf(context).fieldTextColor!)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: themeOf(context).functionalObjectsColor!, width: 2)
                      ),
                      hintText: getTextFromKey("Login.Page.Hint.login"),
                    ),
                    onChanged: (value) { _loginField = value; },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 5),
                  child: Text(
                      getTextFromKey("Login.Page.Password")
                  ),
                ),
                SizedBox(
                  width: 230,
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: themeOf(context).fieldTextColor!)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: themeOf(context).functionalObjectsColor!, width: 2)
                      ),
                      hintText: getTextFromKey("Login.Page.Hint.password"),
                    ),
                    onChanged: (value) { _passwordField = value; },
                  ),
                ),
                const SizedBox(height: 5),

                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        themeOf(context).buttonColor!
                    )
                  ),
                  child: Text(
                    getTextFromKey("Login.Page.btn"),
                    style: const TextStyle(color: Colors.white),
                  ),
                  onPressed: () { _processSignIn(); },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ProfileLoginPage extends StatefulWidget {
  const ProfileLoginPage({Key? key}) : super(key: key);

  @override
  _ProfileLoginPageState createState() => _ProfileLoginPageState();
}

class _ProfileLoginPageState extends State<ProfileLoginPage> {
  ProfilePage? profilePage;
  LoginPage? loginPage;


  Widget? currentPage;

  @override
  void initState() {
    super.initState();
    profilePage = ProfilePage(callback);
    loginPage = LoginPage(callback);

    currentPage = globals.isLoggedIn ? profilePage : loginPage;
  }

  void callback() {
    setState(() {
      currentPage = globals.isLoggedIn ? profilePage : loginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: currentPage);
  }
}

class LogoutDialogue extends StatelessWidget {
  final Function callback;
  const LogoutDialogue(this.callback, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: themeOf(context).popUpBackgroundColor,
        title: Text(
          getTextFromKey("Profile.Confirmation"),
          textAlign: TextAlign.center,
        ),
        content:
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(getTextFromKey("Login.ask")),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text(
                    getTextFromKey("Profile.signOut"),
                    style: const TextStyle(color: Colors.white)
                  ),
                  onPressed: () async {
                    await activitySignOut();
                    Navigator.pop(context);
                    callback();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        themeOf(context).buttonColor!
                    )
                  ),
                ),
                const SizedBox(width: 1), // Backup spacing
                ElevatedButton(
                  child: Text(
                    getTextFromKey("Profile.Cancel"),
                    style: const TextStyle(color: Colors.white),
                  ),
                  onPressed: (){ Navigator.pop(context); },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        themeOf(context).buttonColor!
                  )
                ),
              ),
            ],
          )
        ],
      )
    );
  }
}

class LoadingIndicator extends StatelessWidget{
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: themeOf(context).popUpBackgroundColor,
      title: Text(getTextFromKey("Profile.Loading")),
      content: SizedBox(
        width: 50,
        height: 5,
        child: LinearProgressIndicator(
          color: themeOf(context).functionalObjectsColor,
          backgroundColor: themeOf(context).functionalObjectsColor!.withOpacity(0.5),
        ),
      )
    );
  }
}
