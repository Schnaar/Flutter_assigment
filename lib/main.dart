import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



void main() => runApp(const BottomNavigationBarExampleApp());

class BottomNavigationBarExampleApp extends StatelessWidget {
  const BottomNavigationBarExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );

    return MaterialApp(
      title: 'Roberts rodeo',
      themeMode: ThemeMode.system, // Use the system theme mode
      theme: ThemeData.light(), // Default light theme
      darkTheme: ThemeData.dark(), // Default dark theme
      home: BottomNavigationBarExample(),
    );
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ThemeParkScreen(),
    FunScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roberts rodeo'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Rides',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Fun Screen',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _locationMessage = '';
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  LatLng _center = const LatLng(0.0, 0.0);
  late GoogleMapController mapController;



  @override
  void initState() {
    super.initState();
    _getLocation();
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      setState(() {
        _connectivityResult = results.isNotEmpty ? results[0] : ConnectivityResult.none;
      });
    });
  }

  _getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    }
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);


    setState(() {
      _center = LatLng(position.latitude, position.longitude);
      _locationMessage = "Latitude: ${position.latitude}, Longitude: ${position.longitude}";


    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    String connectionStatus = "";

    switch (_connectivityResult) {
      case ConnectivityResult.mobile:
        connectionStatus = "Mobile data connection is being used.";
        break;
      case ConnectivityResult.wifi:
        connectionStatus = "Wi-Fi connection is being used.";
        break;
      case ConnectivityResult.bluetooth:
        connectionStatus = "Bluetooth connection is being used.";
        break;
      case ConnectivityResult.ethernet:
        connectionStatus = "Ethernet connection is being used.";
        break;
      case ConnectivityResult.other:
        connectionStatus = "Other connection is being used.";
        break;
      case ConnectivityResult.vpn:
        connectionStatus = "Vpn connection is being used.";
        break;
      case ConnectivityResult.none:
        connectionStatus = "No connection.";
        break;
    }

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              'Welcome to Roberts rodeo',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Where the magic happens',
              style: TextStyle(fontSize: 25.0),
            ),
            Image(image: AssetImage('assets/flowers.webp')),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to a land of wonder, imagination, and fun here at Roberts rodeo.',
                    style: TextStyle(fontSize: 17.0),
                  ),
                  Text(
                    'There is tons to do, from thrilling rides to beautiful gardens; there is sure to be something for you to do at this whimsical rocking wonderland.',
                    style: TextStyle(fontSize: 17.0),
                  ),
                  Text(
                    'There is tons to do, from thrilling rides to beautiful garden there is sure to be something for you to do at this whimsical rocking wonderland',
                    style: TextStyle(fontSize: 17.0),
                  ),
                  Text(
                    'Get the lowdown on this world of fun where before starting your adventure',
                    style: TextStyle(fontSize: 17.0),
                  ),
                ],
              ),
            ),
            SizedBox(height:20),
            Text('Where to find us',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            if (_center.latitude != 0.0 && _center.longitude != 0.0)
            Container(
              height: 300, // Adjust height as needed

              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
                markers: {
                  const Marker(
                    markerId: const MarkerId("Roberts Rodeo"),
                    position: LatLng(52.738655658190375, -2.24369719112312),
                  ),
                }
              ),
            ),
            SizedBox(height: 20),

            Text(
              "Connection Status:",
              style: TextStyle(fontSize: 18),
            ),
            Center(
              child: Text(
                connectionStatus,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Text('Settings Screen'),
      ),
    );
  }
}

class ThemeParkScreen extends StatefulWidget {
  @override
  _ThemeParkScreenState createState() => _ThemeParkScreenState();
}

class _ThemeParkScreenState extends State<ThemeParkScreen> {
  List<dynamic> ridesAndGardens = [];

  @override
  void initState() {
    super.initState();
    loadRidesAndGardens();
  }

