import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:idee_flutter/models/geometry.dart';
import 'package:idee_flutter/models/location.dart';
import 'package:idee_flutter/models/place.dart';
import 'package:idee_flutter/models/place_search.dart';
import 'package:idee_flutter/services/geolocator_services.dart';
import 'package:idee_flutter/services/places_service.dart';
import 'package:provider/provider.dart';

class Applicationbloc with ChangeNotifier {
  final geoLocatorService = GeolocatorService();
  final placesService = PlacesService();

  //Variables
  Position currentLocation;
  List<PlaceSearch> searchResults;
  //StreamController<Place> selectedLocation = StreamController<Place>();
  //StreamController<LatLngBounds> bounds = StreamController<LatLngBounds>();
  Place selectedLocationStatic;
  String placeType;
  List<Place> placeResults;
  List<Marker> markers = List<Marker>();
  StreamController<Place> selectedLocation =
      StreamController<Place>.broadcast();

  StreamController<LatLngBounds> bounds =
      StreamController<LatLngBounds>.broadcast();

  Applicationbloc() {
    setCurrentLocation();
  }

  setCurrentLocation() async {
    currentLocation = await geoLocatorService.getCurrentLocation();
    selectedLocationStatic = Place(
      name: null,
      geometry: Geometry(
        location: Location(
            lat: currentLocation.latitude, lng: currentLocation.longitude),
      ),
    );
    notifyListeners();
  }

  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutocomplete(searchTerm);
    notifyListeners();
  }

  setSelectedLocation(String placeId) async {
    var sLocation = await placesService.getPlace(placeId);
    selectedLocation.add(sLocation);
    selectedLocationStatic = sLocation;
    searchResults = null;
    notifyListeners();
  }

  clearSelectedLocation() {
    selectedLocation.add(null);
    selectedLocationStatic = null;
    searchResults = null;
    placeType = null;
    notifyListeners();
  }

  @override
  void dispose() {
    selectedLocation.close();
    bounds.close();
    super.dispose();
  }

  void close() {}
}
