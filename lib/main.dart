import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lab/WeatherApiLogic.dart';
import 'package:lab/pages/entities_page.dart';
import 'package:lab/pages/maps_page.dart';
import 'package:lab/pages/settings_page.dart';
import 'package:splashscreen/splashscreen.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
        name: "DEFAULT",
        options: const FirebaseOptions(
          apiKey: "AIzaSyAk9D1O3LKOvk3yCfBRq5oLDrny4svNZb8",
          appId: "1:311895082409:web:b79b3d16d3fe05ba7ef0b8",
          messagingSenderId: "311895082409",
          projectId: "weatherflutter-1a4b9",
        )).whenComplete(() {});
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Splash2(),
    );
  }
}

late Image image;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  Future<List<Image>> _processingData() {
    return Future.wait([
      firstFuture(),
      firstFuture(),
      firstFuture(),
      firstFuture(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //   future: _processingData(),
    //   builder: (BuildContext context, AsyncSnapshot snapshot){
    //     if(snapshot.connectionState == ConnectionState.waiting) {
    //       print('asd');
    //       return SplashScreen(
    //         seconds: 4,
    //         navigateAfterSeconds: const MyHomePage(),
    //         title: const Text(
    //           'Weather App',
    //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0),
    //         ),
    //         image: Image.asset("assets/images/clouds.png"),
    //         loadingText: const Text('Loading \n\n\n''@bsuir 2022', textAlign: TextAlign.center,),
    //         photoSize: 100.0,
    //         loaderColor: Colors.deepOrange,
    //       );
    //     }
    //       ///Splash Screen
    //     else{
    //       print('sad');
    //       return MyHomePage();
    //     }
    //           ///Main Screen
    //   },
    // );
    return FutureBuilder(
      future: Future.wait([
        firstFuture(),
        firstFuture(),
        firstFuture(),
        firstFuture(),
      ]),
      builder: (context, AsyncSnapshot<List<Image>> snapshot) {
        print('CHALLENGE');
        if (!snapshot.hasData) {
          return SplashScreen(
                      seconds: 4,
                      navigateAfterSeconds: const MyHomePage(),
                      title: const Text(
                        'Weather App',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0),
                      ),
                      image: Image.asset("assets/images/clouds.png"),
                      loadingText: const Text('Loading \n\n\n''@bsuir 2022', textAlign: TextAlign.center,),
                      photoSize: 100.0,
                      loaderColor: Colors.deepOrange,
                    );
        } else {
          return MyHomePage();
        }
      },
    );
  }


  Future<Image> firstFuture() async {
    print('async begin');
    return Future<Image>.delayed(Duration(milliseconds: 4000), (){
      return image = Image.network(
          'https://firebasestorage.googleapis.com/v0/b/weatherflutter-1a4b9.appspot.com/o/washington.jpg?alt=media&token=a105f521-a37a-4f5d-9dc0-0e08a8aa7d78');
    });
  }
}

//
class Splash2 extends StatefulWidget {
  const Splash2({Key? key}) : super(key: key);

  @override
  _Splash2State createState() => _Splash2State();
}

class _Splash2State extends State<Splash2> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: const MyHomePage(),
      title: const Text(
        'Weather App',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0),
      ),
      image: Image.asset("assets/images/clouds.png"),
      loadingText: const Text(
        'Loading \n\n\n' '@bsuir 2022',
        textAlign: TextAlign.center,
      ),
      photoSize: 100.0,
      loaderColor: Colors.deepOrange,
    );
  }
}

//
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

int currentIndex = 0;

class _MyHomePageState extends State<MyHomePage> {
  List pages = [const EntityPage(), const MapPage(), const SettingsPage()];

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Weather App"),
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 40,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        onTap: onTap,
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.list_outlined), label: "Entities"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings')
        ],
      ),
    );
  }
}