  Future<void> loadRidesAndGardens() async {
    var response;
    try {
      response = await http.get(Uri.parse('https://birtch.zapto.org/Online.json'));
      response=response.body;
    } catch (e) {
      print('Failed to fetch data from API. Loading offline data...');
      // Load data from local JSON file if offline
      response = await rootBundle.loadString('assets/rides_and_gardens.json');

    }


    setState(() {
      ridesAndGardens = json.decode(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theme Park'),
      ),
      body: ListView.builder(
        itemCount: ridesAndGardens.length,
        itemBuilder: (context, index) {
          final item = ridesAndGardens[index];
          return ListTile(
            title: Text(item['name']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(item: item),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final dynamic item;

  const DetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(item['description']),
            SizedBox(height: 20),
            Text(
              'Location:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(item['location']),
            SizedBox(height: 20),
            Text(
              'Capacity:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(item['capacity'].toString()),
            SizedBox(height: 20),
            Text(
              'Wait time:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(item['wait time'].toString()),
            SizedBox(height: 60),
            Image(image: AssetImage('assets/Images/${item["image"]}')),
          ],
        ),
      ),
    );
  }
}
class FunScreen extends StatefulWidget {
  @override
  _FunScreenState createState() => _FunScreenState();
}

class _FunScreenState extends State<FunScreen> {
  List<dynamic> FunFacts = [];
  List<double> _accelerometerValues = [0, 0, 0];
  List<double> _gyroscopeValues = [0, 0, 0];

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = <double>[event.x, event.y, event.z];
      });
    });
    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues = [event.x, event.y, event.z];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(
          title:Center(child:Text('Fun page!!!')) ,
        ),
      body: SingleChildScrollView(
        child:Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Do you need to spend some time waiting for a ride, well have some fun here',
              style: TextStyle(fontSize: 25.0)),
              SizedBox(height: 20,),
              Text('Fun facts',style: TextStyle(fontSize: 20.0)),
              SizedBox(height: 10,),
              Text('Fact 1',style: TextStyle(fontSize: 18.0),),
              SizedBox(height: 5,),
              Text('Roberts Rodeo was set up in 1997',style: TextStyle(fontSize: 16.0),),
              Text('Fact 2',style: TextStyle(fontSize: 18.0),),
              SizedBox(height: 5,),
              Text('Mr Robert Rodeo is the founder of Roberts Rodeo',style: TextStyle(fontSize: 16.0),),
              SizedBox(height: 10,),
              Text('Fact 3',style: TextStyle(fontSize: 18.0),),
              SizedBox(height: 5,),
              Text('The signature food at Roberts rodeo is the magic burger with a secret ingrediant',style: TextStyle(fontSize: 16.0),),
              SizedBox(height: 10,),
              Text('Fact 4',style: TextStyle(fontSize: 18.0),),
              SizedBox(height: 5,),
              Text('Roberts rodeos famous rollercoaster the large one is the 3rd highest rollercoaster in the UK',style: TextStyle(fontSize: 16.0),),
              SizedBox(height: 10,),
              Text('Fact 5',style: TextStyle(fontSize: 18.0),),
              SizedBox(height: 5,),
              Text('Nobody has ever failed to have fun at Roberts rodeo',style: TextStyle(fontSize: 16.0),),
              SizedBox(height: 10,),
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () { Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Quiz()),
                );},
                child: Text('Take the quiz'),
              ),
              Text('Accelerometer Values:',
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: 20.0),
              Text(
                'X: ${_accelerometerValues[0].toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                'Y: ${_accelerometerValues[1].toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                'Z: ${_accelerometerValues[2].toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                'Gyroscope Data:',
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: 10.0),
              Text(
                'X: ${_gyroscopeValues[0].toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                'Y: ${_gyroscopeValues[1].toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                'Z: ${_gyroscopeValues[2].toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18.0),
              ),

            ],
          ),
        ),
      ),
      ),
    );
  }
}


class Quiz extends StatefulWidget {
  const Quiz({Key? key}) : super(key: key);

  @override
  State<Quiz> createState() => _QuizState();
}



enum q1Awnser { awnser1, awnser2,awnser3,awnser4 }
enum q2Awnser{dath,robert,ryan,reginald}
enum q3Awnser{magic, hotdog, icream,cookie}
enum q4Awnser{third,first,fith,last}

class _QuizState extends State<Quiz> {

