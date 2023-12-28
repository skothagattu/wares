import 'dart:io';
import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wares/screens/Login.dart';
import 'package:wares/screens/compatibility.dart';
import 'package:wares/theme/theme_constants.dart';
import 'package:wares/theme/theme_manager.dart';
import 'AllProducts.dart';
import 'AllTsKs.dart';
import 'Service/ApiService.dart';
class MyHttpOverrides extends HttpOverrides{
  @override
HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
        ..badCertificateCallback = (X509Certificate cert, String host, int port){
      return true;
        };
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  bool isTokenExpired = true;

  if (token != null) {
    try {
      Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
      DateTime expiryDate = DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);
      isTokenExpired = DateTime.now().isAfter(expiryDate);
    } catch (e) {
      // Handle error or invalid token
    }
  }
  runApp(ProviderScope(child: MyApp(homeRoute: (!isTokenExpired) ? '/home' : '/')));
}
ThemeManager _themeManager = ThemeManager();
class MyApp extends StatefulWidget {
  final String homeRoute;
  const MyApp({super.key, required this.homeRoute});


  @override
  _MyAppState createState() => _MyAppState();
}
// This widget is the root of your application.
class _MyAppState extends State<MyApp>{

  @override
  void dispose() {
    _themeManager.removeListener(themeListner);
    super.dispose();
  }
  @override
  void initState() {
    _themeManager.addListener(themeListner);


    super.initState();
  }

  themeListner(){
    if(mounted){
      setState(() {

      });
    }
  }
  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Clear the token
    await prefs.remove('roles'); // Clear the roles
    Navigator.of(context).pushReplacementNamed('/'); // Navigate to login page
  }

  @override
  Widget build(BuildContext context) {
    ApiService apiService = ApiService(onLogout: () => _logout(context));
    return MaterialApp(
      theme: ThemeData(
          colorSchemeSeed: Colors.lightBlueAccent,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            toolbarHeight: 100,
            color: Colors.blue,

          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.black,
                primary: Colors.white38,
              )
          )
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            toolbarHeight: 100,

          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white60,
                primary: Colors.white38,
              )
          )
      ),
      themeMode: _themeManager.themeMode,
      initialRoute: 'homeRoute',
      routes: {
        '/': (context) => LoginPage(), // LoginPage is the first screen displayed
        '/home': (context) => CustomForm(apiService: apiService), // Navigate to this screen post-login
      },
    );
  }
}

class CustomForm extends StatelessWidget {
  final ApiService apiService;
  const CustomForm({super.key, required this.apiService});

  void navigateAllProds(BuildContext ctx){
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_){
      return AllProducts();
    }));
  }
  void navigateAllTsKs(BuildContext ctx){
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_){
      return AllTsKs();
    }));
  }
  void navigateCompat(BuildContext ctx){
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_){
      return CompatForm();
    }));
  }
  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Clear the token
    await prefs.remove('roles'); // Clear the roles
    Navigator.of(context).pushReplacementNamed('/'); // Navigate to login page
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(

        title: Image.asset('images/logo_cmi.png'),
        centerTitle: true,
        actions: [Switch(value: _themeManager.themeMode ==ThemeMode.dark, onChanged: (newValue){ _themeManager.toggleTheme(newValue);}),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),


      body:SingleChildScrollView(
        child: Column(
            children: [
              // Centered row with title

              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    /*  width: 400,
                height: 100,*/
                    child: Text(
                      'THE NEW WARES',
                      style: TextStyle(fontSize: 50, fontFamily: 'Oswald-VariableFont_wght', ),
                    ),
                  ),

                ],
              ),

              // Centered row with author name
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    /* width: 200,
                height: 80,*/
                    child: Text(
                      'BY SURYATEJA',
                      style: TextStyle(fontSize: 20, fontFamily: 'Lato'),

                    ),

                  ),

                ],

              ),
              const SizedBox(height: 100),
              // Column with two rows of buttons
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top row of buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: screenWidth *0.05),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            navigateAllTsKs(context);
                          },
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(25)),
                          child: const Text("T's, K's AND A's"),
                        ),
                      ),
                      SizedBox(width: screenWidth *0.05),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            navigateAllProds(context);
                          },
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(25)),
                          child: const Text("ALL PRODUCTS"),
                        ),
                      ),
                      SizedBox(width: screenWidth *0.05),

                    ],
                  ),
                  const SizedBox(height: 80),
                  SingleChildScrollView(child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(height: screenWidth *0.01),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(width: screenWidth *0.3),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            navigateCompat(context);
                                          },
                                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(5)),
                                          child: const Text("COMPATIBILITY"),
                                        ),
                                      ),
                                      SizedBox(width: screenWidth *0.3),
                                    ],
                                  ),
                          ],
                  )),

                ],

              ),



            ]

        ),
      ),
      // Bottom row of buttons

    );
  }
}