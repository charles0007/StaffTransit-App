import 'package:flutter/material.dart';
import 'package:staff_transit2/constant_values.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _shareLocation = false;
  bool _notify = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,size: 30,),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 80,left: 20,right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: yellow
              ),
            ),
            SwitchListTile(
              title: Text('Share my location'),
              activeColor: yellow,
              value: _shareLocation,
              onChanged: (bool value) {
                setState(() {
                  _shareLocation = value;
                });
              },
            ),
            Text(
              'Notification',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: yellow
              ),
            ),
            SwitchListTile(
              title: Text('send notification'),
              activeColor: yellow,
              value: _notify,
              onChanged: (bool value) {
                setState(() {
                  _notify = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
