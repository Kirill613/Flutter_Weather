import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lab/main.dart';
import 'package:lab/pages/maps_page.dart';
import 'package:lab/pages/settings_page.dart';

import '../WeatherApiLogic.dart';

class EntityPage extends StatefulWidget {
  const EntityPage({Key? key}) : super(key: key);

  @override
  _EntityPageState createState() => _EntityPageState();
}

class _EntityPageState extends State<EntityPage> {
  final TextEditingController _editingController = TextEditingController();

  CollectionReference allNoteCollection =
      FirebaseFirestore.instance.collection('entityData');
  List<DocumentSnapshot> documents = [];

  String searchText = '';
  String searchTextPrevious = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            onChanged: (value) {
              if ((value.length >= 3) ||
                  ((value.length == 2) && (searchTextPrevious.length == 3))) {
                setState(() {
                  searchText = value;
                  searchTextPrevious = value;
                });
              }
            },
            controller: _editingController,
            decoration: const InputDecoration(
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)))),
          ),
        ),
        Expanded(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('entityData')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: currentThemeColor,
                  ));
                }

                documents = snapshot.data!.docs;

                if (searchText.length >= 3) {
                  documents = snapshot.data!.docs;
                  documents = documents.where((element) {
                    return element
                        .get('name')
                        .toString()
                        .toLowerCase()
                        .contains(searchText.toLowerCase());
                  }).toList();
                  searchText = '';
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, position) {
                    return Card(
                      child: InkWell(
                        splashColor: Colors.grey.withAlpha(30),
                        onTap: () {
                          setState(() {
                            initialCameraPosition = CameraPosition(
                                target: LatLng(
                                    documents[position].get('lattitude'),
                                    documents[position].get('longtitude')),
                                zoom: 5);
                            currentIndex = 1;
                          });
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const MyHomePage(),
                              ),
                              (Route<dynamic> route) => false);
                        },
                        child: Row(
                            textDirection: TextDirection.ltr,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: 100,
                                height: 80,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(20), // Image border
                                  child: SizedBox.fromSize(
                                    //size: Size.fromRadius(48), // Image radius
                                    child: Image.network(
                                        documents[position].get('image')),
                                  ),
                                ),
                              ),
                              Text(documents[position].get('name'),
                                  style: TextStyle(
                                      fontSize: currentTextSize,
                                      color: currentColor)),
                              Column(
                                children: [
                                  Text(
                                      documents[position]
                                          .get('lattitude')
                                          .toStringAsFixed(2),
                                      style: TextStyle(
                                          fontSize: currentTextSize,
                                          color: currentColor)),
                                  Text(
                                      documents[position]
                                          .get('longtitude')
                                          .toStringAsFixed(2)
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: currentTextSize,
                                          color: currentColor)),
                                ],
                              ),
                              Flexible(
                                child: StreamBuilder(
                                    stream: getNumbers(
                                        documents[position].get('lattitude'),
                                        documents[position].get('longtitude')),
                                    builder: (
                                      BuildContext context,
                                      AsyncSnapshot<int> snapshot,
                                    ) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        return Icon(
                                          Icons.check_circle,
                                          color: currentThemeColor,
                                          size: currentTextSize,
                                        );
                                      }
                                      if (snapshot.hasData) {

                                        //
                                        //
                                        //
                                        FirebaseFirestore.instance
                                            .collection('entityData')
                                            .doc(documents[position].id)
                                            .update({'weather': snapshot.data});
                                        //
                                        //
                                        //

                                        return Text(
                                            snapshot.data!.toString() + '°C',
                                            style: TextStyle(
                                                fontSize: currentTextSize,
                                                color: currentColor));
                                      } else {
                                        return CircularProgressIndicator();
                                      }
                                    }),
                              ),
                            ]),
                      ),
                      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: currentThemeColor, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      //padding: const EdgeInsets.all(10),
                    );
                  },
                  itemCount: documents.length,
                );
              }),
        ),
      ],
    ));
  }
}
