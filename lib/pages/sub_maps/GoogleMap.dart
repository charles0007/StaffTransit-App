import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:staff_transit2/constant_values.dart';

class GoogleMapsPage extends StatefulWidget {
  @override
  _GoogleMapsPageState createState() => _GoogleMapsPageState();
}

class _GoogleMapsPageState extends State<GoogleMapsPage> {
  late GoogleMapController _mapController;
    Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  GoogleMapController? controller;
  late BitmapDescriptor _markerMyIcon;


  final Geolocator _geolocator = Geolocator();
  Position? _currentPosition;
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    var status = await Permission.location.request();
print(status);
    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, ask user to enable them
      serviceEnabled = await Geolocator.openLocationSettings();
      if (!serviceEnabled) {
        // User did not enable location services, abort
        return;
      }
    }

    // Check if the app has permission to access location data
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      // App does not have permission to access location data and the user has
      // denied forever, so display a dialog
      await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Location Permissions'),
          content: const Text(
              'Please enable location permissions in the device settings.'),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('SETTINGS'),
              onPressed: () => openAppSettings(),
            ),
          ],
        ),
      );
      return;
    } else if (permission == LocationPermission.denied) {
      // App does not have permission to access location data and the user has
      // not yet decided, so request permission
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // User did not grant permission to access location data, abort
        return;
      }
    }

    // Get the current position of the device
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);



  }

  void openAppSettings() {
    SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    Future.delayed(Duration(milliseconds: 500), () {
      SystemChannels.platform.invokeMethod<void>('AppSettings.openAppSettings');
    });
  }


  static const LatLng _defaultMapPosition=LatLng(7.43296265331129, 122.08832357078792);

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
     bearing: 192.8334901395799,
      target: LatLng(7.43296265331129, 122.08832357078792),
     tilt: 19.440717697143555,
      zoom: 19.151926040649414);



  Future<void> _goToMyLocation() async {
    final GoogleMapController controller = await _controller.future;
print(_currentPosition);
    CameraPosition myCurrentPosition = CameraPosition(
        bearing: 192.8334901395799,
        target:   _currentPosition != null
            ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
            : _defaultMapPosition,
        tilt: 19.440717697143555,
        zoom: 19.151926040649414);
    controller.animateCamera(CameraUpdate.newCameraPosition(myCurrentPosition));
  }


  Future<Marker> _createMyMarker(BuildContext context) async {
    print("_create Marker");
_markerMyIcon=await _createMyMarkerImageFromAsset(context);
    //if (_markerMyIcon != null) {
      return Marker(
        markerId: const MarkerId('LOGIN EMAIL'),
        infoWindow: InfoWindow(title: "LOGIN USERNAME/EMAIL"),
        position: _currentPosition != null
            ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
            : _defaultMapPosition,
        icon:_markerMyIcon,// Icons.person_pin_circle_outlined //_markerMyIcon!,
      );
    // } else {
    //   return  Marker(
    //     markerId: MarkerId('LOGIN EMAIL'),
    //     infoWindow: InfoWindow(title: "LOGIN USERNAME/EMAIL"),
    //     position: _currentPosition != null
    //         ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
    //         : _defaultMapPosition,
    //   );
    // }
  }

  Future<BitmapDescriptor> _createMyMarkerImageFromAsset(BuildContext context) async {
    // if (_markerMyIcon == null) {
      final ImageConfiguration imageConfiguration =
      createLocalImageConfiguration(context, size: const Size.square(48));
     return BitmapDescriptor.fromAssetImage(
          imageConfiguration, 'assets/images/user_location.png');
          //.then(_updateBitmap);
    // }
  }

  void _updateBitmap(BitmapDescriptor bitmap) {
    setState(() {
      _markerMyIcon = bitmap;
    });
  }

  void _onMapCreated(GoogleMapController controllerParam) {
    _controller.complete(controllerParam);
    // setState(() {
    //   controller = controllerParam;
    // });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentLocation().then((value) {
      _goToMyLocation();
      setState(() {
        _createMyMarker(context);
       //  _createMyMarkerImageFromAsset(context);
      });
    });

  }

  @override
  Widget build(BuildContext context) {
   // _createMyMarkerImageFromAsset(context);
    //_getCurrentLocation();
    return Scaffold(
      body: Stack(
        children: [
          // GoogleMap(
          //   initialCameraPosition: const CameraPosition(
          //     target: _defaultMapPosition,
          //     zoom: 70.0,
          //   ),
          //   markers: <Marker>{_createMyMarker()},
          //   onMapCreated: _onMapCreated,
          // ),
          GoogleMap(
            mapToolbarEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: _kLake,
            onMapCreated: _onMapCreated,
            // markers: Future<Marker>{_createMyMarker(context)},

            // onMapCreated: (GoogleMapController controller) {
            //   _controller.complete(controller);
            // },
          ),
          Positioned(
            top: 40.0,
            left: 20.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.black,
                  size: 30,
                ),
                onPressed: () {
                  // Add your settings icon on pressed action here.
                },
              ),
            ),
          ),
          Positioned(
            bottom: 140.0,
            right: 20.0,
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.white.withOpacity(0.5),
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: IconButton(
color: Colors.white,
                tooltip: 'Share Location',
                // onPressed: _goToMyLocation,
                onPressed: () async {
                 // await _getCurrentLocation();
                 //  await _goToMyLocation();
                  setState(() {
                    _createMyMarker(context);
                  });
                },
                icon: Icon(
                  Icons.ios_share_outlined,
                  color: yellow,
                  size: 50,

                ),

              ),
            ),
          ),

          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              height: 110.0,
              decoration: BoxDecoration(
                color: black,
                borderRadius: BorderRadius.only(topLeft:Radius.circular(12) ,topRight: Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Text(
                    'BUS will arrive at 5:55AM',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                  Text(
                    '12min - 6 miles away',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70
                    ),
                  ),

                  Text(
                    'Currently sharing location with all bus EKY-115-TY',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),


    );
  }
}
