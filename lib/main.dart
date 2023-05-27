
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';

import 'package:staff_transit2/pages/GoogleMap.dart';
import 'package:staff_transit2/pages/login.dart';
import 'package:staff_transit2/pages/settings.dart';
import 'package:staff_transit2/pages/sub_maps/animate_camera.dart';
import 'package:staff_transit2/pages/sub_maps/lite_mode.dart';
import 'package:staff_transit2/pages/welcome.dart';

import 'constant_values.dart';

void main() {
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Staff Transit',
      theme: ThemeData(

        // primarySwatch: Colors.blue,
      ),
      home:  LoginPage(),
    );
  }
}

