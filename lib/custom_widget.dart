import 'package:flutter/material.dart';

class AdditionalInfoContainer extends StatelessWidget {
  String weather;
  String kelvin;
  IconData weatherIcon;
  AdditionalInfoContainer({super.key, required this.weather, required this.kelvin, required this.weatherIcon});

  @override
  Widget build(BuildContext context) {

    Color cardColor = const Color.fromARGB(255, 54, 54, 54);


    return Container(
      margin: const EdgeInsets.only(left: 10),
      height: 150,
      width: 120,
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

            Icon(weatherIcon,size: 45,),

            Text(weather, style: TextStyle(fontSize: 18,),),

            Text(kelvin, style: TextStyle(fontSize: 18,),),
          ],
        ),
      ),
    );
  }
}