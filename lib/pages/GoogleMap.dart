import 'dart:async';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:staff_transit2/constant_values.dart';
import 'package:staff_transit2/controllers/google_map_controller.dart';
import 'package:staff_transit2/models/GoogleMap.dart';
import 'package:staff_transit2/pages/settings.dart';
import 'package:staff_transit2/pages/sub_pages/google_map/bus_details.dart';
import 'package:staff_transit2/pages/sub_pages/google_map/product.dart';
import 'package:staff_transit2/pages/sub_pages/google_map/snackbar.dart';

class GoogleMapsPage extends StatefulWidget {
  @override
  _GoogleMapsPageState createState() => _GoogleMapsPageState();
}

class _GoogleMapsPageState extends State<GoogleMapsPage> {
  late GoogleMapController _mapController;
  Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  GoogleMapController? controller;
  GoogleMapControllerMethod controllerMethod = new GoogleMapControllerMethod();
 Map<String,String> _selectedBus={};
  Set<Marker> _all_markers = Set();

  final Geolocator _geolocator = Geolocator();
  Position? _currentPosition;
  SnackBarCtl snackBarCtl=new SnackBarCtl();

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

  static const LatLng _defaultMapPosition =
      LatLng(7.43296265331129, 122.08832357078792);

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
        target: _currentPosition != null
            ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
            : _defaultMapPosition,
        tilt: 19.440717697143555,
        zoom: 19.151926040649414);
    controller.animateCamera(CameraUpdate.newCameraPosition(myCurrentPosition));
  }

  Future<void> _createMarker(LatLng location, String markerId,
      InfoWindow infoWindow, String name, String? imgPath) async {
    BitmapDescriptor? markerIcon;
    Marker myCreateMarker;
    if (imgPath != null) {
      markerIcon =
          await controllerMethod.createMarkerImageFromAsset(context, imgPath);
    } else {
      markerIcon = await controllerMethod.createMarkerImageFromText(name);
    }

    myCreateMarker = Marker(
      markerId: MarkerId(markerId),
      infoWindow: infoWindow,
      position: location,
      icon: markerIcon,
    );

    setState(() {
      _all_markers.add(myCreateMarker);
      print("_all_markers " + markerId);
    });
  }

  void _onMapCreated(GoogleMapController controllerParam) {
    _controller.complete(controllerParam);
  }

  void _LoadMultipleMap() {
    final List<Location> _locations = [
      Location("0", LatLng(6.501, 3.3449), null, "ayodeji"),
      Location("1", LatLng(6.5019, 3.34497), null, "deji oladele"),
      Location("2", LatLng(6.50193, 3.344976), null, "ayo oladele"),
      // Location(
      //   _currentPosition != null
      //       ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
      //       : _defaultMapPosition,
      //   'assets/images/user_location.png',
      // ),
    ];

    for (var location in _locations) {
      _createMarker(location.latLng, location.Id,
          InfoWindow(title: location.name), location.name, location.image);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentLocation().then((value) {
      _goToMyLocation();
      // _createMarker(_currentPosition != null
      //           ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
      //           : _defaultMapPosition,"login_user", InfoWindow(title: 'Username or Email'),"name",
      //     'assets/images/user_location.png');
      _LoadMultipleMap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapToolbarEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: _kLake,
            onMapCreated: _onMapCreated,
            markers: _all_markers, //<Marker>{_createMarker()},

            // onMapCreated: (GoogleMapController controller) {
            //   _controller.complete(controller);
            // },
          ),
          Positioned(
            top: 30.0,
            left: 30.0,
            right: 30.0,
            child: Container(
             // height: 50.0,
              decoration: BoxDecoration(
               color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: SizedBox(
                height: 50,
                child: TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                      autofocus: true,
                      style: DefaultTextStyle.of(context).style.copyWith(
                          fontStyle: FontStyle.italic,
                        color: Colors.black,
                       fontSize: 20
                      ),
                      decoration: InputDecoration(
                          // labelText: 'Search',
                          hintText: 'Select Bus',
                          prefixIcon: Icon(Icons.search,color: yellow,size: 30,),
                          border: OutlineInputBorder(),


                      )
                  ),
                  suggestionsCallback: (pattern) async {
                    return await BusDetailsService.getSuggestions(pattern);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      leading: Icon(Icons.bus_alert_rounded,color: yellow,),
                      title: Text(suggestion['plate']!),
                      subtitle: Text(suggestion['route']!),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                      AlertDialog(
                        title: const Text('Are you sure'),
                        content: Text(
                          suggestion != null
                              ? 'You want to enable location with plate number ${suggestion!['plate']} and route ${suggestion!['route']}.'
                              : '',
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('CANCEL'),
                            onPressed: (){
                              Navigator.of(context).pop();
                            Get.snackbar("Canceled", "route canceled");
                              },
                          ),
                          TextButton(
                            child: const Text('OKAY'),
                            onPressed: () {
                              setState(() {
                                _selectedBus={'${suggestion['plate']}':'${suggestion['route']}'};

                              });
                              Navigator.of(context).pop();
                              // Get.snackbar("Success", "Route selected successfully");
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(SnackBar(
                                  /// need to set following properties for best effect of awesome_snackbar_content
                                  elevation: 0,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  content: AwesomeSnackbarContent(
                                    title: 'Success!',
                                    message:
                                    'Route selected successfully!',

                                    /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                    contentType: ContentType.success,
                                  ),
                                ));
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          Positioned(
            top: 150.0,
            left: 10.0,
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
                  Get.to(()=>SettingsPage());
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
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
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
                    ' ${_selectedBus.isNotEmpty?'BUS '+_selectedBus.keys.toString()+' will arrive at 5:55AM':'Select Bus'} ',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    '12min - 6 miles away',
                    style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70),
                  ),
                  Text(
                    'Currently sharing location with all bus EKY-115-TY',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70),
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
