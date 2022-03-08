import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_cdv/src/lib/localization/localization_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  //final _formKey = GlobalKey<FormKey>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Image(
                image: AssetImage('./assets/images/logo-text.png'),
                width: 170,
                height: 170,
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
                    Container(
                      width: 230,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: getTextFromKey("Login.Page.Hint.login"),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                          getTextFromKey("Login.Page.Password")
                      ),
                    ),
                    Container(
                      width: 230,
                      child: TextField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: getTextFromKey("Login.Page.Hint.password"),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: (){
                          Navigator.pop(context);
                            //TODO Change function
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
    );
  }
}

//TODO Make page