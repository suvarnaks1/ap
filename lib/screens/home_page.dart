import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whetherapp/data/image_path.dart';
import 'package:intl/intl.dart';
import 'package:whetherapp/screens/services/location_provider.dart';
import 'package:whetherapp/services/weather_service_provider.dart';
import 'package:whetherapp/utilis/apptext.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    print("hello");

    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    locationProvider.determinePosition().then((_) {
      if (locationProvider.currentLocationName != null) {
        var city = locationProvider.currentLocationName!.locality;
        if (city != null) {
          Provider.of<WeatherServiceProvider>(context, listen: false)
              .FetchWeatherDataByCity(city);
        }
      }
    });
    // Provider.of<LocationProvider>(context, listen: false).determinePosition();

    // Provider.of<WeatherServiceProvider>(context,listen: false).FetchWeatherDataByCity("Dubai");
    super.initState();
  }
  TextEditingController _cityController=TextEditingController();
  

  @override
  void dispose() {
    
    _cityController.dispose();
    super.dispose();
  }

  bool _clicked = false;

  @override
  Widget build(BuildContext context) {


     // Get current time
    final currentTime = DateTime.now().hour;

    // Define greeting based on the time of day
    String greeting;
    if (currentTime >= 6 && currentTime < 12) {
      greeting = 'Good Morning';
    } else if (currentTime >= 12 && currentTime < 18) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }



    Size size = MediaQuery.of(context).size;
    final locationProvider = Provider.of<LocationProvider>(context);

    final weatherProvider = Provider.of<WeatherServiceProvider>(context);

    // Get the sunrise timestamp from the API response
    int sunriseTimestamp = weatherProvider.weather?.sys?.sunrise ?? 0; // Replace 0 with a default timestamp if needed
    int sunsetTimestamp = weatherProvider.weather?.sys?.sunset ?? 0; // Replace 0 with a default timestamp if needed

// Convert the timestamp to a DateTime object
    DateTime sunriseDateTime = DateTime.fromMillisecondsSinceEpoch(sunriseTimestamp * 1000);
    DateTime sunsetDateTime = DateTime.fromMillisecondsSinceEpoch(sunsetTimestamp * 1000);

// Format the sunrise time as a string
    String formattedSunrise = DateFormat.Hm().format(sunriseDateTime);
    String formattedSunset = DateFormat.Hm().format(sunsetDateTime);
    
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.only(top: 65, left: 20, right: 20, bottom: 20),
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  background[
                          weatherProvider.weather?.weather![0].main ?? "N/A"] ??
                      "assets/img/default.png",
                ))),
        child: Stack(children: [
         
          Container(
              height: 50,
              child: Consumer<LocationProvider>(
                  builder: (context, locationProvider, child) {
                var locationCity;
                if (locationProvider.currentLocationName != null) {
                  locationCity = locationProvider.currentLocationName!.locality;
                } else {
                  locationCity = "Unknown location";
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(

                        // color: Colors.red,
                        child: Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 50,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(
                              data: locationCity.isEmpty
                                  ? "location Unknown"
                                  : locationCity,
                              color: Colors.white,
                              fw: FontWeight.bold,
                              size: 19,
                            ),
                            Text(
                              greeting, // Display the greeting
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            )
                          ],
                        )
                      ],
                    )),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _clicked = !_clicked;
                          });
                        },
                        icon: Icon(
                          Icons.search,
                          size: 40,
                          color: Colors.white,
                        ))
                  ],
                );
              })),

          //image
          Align(
              alignment: Alignment(0, -0.7),
              child: Image.asset(
                      imagePath[weatherProvider.weather?.weather![0]?.main ?? "N/A"] ?? "assets/img/default.png",
              )),
//celcies
          Align(
            alignment: Alignment(0, 0),
            child: Container(
              height: 160,
              width: 130,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    data:
                        "${weatherProvider.weather?.main?.temp?.toStringAsFixed(0)} \u00B0C" ??
                            "", // Display temperature

                    color: Colors.white,
                    fw: FontWeight.bold,
                    size: 32,
                  ),
                  Expanded(
                    child: AppText(
                      data: weatherProvider.weather?.name ?? "N/A",
                      color: Colors.white,
                      fw: FontWeight.w600,
                      size: 30,
                    ),
                  ),
                  AppText(
                    data:  weatherProvider.weather?.weather![0].main ?? "N/A",
                    color: Colors.white,
                    fw: FontWeight.w600,
                    size: 30,
                  ),
                     AppText(
                    data: DateFormat('hh:mm a').format(DateTime.now()),
                    color: Colors.white,
                   
                
                  ),
                 
                ],
              ),
            ),
          ),

          //Data temp like
          Align(
            alignment: Alignment(0.0, 0.75),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withOpacity(0.4)),
              height: 190,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/img/temperature-high.png",
                          height: 55,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                                 AppText(
                                  data: "Temp Max",
                                  color: Colors.white,
                                  size: 14,
                                  fw: FontWeight.w600,
                                ),
                             AppText(
                                  data:"${weatherProvider.weather?.main!.tempMax!.toStringAsFixed(0)} \u00B0C"?? "N/A",
                                  color: Colors.white,
                                  size: 14,
                                  fw: FontWeight.w600,
                                )
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/img/temperature-low.png",
                                height: 55,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Temp Min",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                 AppText(
                                  data:"${weatherProvider.weather?.main!.tempMin!.toStringAsFixed(0)} \u00B0C"?? "N/A",
                                  color: Colors.white,
                                  size: 14,
                                  fw: FontWeight.w600,
                                )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    height: 20,
                    thickness: 2,
                    indent: 20,
                    endIndent: 20,
                    color: Colors.white,
                  ),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/img/sun.png",
                          height: 55,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                                  data: "sunrise",
                                  color: Colors.white,
                                  size: 14,
                                  fw: FontWeight.w600,
                                ),
                            AppText(
                                  data:"${formattedSunrise} AM",
                                  color: Colors.white,
                                  size: 14,
                                  fw: FontWeight.w600,
                                )
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/img/moon.png",
                                height: 55,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sunset",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                 AppText(
                                  data:"${formattedSunset} PM",
                                  color: Colors.white,
                                  size: 14,
                                  fw: FontWeight.w600,
                                )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          //positioned
           Positioned(
              top: 50,
              left: 20,
              right: 20,
              child: Container(
                height: 45,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: _cityController,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    IconButton(onPressed: (){
                      print(_cityController.text);
                    weatherProvider.FetchWeatherDataByCity(_cityController.text);
                    }, icon: Icon(Icons.search))
                  ],
                ),
              ),
            ),
        ]),
      ),
    );
  }
}
