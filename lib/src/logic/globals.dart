library mobile_cdv.globals;

import 'dart:io';

import 'package:flutter/material.dart';

import 'structures/schedule.dart';

// GLOBALS
Schedule schedule = Schedule();

bool isLoggined = false;
String path = "";

String name = "";
String type = "";
String album = "";

String email = "";
String pass = "";

ImageProvider avatar = Image(image: Image.file(File('$path/avatar.png')).image).image;

int theme = 0;