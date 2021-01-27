import 'package:flutter/material.dart';
import 'package:flutter_patron_bloc/src/bloc/provider.dart';
import 'package:flutter_patron_bloc/src/pages/home_page.dart';
import 'package:flutter_patron_bloc/src/pages/login_page.dart';
import 'package:flutter_patron_bloc/src/pages/product_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        initialRoute: "home",
        routes: {
          "login": (BuildContext context) => LoginPage(),
          "home": (BuildContext context) => HomePage(),
          "product": (BuildContext context) => ProductPage(),
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
        ),
      ),
    );
  }
}