  q1Awnser? _q1awnser = q1Awnser.awnser1;
  q2Awnser? _q2awnser=q2Awnser.dath;
  q3Awnser? _q3awnser=q3Awnser.magic;
  q4Awnser? _q4awnser=q4Awnser.third;
  int _score=0;
  bool _clicked=false;
  void _calculateScore() {
    // Calculation logic goes here
    // For demonstration purposes, let's say the score is incremented by 1 each time the button is clicked
    setState(() {
      _score=0;
      if (_q1awnser==q1Awnser.awnser2){
        _score+=1;
      }
      if (_q2awnser==q2Awnser.robert){
        _score+=1;
      }
      if (_q3awnser==q3Awnser.magic){
        _score+=1;
      }
      if(_q4awnser==q4Awnser.third){
        _score+=1;
      }
      _clicked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
        home: Scaffold(
          appBar: AppBar(
            title: Text('Quiz'),
          ),
          body: SingleChildScrollView(
            child:Padding(
              padding: const EdgeInsets.all(16.0),

              child:Column(
                children: <Widget>[
                  Text('Question1: When was Roberts rodeo founded',style: TextStyle(fontSize: 20),),
                ListTile(
                  title: const Text('1998'),
                  leading: Radio<q1Awnser>(
                  value: q1Awnser.awnser1,
                groupValue: _q1awnser,
                onChanged: (q1Awnser? value) {
                setState(() {
                  _q1awnser = value;
                });
                },
              ),
            ),
              ListTile(
               title: const Text('1997'),
                leading: Radio<q1Awnser>(
                value: q1Awnser.awnser2,
                groupValue: _q1awnser,
                onChanged: (q1Awnser? value) {
                  setState(() {
                  _q1awnser = value;
                });
                },
              ),

            ),
              ListTile(
                title: const Text('2002'),
                leading: Radio<q1Awnser>(
                  value: q1Awnser.awnser3,
                  groupValue: _q1awnser,
                  onChanged: (q1Awnser? value) {
                    setState(() {
                      _q1awnser = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('1882'),
                leading: Radio<q1Awnser>(
                  value: q1Awnser.awnser4,
                  groupValue: _q1awnser,
                  onChanged: (q1Awnser? value) {
                    setState(() {
                      _q1awnser = value;
                    });
                  },
                ),
              ),
                Text('Question1: Who was roberts rodeos founder',style: TextStyle(fontSize: 20),),
                ListTile(
                  title: const Text('Dath Vader'),
                  leading: Radio<q2Awnser>(
                    value: q2Awnser.dath,
                    groupValue: _q2awnser,
                    onChanged: (q2Awnser? value) {
                      setState(() {
                        _q2awnser = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Robert Rodeo'),
                  leading: Radio<q2Awnser>(
                    value: q2Awnser.robert,
                    groupValue: _q2awnser,
                    onChanged: (q2Awnser? value) {
                      setState(() {
                        _q2awnser = value;
                      });
                    },
                  ),

                ),
                ListTile(
                  title: const Text('Ryan Rodeo'),
                  leading: Radio<q2Awnser>(
                    value: q2Awnser.ryan,
                    groupValue: _q2awnser,
                    onChanged: (q2Awnser? value) {
                      setState(() {
                        _q2awnser = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Sir Reginald Rowdejo'),
                  leading: Radio<q2Awnser>(
                    value: q2Awnser.reginald,
                    groupValue: _q2awnser,
                    onChanged: (q2Awnser? value) {
                      setState(() {
                        _q2awnser = value;
                      });
                    },
                  ),
                ),
                Text('Question1=3: What is the signature food',style: TextStyle(fontSize: 20),),
                ListTile(
                  title: const Text('Magic burger'),
                  leading: Radio<q3Awnser>(
                    value: q3Awnser.magic,
                    groupValue: _q3awnser,
                    onChanged: (q3Awnser? value) {
                      setState(() {
                        _q3awnser = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Space cookie'),
                  leading: Radio<q3Awnser>(
                    value: q3Awnser.cookie,
                    groupValue: _q3awnser,
                    onChanged: (q3Awnser? value) {
                      setState(() {
                        _q3awnser = value;
                      });
                    },
                  ),

                ),
                ListTile(
                  title: const Text('Sensual hot dog'),
                  leading: Radio<q3Awnser>(
                    value: q3Awnser.hotdog,
                    groupValue: _q3awnser,
                    onChanged: (q3Awnser? value) {
                      setState(() {
                        _q3awnser = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Sticky icecream'),
                  leading: Radio<q3Awnser>(
                    value: q3Awnser.icream,
                    groupValue: _q3awnser,
                    onChanged: (q3Awnser? value) {
                      setState(() {
                        _q3awnser = value;
                      });
                    },
                  ),
                ),
                  Text('Question1=3: What rank is the big one in tallest rollercoasts in the UK',style: TextStyle(fontSize: 20),),
                  ListTile(
                    title: const Text('Third'),
                    leading: Radio<q4Awnser>(
                      value: q4Awnser.third,
                      groupValue: _q4awnser,
                      onChanged: (q4Awnser? value) {
                        setState(() {
                          _q4awnser = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('First'),
                    leading: Radio<q4Awnser>(
                      value: q4Awnser.first,
                      groupValue: _q4awnser,
                      onChanged: (q4Awnser? value) {
                        setState(() {
                          _q4awnser = value;
                        });
                      },
                    ),

                  ),
                  ListTile(
                    title: const Text('Last'),
                    leading: Radio<q4Awnser>(
                      value: q4Awnser.last,
                      groupValue: _q4awnser,
                      onChanged: (q4Awnser? value) {
                        setState(() {
                          _q4awnser = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Fith'),
                    leading: Radio<q4Awnser>(
                      value: q4Awnser.fith,
                      groupValue: _q4awnser,
                      onChanged: (q4Awnser? value) {
                        setState(() {
                          _q4awnser = value;
                        });
                      },
                    ),
                  ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {_calculateScore(); },
                  child: Text('Submit awnser'),
                ),
                if (_clicked)
                  Text(
                    'Quiz Score: $_score',
                    style: TextStyle(fontSize: 24),
                  ),
          ],
        )
    )
      ),
    ),
    );
  }
}