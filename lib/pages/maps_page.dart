import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/src/types/marker_updates.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../WeatherApiLogic.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

late CameraPosition initialCameraPosition;

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  String dropdownValue = 'One';

  List<Marker> _locations = [];

  int celsius = 0;

  final TextEditingController _Controller = TextEditingController();
  bool needShow = false;
  String searchValue = '';
  FocusNode focusNode = FocusNode();

  updateMarker(MarkerId id) {
    final marker =
        markers.values.toList().firstWhere((item) => item.markerId == id);

    Marker _marker = Marker(
      markerId: marker.markerId,
      onTap: () {
        print("tapped");
      },
      position: LatLng(marker.position.latitude, marker.position.longitude),
      icon: marker.icon,
      infoWindow: InfoWindow(title: 'my new Title'),
    );

    setState(() {
      //the marker is identified by the markerId and not with the index of the list
      markers[id] = _marker;
    });
  }

  updateAllMarkers() {
    for (int i = 0; i < 10; i++) {
      updateMarker(MarkerId(i.toString()));
    }
  }

  getMarkerData() async {
    FirebaseFirestore.instance.collection('entityData').get().then((myMarkers) {
      if (myMarkers.docs.isNotEmpty) {
        for (int i = 0; i < myMarkers.docs.length; i++) {
          final MarkerId markerId = MarkerId(i.toString());
          final Marker marker = Marker(
              markerId: markerId,
              position: LatLng(myMarkers.docs[i].get('lattitude'),
                  myMarkers.docs[i].get('longtitude')),
              infoWindow: InfoWindow(
                  title: myMarkers.docs[i].get('name'),
                  snippet: myMarkers.docs[i].get('lattitude').toString() +
                      ' ,' +
                      myMarkers.docs[i].get('longtitude').toString() +
                      ' ,' +
                      myMarkers.docs[i].get('weather').toString() +
                      '°C'),
              icon: BitmapDescriptor.defaultMarker,
              onTap: () {
                //updateMarker(markerId);
              });

          setState(() {
            markers[markerId] = marker;
          });
        }
        _locations = markers.values.toList();
        initialCameraPosition =
            CameraPosition(target: markers.values.first.position, zoom: 5);
      }
    });
  }

  @override
  void initState() {
    getMarkerData();
    //updateAllMarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: GoogleMap(
                    zoomGesturesEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    initialCameraPosition: initialCameraPosition,
                    markers:
                        Set<Marker>.of(markers.values), //markers to show on map
                    mapType: MapType.normal, //map type
                    onTap: (latLng) {
                      setState(() {
                        focusNode.unfocus();
                        needShow = false;
                      });

                      print('123111111111111111111111111111111111111');
                      print(needShow);
                      //updateMarker(MarkerId('0'));
                    },
                    onMapCreated: (controller) {
                      setState(() {
                        mapController = controller;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    //autofocus: true,
                    focusNode: focusNode,
                    maxLines: 1,
                    onTap: () {
                      setState(() {
                        needShow = true;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        searchValue = value;
                      });
                      _locations = markers.values.toList();
                      if (searchValue.length >= 3) {
                        _locations.clear();
                        _locations = markers.values.where((element) {
                          return element.infoWindow.title!
                              .toLowerCase()
                              .contains(searchValue.toLowerCase());
                        }).toList();
                      } else {
                        _locations = markers.values.toList();
                      }
                    },
                    controller: _Controller,
                    decoration: const InputDecoration(
                        fillColor: Colors.black12,
                        filled: true,
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)))),
                  ),
                ),
                if (_locations.isNotEmpty && focusNode.hasFocus)
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    margin: const EdgeInsets.fromLTRB(10, 78, 0, 10),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25.0)),
                        color: Colors.black.withOpacity(.6),
                        backgroundBlendMode: BlendMode.darken),
                  ),
                if (_locations.isNotEmpty && focusNode.hasFocus)
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    margin: const EdgeInsets.fromLTRB(10, 78, 0, 10),
                    child: ListView.builder(
                        itemCount: _locations.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              _locations[index].infoWindow.title ??
                                  'default text',
                              style: const TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                mapController.animateCamera(
                                    CameraUpdate.newLatLngZoom(
                                        _locations[index].position, 5));
                                focusNode.unfocus();
                                needShow = false;
                              });
                            },
                          );
                        }),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
