import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';


class Location {
  final LatLng latLng;
  final String? image;
  final String name;
  final String Id;

  Location(this.Id,this.latLng, this.image,this.name);
}

// class BackendService {
//   static Future<List<Map<String, String>>> getSuggestions(String query) async {
//     await Future<void>.delayed(Duration(seconds: 1));
// //EXY-115-AL
//
//     return List.generate(3, (index) {
//       return {'plate': query + index.toString(), 'location': Random().nextInt(100).toString()};
//     });
//     // return List.generate(3, (index) {
//     //   return {'name': query + index.toString(), 'price': Random().nextInt(100).toString()};
//     // });
//   }
// }

class BusDetailsService {
  static Future<List<Map<String, String>>> getSuggestions(String? query) async {
    await Future<void>.delayed(Duration(seconds: 1));
    //EXY-115-AL
if(query==null || query==""){
  print("QUERY IS NULL");
  return [];
}

    List<Map<String, String>> suggestions =[
       {'plate': "EXY-115-AL", 'route': "yaba"},
      {'plate': "ABC-115-AL", 'route': "surulere"},
      {'plate': "RTY-115-AL", 'route': "lekki"},
      {'plate': "ZZZ-115-AL", 'route': "lekki"}
      ];

    // Filter the suggestions array based on the query
    suggestions = suggestions.where((suggestion) =>suggestion['plate'].toString().toUpperCase().contains(query.toUpperCase())).toList();

    return suggestions;
  }
}
