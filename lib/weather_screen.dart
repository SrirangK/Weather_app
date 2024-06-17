import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/Additional_info.dart';
import 'package:http/http.dart' as http;
import 'Hourly_INformation.dart';
import 'secrets.dart';
import 'package:intl/intl_browser.dart';
class WeatherScreen extends StatefulWidget {

   const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();

}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future <Map<String,dynamic>> weather;

  Future <Map<String,dynamic>>getCurrentWeather()async {
    try{
      String cityname="London";
      final res=await http.get(
        Uri.parse("http://api.openweathermap.org/data/2.5/forecast?q=$cityname&APPID=$openweatherAPIkey"),
      );
      final data =jsonDecode(res.body);
      if(data['cod']!="200"){
        throw "An Unexpexted error occured";
      }
      return data;

    }catch(e){
      throw(e.toString());
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    weather=getCurrentWeather();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:const  Text("Weather",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )
            ,),
          actions:  [
            IconButton(
              onPressed: (){setState(() {
                weather=getCurrentWeather();
              });},
              icon: const Icon(Icons.refresh),
            ),
          ],
          centerTitle: true,

        ),

      body:
      FutureBuilder(
        future: weather,
        builder: (context,snapshot) {
          // print(snapshot);
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator.adaptive());
          }
          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }

          final data=snapshot.data!;
          final CurrentTemperature=data['list'][0]['main']['temp'];
          final currentSky=data['list'][0]['weather'][0]['main'];
          final currentPressure=data['list'][0]['main']['pressure'];
          final currentwindspeed=data['list'][0]['wind']['speed'];
          final currenthumidity=data['list'][0]['main']['humidity'];


          return Padding(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //main card
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text("$CurrentTemperature K",
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16,),
                                Icon(currentSky=='Clouds'||currentSky=='Rain'?Icons.cloud:Icons.sunny, size: 64,),
                                const SizedBox(height: 16,),
                                Text(currentSky, style: TextStyle(fontSize: 20),)

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text("Hourly Forecast",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                  SizedBox(height: 16,),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      itemCount: 5,
                        scrollDirection: Axis.horizontal,
                        itemBuilder:(context,index){
                        final HourlyForecast=data['list'][index+1];
                        final time=DateTime.parse(HourlyForecast['dt_txt']);
                          return HourlyFoItemrecast(
                              time: DateFormat.j().format(time),
                              icon: HourlyForecast['weather'][0]['main']=='Clouds'|| HourlyForecast['weather'][0]['main']=='Rain'?Icons.cloud:Icons.sunny,
                              value: HourlyForecast['main']['temp'].toString()
                          );
                        }
                    ),
                  ),
                  SizedBox(height: 20,),
                  //Additional forecast cards
                  Text("Additional Information",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                  SizedBox(height: 16,),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Additional_info(icon: Icons.water_drop,
                              label: "Humidity",
                              value: currenthumidity.toString()),
                          Additional_info(icon: Icons.air,
                              label: "Wind Speed",
                              value: currentwindspeed.toString()),
                          Additional_info(icon: Icons.beach_access,
                              label: "Pressure",
                              value: currentPressure.toString())
                        ],
                      )
                  )
                ],
              ),
            ),
          );
        }
      ),

    );
  }
}

