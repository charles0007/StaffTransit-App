import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusDetailsPage  {
  final Map<String, String>? detail;

  BusDetailsPage({required this.detail});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.dialog(
        // context: context,
        // builder: (BuildContext context) =>
        AlertDialog(
          title: const Text('Are you sure'),
          content: Text(
            detail != null
                ? 'You want to enable location with plate number ${detail!['plate']} and route ${detail!['route']}.'
                : '',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () => Get.back(),
            ),
            TextButton(
              child: const Text('OKAY'),
              onPressed: () {},
            ),
          ],
        ),
      );
    });

    return Scaffold(
      body: Container(),
    );
  }
}
