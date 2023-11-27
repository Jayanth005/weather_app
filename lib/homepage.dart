import 'dart:convert';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/custom_widget.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => __HomePageState();
}

class __HomePageState extends State<HomePage> {

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  Color cardColor = const Color.fromARGB(255, 54, 54, 54);

  double temp = 0;
  double humidity = 0;
  double wind = 0;
  double pressure = 0;


  String weblink = "http://api.openweathermap.org/data/2.5/forecast?q=London,uk&APPID=8371819a82eeddfaef44ea8af0b01d5a";

  Future<Map<String, dynamic>> currentWeather()async{



    try {

      var response = await http.get(Uri.parse(weblink));
      final data = jsonDecode(response.body);

      if (data['cod'] != "200") {
        throw "An Unexpected Error Occurred";
      }
      return data;
    } catch (e){
      throw e.toString();
    }
  }

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000),(){
      setState(() {});
    });
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentWeather();
  }

  @override
  Widget build(BuildContext context) {


    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            iconSize: 30,
            onPressed: (){
              setState(() {

              });
            },
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        enablePullDown: true,
        header: ClassicHeader(),
        child: FutureBuilder(
            future: currentWeather(),
            builder: (context, snapshot) {
        
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
        
              if(snapshot.hasError){
                return const Center(
                  child: Text("Something went wrong"),
                );
              }
        
              final snap = snapshot.data!;
              final data = snap['list'][0];
              double currentTemp = data['main']['temp'];
              final currentWeather = data['weather'][0]['main'];
              final currentWeatherIcon = currentWeather == "Clouds" ? Icons.cloud : currentWeather == "Rain" ? Icons.thunderstorm : Icons.sunny;
              final humidity = data['main']['humidity'];
              final pressure = data['main']['pressure'];
              final wind = data['wind']['speed'];
        
        
              return SizedBox(
                width: size.width,
                height: size.height,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 50),
                      width: 210,
                      height: 210,
                      child: Card(
                        elevation: 10,
                        color: const Color.fromARGB(255, 54, 54, 54),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("$currentTemp", style: const TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
        
                            // const SizedBox(height: 20,),
        
                            Icon(currentWeatherIcon, size: 60,),
        
                            // const SizedBox(height: 20,),
        
                            Text(currentWeather, style: TextStyle(fontSize: 18),),
        
                            // const SizedBox(height: 20,),
        
                          ],
                        ),
                      ),
                    ),
        
                    const SizedBox(height: 20,),
        
                    // Weather Forecast
                    Container(
                        margin: const EdgeInsets.only(left: 20),
                        width: size.width,
                        alignment: Alignment.centerLeft,
                        child: const Text("Weather Forecast", style: TextStyle(color: Colors.white, fontSize: 20),)),
        
                    SizedBox(
                      height: 100,
                      width: size.width,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 5,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index){
        
                            final hourlyForecast = snap['list'][index+1];
                            final forecastingHour = hourlyForecast['dt_txt'];
                            final forecastingWeather = hourlyForecast['weather'][0]['main'];
                            final forecastingIcon = forecastingWeather == "Clouds" ? Icons.cloud : forecastingWeather == "Rain" ? Icons.thunderstorm : Icons.sunny;
                            final forecastingTemp = hourlyForecast['main']['temp'];
                            final time = DateTime.parse(forecastingHour);
        
                            return Container(
                              margin: const EdgeInsets.only(left: 10),
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                // color: cardColor,
                              ),
                              child: Card(
                                elevation: 15,
                                color: cardColor,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
        
                                    Text(DateFormat.j().format(time), style: const TextStyle(fontSize: 18,),),
        
                                    Icon(forecastingIcon,size: 30,),
        
                                    Text("$forecastingTemp K", style: const TextStyle(fontSize: 18,),),
                                  ],
                                ),
                              ),
                            );
                          }
                      ),
                    ),
        
                    const SizedBox(height: 20,),
        
                    // Additional Information
                    Container(
                        margin: const EdgeInsets.only(left: 20),
                        width: size.width,
                        alignment: Alignment.centerLeft,
                        child: const Text("Additional Information", style: TextStyle(color: Colors.white, fontSize: 20),)),
        
                    Row(
                      children: [
                        AdditionalInfoContainer(weather: "Humidity", kelvin: "$humidity", weatherIcon: Icons.water_drop),
        
                        AdditionalInfoContainer(weather: "Wind Speed", kelvin: "$wind", weatherIcon: Icons.air_outlined),
        
                        AdditionalInfoContainer(weather: "Pressure", kelvin: "$pressure", weatherIcon: Icons.beach_access),
                      ],
                    )
        
                  ],
                ),
              );
            }
        ),
      ),
    );
  }
}

