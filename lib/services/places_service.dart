import 'package:http/http.dart' as http;
import 'package:idee_flutter/models/place.dart';
import 'package:idee_flutter/models/place_search.dart';
import 'dart:convert' as convert;

class PlacesService {
  final key = 'AIzaSyDRZXo9fz9-2ij9cEDv57V98LYAmQgg0yA';

  Future<List<PlaceSearch>> getAutocomplete(String search) async {
    var response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=(cities)&key=$key&sensor=false&language=th&region=TH'));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  Future<Place> getPlace(String placeId) async {
    var response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key&sensor=false&language=th&region=TH'));
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['result'] as Map<String, dynamic>;
    return Place.fromJson(jsonResult);
  }
}
