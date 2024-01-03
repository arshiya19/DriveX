/*
  1. Adjusted paddings with Chatgpt
  2. Referred 467-MW class for google sign in function
  3. For code syntax took help from Chatgpt
*
*/
import 'dart:async';
import 'package:finalproject/firebase_options.dart';
import 'package:finalproject/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'tabs.dart';

// ignore: camel_case_types
class login extends StatelessWidget {
  const login({Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.cyan),
      ),
      home: const MyHomePage(title: 'DriveX'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  final String coming = "";

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _econtroller = TextEditingController(), _pcontroller = TextEditingController();
  String input = "";
  bool password = true, _initialized = false, _isLoading = true;
  GoogleSignInAccount? googleUser;
  late String _email, _password;
  final auth = FirebaseAuth.instance;
  late LatLng _currentPosition;

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

  //modifed through GPT
  Future<void> initializeDefault() async {
    FirebaseApp app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _initialized = true;
    if (kDebugMode) {
      print("Initialized default Firebase app $app");
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    if (!_initialized) {
      await initializeDefault();
    }
    // Trigger the authentication flow
    googleUser = await GoogleSignIn().signIn();
    setState(() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(loaded:_isLoading, position: _currentPosition,)));
    });



    if (kDebugMode) {
      print(googleUser!.displayName);
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Container(
          height: 500.0,
          width: 400.0,
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(11),
                alignment:Alignment.topLeft,
                child: const Text("Login",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 25),textAlign: TextAlign.left,
                ),),
              //email
              Container (
                  margin: const EdgeInsets.all(9),
                  child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text('E-mail:',style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20))))),
              SizedBox(
                width : 350,
                child: TextFormField(
                  controller: _econtroller,
                  validator: (String? value){if(value != null && (value.contains('@gmail.com') || value.contains('@outlook.com'))){
                    if(value.contains(',')){return 'invalid email id';}else{return null;}}
                  else{return  (value != null && (!value.contains('@gmail.com') ||
                      !value.contains('@outlook.com'))) ? 'invalid email id' : null;}},
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    hintText: "Enter email id",
                  ),
                ),
              ),
              const Text(" "),
              //password
              Container(
                  margin: const EdgeInsets.all(9),
                  child : const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text('Password:',style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                      ))),
              SizedBox(
                width : 350,
                child: TextFormField(
                  controller: _pcontroller,
                  validator: _textValidator,
                  obscureText: password,
                  obscuringCharacter:'*',
                  decoration: InputDecoration(
                    border:const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
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
              ),
              Container(
                  margin: const EdgeInsets.all(9),
                  child: const Align(
                      alignment: Alignment.centerRight,
                      child :Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: Text('Forgot Password?',style:TextStyle(fontWeight: FontWeight.bold))))),
              const Text(" "),
              ElevatedButton(
                child: const Text('Login', style: TextStyle(color: Colors.white)),
                onPressed: () async{
                  _email = _econtroller.text;
                  _password = _pcontroller.text;
                  try {
                    await auth.signInWithEmailAndPassword(email: _email, password: _password);
                    setState(() {
                      Navigator.pushReplacement(
                        context,
                       // https://docs.flutter.dev/cookbook/animation/page-route-animation
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return HomePage(loaded: _isLoading, position: _currentPosition); // Default to FirstRoute if the route is unknown.
                          },
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const Offset begin = Offset(0.0, 0.0);
                            const Offset end = Offset(0.0,0.0);
                            // const Offset end = Offset(0.0,0.0);
                            const Curve curve = Curves.ease;
                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logged In Successfully'),
                          duration : Duration(seconds : 2),
                        ),
                      );
                    });
                  }
                  catch(e)
                  {
                    if(e is FirebaseAuthException){
                      if(e.code == 'user-not-found'){
                        setState(() {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('invalid-login-credentials'),
                              duration : Duration(seconds : 2),
                            ),
                          );
                        });

                      }else if(e.code == 'wrong-password') {
                        setState(() {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Invalid password'),
                              duration : Duration(seconds : 2),
                            ),
                          );
                        });
                      }
                    }
                    // print('Error creating user: $e');
                  }
                  _econtroller.clear();
                  _pcontroller.clear();
                },
              ),
              const Text(" "),
              const Padding(
                padding:  EdgeInsets.symmetric(horizontal: 25.0),
                child :  Row(
                  children: [
                    Expanded(child: Divider(thickness: 0.5,color: Colors.grey),
                    ),
                    Text('Or continue With'),
                    Expanded(child: Divider(thickness: 0.5,color: Colors.grey),),
                  ],
                ),
              ),
              const Text(" "),
              IconButton(
                icon: Image.asset('assets/google.png'),
                iconSize: 40,
                onPressed: () {
                  print('logged in');
                  signInWithGoogle();

                },
              ),
            ],
          ),
        ),
      ),
      GestureDetector(
        onTap: (){
          Navigator.push(
            context,
            //https://docs.flutter.dev/cookbook/animation/page-route-animation
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return const SignUpPage(); // Default to FirstRoute if the route is unknown.
              },
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const Offset begin = Offset(0.0, 0.0);
                const Offset end = Offset(0.0,0.0);
                // const Offset end = Offset(0.0,0.0);
                const Curve curve = Curves.ease;
                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
          );
        },
        child : const Text('New User? SignUp Here',style: TextStyle(decoration: TextDecoration.underline,fontWeight: FontWeight.bold),),
      ),
    ];
  }
}