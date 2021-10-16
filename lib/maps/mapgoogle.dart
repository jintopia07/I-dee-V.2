import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:idee_flutter/maps/blocs/application_bloc.dart';
import 'package:idee_flutter/models/place.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class MapsGoogle extends StatefulWidget {
  const MapsGoogle({Key key}) : super(key: key);

  @override
  _MapsGoogleState createState() => _MapsGoogleState();
}

class _MapsGoogleState extends State<MapsGoogle> {
  Completer<GoogleMapController> _mapController = Completer();
  StreamSubscription locationSubscription;
  StreamSubscription boundsSubscription;
  final _locationController = TextEditingController();

  @override
  void initState() {
    final applicationBloc =
        Provider.of<Applicationbloc>(context, listen: false);

    //Listen for selected Location
    locationSubscription =
        applicationBloc.selectedLocation.stream.listen((place) {
      if (place != null) {
        _locationController.text = place.name;
        _goToPlace(place);
      } else
        _locationController.text = "";
    });

    applicationBloc.bounds.stream.listen((bounds) async {
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    });
    super.initState();
  }

  @override
  void dispose() {
    final applicationBloc =
        Provider.of<Applicationbloc>(context, listen: false);
    applicationBloc.dispose();
    _locationController.dispose();
    locationSubscription.cancel();
    boundsSubscription.cancel();
    super.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<Applicationbloc>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // appBar: AppBar(
        //   title: Text('Maps'),
        //   backgroundColor: Colors.deepPurple[600],
        // ),
        body: (applicationBloc.currentLocation == null)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                margin: EdgeInsets.all(20),
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        style: TextStyle(fontFamily: "Kanit"),
                        controller: _locationController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: 'ค้นหาที่อยู่',
                          suffixIcon: Icon(Icons.search),
                          hintStyle: TextStyle(fontFamily: "Kanit"),
                        ),
                        onChanged: (value) =>
                            applicationBloc.searchPlaces(value),
                        onTap: () => applicationBloc.clearSelectedLocation(),
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          height: 300.0,
                          child: GoogleMap(
                            myLocationEnabled: true,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                  applicationBloc.currentLocation.latitude,
                                  applicationBloc.currentLocation.longitude),
                              zoom: 11.0,
                            ),
                            onMapCreated: (GoogleMapController controller) {
                              _mapController.complete(controller);
                            },
                            markers: Set<Marker>.of(applicationBloc.markers),
                          ),
                        ),
                        if (applicationBloc.searchResults != null &&
                            applicationBloc.searchResults.length != 0)
                          Container(
                            height: 300.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(.6),
                                backgroundBlendMode: BlendMode.darken),
                          ),
                        if (applicationBloc.searchResults != null &&
                            applicationBloc.searchResults.length != 0)
                          Container(
                            height: 200.0,
                            child: ListView.builder(
                              itemCount: applicationBloc.searchResults.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    applicationBloc
                                        .searchResults[index].description,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Kanit"),
                                  ),
                                  onTap: () {
                                    applicationBloc.setSelectedLocation(
                                        applicationBloc
                                            .searchResults[index].placeId);
                                  },
                                );
                              },
                            ),
                          ),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _goToPlace(Place place) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
                place.geometry.location.lat, place.geometry.location.lng),
            zoom: 14.0),
      ),
    );
  }
}
