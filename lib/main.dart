import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whetherapp/screens/home_page.dart';
import 'package:whetherapp/screens/services/location_provider.dart';
import 'package:whetherapp/services/weather_service_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>LocationProvider()),
        ChangeNotifierProvider(create: (context)=>WeatherServiceProvider())
      ],
      child: MaterialApp(
        title: "Weather app",
        theme: ThemeData(
            appBarTheme:
                AppBarTheme(backgroundColor: Colors.transparent, elevation: 0)),
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
