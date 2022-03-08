import 'package:flutter/material.dart';
import 'package:mobile_cdv/src/lib/localization/localization_manager.dart';
import 'package:mobile_cdv/src/pages/login_page.dart';
import 'package:mobile_cdv/src/static.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              Text(
                "Email: izakharov@edu.cdv.pl"
              ),
              Text(
                  "Numer albumu: 27770"
              ),
              Text(
                  "Role: Student"
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginCanvas()));
                },
                child: Text(
                  getTextFromKey("Profile.signOut")
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