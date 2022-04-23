import 'package:flutter/material.dart';
import 'package:mobile_cdv/src/lib/localization/localization_manager.dart';
import 'package:mobile_cdv/src/logic/storage/globals.dart' as globals;
import 'package:mobile_cdv/src/logic/theme_manager.dart';
import 'package:mobile_cdv/src/widgets/utils.dart';
import '../logic/main_activity.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileStatePage();
}

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class ProfileLogin extends StatefulWidget {
  const ProfileLogin({Key? key}) : super(key: key);

  @override
  State<ProfileLogin> createState() => _ProfileState();
}

class _ProfileStatePage extends State<Profile> {

  void processSignOut() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext dialogContext){
          return const LoadingIndicator();
        }
    );
    await activitySignOut();
    globals.isLoggedIn = false;
    Navigator.pop(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 10),
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
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}

class _LoginWidgetState extends State<LoginWidget> {

  double w = 170;
  double h = 170;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image(
              image: const AssetImage('./assets/images/logo-text.png'),
              width: w,
              height: h,
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
                      cursorColor: themeOf(context).functionalObjectsColor,
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
                      onChanged: (value){
                        globals.email = value;
                      },
                      onTap: (){
                        setState(() {
                          w = 0;
                          h = 0;
                        });
                      },
                      onEditingComplete: (){
                        setState(() {
                          w = 170;
                          h = 170;
                        });
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
                      obscureText: true,
                      cursorColor: themeOf(context).functionalObjectsColor,
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
                      onChanged: (value){
                        globals.pass = value;
                      },
                      onTap: (){
                        setState(() {
                          w = 0;
                          h = 0;
                        });
                      },
                      onEditingComplete: (){
                        setState(() {
                          w = 170;
                          h = 170;
                        });
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ProfileState extends State<ProfileLogin> {

  Widget? currentScreen;

  final List<Widget> _screens = [
    const Profile(),
    const LoginWidget()
  ];

  String _error = '';

  void processLogin(String log, String pass) async {
    try{
      showDialog(
          context: context,
          builder: (BuildContext dialogContext){
            return const LoadingIndicator();
          }
      );
      await activitySignIn(log, pass, true);
      globals.isLoggedIn = true;
      Navigator.pop(context);
      setState(() {
        _text = getTextFromKey("Profile.signOut");
      });
    } catch(e){
      setState(() {
        _error = getTextFromKey("Login.Page.error");
      });
      Navigator.pop(context);
    }
  }

  void processSignOut() async {
    await activitySignOut();
    setState(() {
      _text = getTextFromKey("Login.Page.btn");
    });
  }

  String _text = _retText();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            _error,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
          _screens[globals.isLoggedIn ? 0 : 1],
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  themeOf(context).buttonColor!
              )
            ),
            child: Text(
                _text,
              style: const TextStyle(
                color: Colors.white
              ),
            ),
            onPressed: (){
              if(!globals.isLoggedIn){
                processLogin(globals.email, globals.pass);
                _text = getTextFromKey("Login.Page.btn");
                setState(() {
                  _error = "";
                });
              }else {
                showDialog(
                    context: context,
                    builder: (context) {
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
                                    onPressed: (){
                                      processSignOut();
                                      Navigator.pop(context);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(
                                          themeOf(context).buttonColor!
                                      )
                                    ),
                                  ),
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
                    );
                _text = getTextFromKey("Profile.signOut");
                setState(() {
                  _error = "";
                });
              }
            },
          )
        ],
      ),
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
        ),
      )
    );
  }
}


String _retText(){
  if(globals.isLoggedIn) {
    return getTextFromKey("Profile.signOut");
  }else {
    return getTextFromKey("Login.Page.btn");
  }
}