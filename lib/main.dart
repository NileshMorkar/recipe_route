import 'package:flutter/material.dart';
import 'package:recipe_route/home_page.dart';

void main()=> runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "poppins",
        primaryColor: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home:const HomePage(),
    );
  }
}
