/*import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'first.dart';
import 'storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: [
    'email',
  ],
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.cyan),
      ),
      home: MyHomePage(title: 'Login Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  // String coming = "";
  final TextStorage storage = TextStorage();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // late Stream<DocumentSnapshot> _stream;
  late Future <String> _coming;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _econtroller = TextEditingController(), _pcontroller = TextEditingController();
  String input = "";
  bool password = false, _isLoading = true;
  late LatLng _currentPosition;

  @override
  void initState() {
    super.initState();
    password = true;
    _coming = widget.storage.readText();
    getLocation();
  }

  Future<void> getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    double lat = position.latitude;
    double long = position.longitude;
    LatLng location = LatLng(lat, long);

    setState(() {
      _currentPosition = location;
      _isLoading = false;
    });
    if (kDebugMode) {
      print("location codes: $_currentPosition");
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _coming = widget.storage.writeText(_econtroller.text).then((bool success) {
          if (success) {
            return _econtroller.text;
          } else {
            return "";
          }
        });
        String text = _econtroller.text;
        input = 'Saved Latest:-  $text';
      });

      runApp(MaterialApp(
        initialRoute: '/',
        onGenerateRoute: (settings) => PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
              return HomePage(loaded: _isLoading, position: _currentPosition);
              },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const Offset begin = Offset(0.0, 0.0);
            const Offset end = Offset.zero;
            const Curve curve = Curves.ease;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
      ));


    }
  }

  String? _textValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter some text";
    }
    if (value.trim().isEmpty) {
      return "Field left blank with white space";
    }
    if (value.contains("@")) {
      return "Do not use @";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title:Row(children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(right: 50.0), // Adjust the value as needed
            child: Align(alignment: Alignment.centerLeft, child: Text('DriveX')),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50.0), // Adjust the value as needed
            child: Align(alignment: Alignment.center, child: Text(widget.title)),
          )
        ]),
      ),
      body: Center(
        child: Container(
        height: 555.0,
        width: 444.0,
        color: Colors.grey[200],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: getBodyWidgetList(),
        ),
      ),
      ),
    );
  }

  List<Widget> getBodyWidgetList() {
    return <Widget>[
      Form(
        key: _formKey,
        child: Column(
          children: [
            /*FutureBuilder<String>(
                future: _coming,
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      '${snapshot.data}',
                      style: Theme.of(context).textTheme.headlineLarge,
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const CircularProgressIndicator();
                }),*/
            const Text("DriveX",style:TextStyle(fontWeight: FontWeight.bold)),
            const Align(alignment: Alignment.centerLeft, child: Text('E-mail:',style:TextStyle(fontWeight: FontWeight.bold))),
            TextFormField(
              controller: _econtroller,
              validator: (String? value){if(value != null && (value.contains('@gmail.com') || value.contains('@outlook.com'))){
                                            if(value.contains(',')){return 'invalid email id';}else{return null;}}
                                         else{return  (value != null && (!value.contains('@gmail.com') ||
                                              !value.contains('@outlook.com'))) ? 'invalid email id' : null;}},
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
                hintText: "Enter email id",
              ),
            ),
            const Text(" "),
            const Align(alignment: Alignment.centerLeft, child: Text('Password:',style:TextStyle(fontWeight: FontWeight.bold))),
            TextFormField(
              controller: _pcontroller,
              validator: _textValidator,
              obscureText: password,
              obscuringCharacter:'*',
              decoration: InputDecoration(
                border:const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
                hintText: "Enter password",
                suffixIcon: IconButton(
                  icon: Icon(password ? Icons.visibility : Icons.visibility_off,),
                 onPressed: (){
                    setState((){
                            password = !password;
                      });
                   },
                ),
              ),
            ),
            const Align(alignment: Alignment.centerRight, child: Text('Forgot Password?',style:TextStyle(fontWeight: FontWeight.bold))),
            const Text(" "),
            ElevatedButton(onPressed: _submit, child: const Text("Login")),
            const Text(" "),
            const Text('New User? Create Account'),
          ],
        ),
      ),
    ];
  }
}*/


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/firebase_options.dart';
import 'splash.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:ThemeData(),
      home: const SplashScreen(),
  )
  );
}