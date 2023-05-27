
import 'package:flutter/material.dart';


const String authURL = "http://192.168.0.36:88";

const String getOrganizationURL = "$authURL/get/api/organization";
const String getBusURL = "$authURL/get/api/bus";

const String loginURL = "$authURL/login/api/user";
const String registerURL = "$authURL/register/api/user";

const String generalURL = "http://192.168.0.36:89";

const String sendTokenURL = "$generalURL/verification/api/send/token";

Color yellow = const Color.fromRGBO(253, 184, 19, 1);
Color black = const Color.fromRGBO(42, 46, 67, 1);
Color txtBoxblack = const Color.fromRGBO(69, 79, 99, 1);

ButtonStyle buttonStyle = TextButton.styleFrom(
  foregroundColor: Colors.white, // text color
  backgroundColor: Color.fromRGBO(253, 184, 19, 1),
);
