import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';


class GoogleMapControllerMethod {


  Future<BitmapDescriptor> createMarkerImageFromText(String text) async {
   List<String> fullTxt=text.split(" ");
    String txt1=fullTxt.length>0?fullTxt[0][0].toString().toUpperCase():"";
   String txt2=fullTxt.length>1?fullTxt[1][0].toUpperCase():"";
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()
      ..color = Colors.blue;
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: txt1+txt2,
        style: TextStyle(
            fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final double radius = 30.0;
    canvas.drawCircle(Offset(radius, radius), radius, paint);
    textPainter.paint(
        canvas, Offset(
        radius - textPainter.width / 2, radius - textPainter.height / 2));
    final img = await pictureRecorder.endRecording().toImage(60, 60);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<BitmapDescriptor> createMarkerImageFromAsset(
      BuildContext context, String assetImg) async {

    final ImageConfiguration imageConfiguration =
    createLocalImageConfiguration(context, size: const Size.square(48));
    return await BitmapDescriptor.fromAssetImage(imageConfiguration, assetImg);
  }



}