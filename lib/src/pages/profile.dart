import 'package:flutter/material.dart';
import 'package:mobile_cdv/src/lib/localization/localization_manager.dart';
import 'package:mobile_cdv/src/logic/storage/globals.dart' as globals;
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
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).disabledColor,
              radius: 72,
              child: CircleAvatar(
                radius: 70,
                backgroundImage: globals.avatar,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
            ),
            Text(
              globals.name,
              style: const TextStyle(
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              globals.type.capitalize(),
              style: const TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Numer albumu: ${globals.album}',
              style: const TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
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
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
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

  Widget selPage(bool i){
    if(i){
      return _screens[0];
    }else{
      return _screens[1];
    }
  }

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
    globals.isLoggedIn = false;
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
          selPage(globals.isLoggedIn),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).disabledColor
              )
            ),
            child: Text(
                _text,
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
                    builder: (context){
                      return AlertDialog(
                        backgroundColor: Theme.of(context).cardColor,
                        title: Text(getTextFromKey("Profile.Confirmation")),
                        content: SizedBox(
                          height: 90,
                          child: Center(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Text(
                                      getTextFromKey("Login.ask")
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: ElevatedButton(
                                        child: Text(getTextFromKey("Profile.signOut")),
                                        onPressed: (){
                                          processSignOut();
                                          Navigator.pop(context);
                                        },
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(
                                                Theme.of(context).disabledColor
                                            )
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: ElevatedButton(
                                        child: Text(getTextFromKey("Profile.Cancel")),
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(
                                                Theme.of(context).disabledColor
                                            )
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ),
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
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      title: Text(getTextFromKey("Profile.Loading")),
      content: const SizedBox(
        width: 50,
        height: 5,
        child: LinearProgressIndicator(
        ),
      )
    );
  }
}


String _retText(){
  if(globals.isLoggedIn){
    return getTextFromKey("Profile.signOut");
  }else{
    return getTextFromKey("Login.Page.btn");
  }
}