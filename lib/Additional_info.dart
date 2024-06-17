import 'package:flutter/material.dart';

class Additional_info extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const Additional_info({Key? key, required this.icon, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        Container(
          width: 150,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16)
          ),
          child:  Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Icon(icon,size: 48,),
                  SizedBox(height: 10,),
                  Text(label,style: const TextStyle(fontSize: 18),),
                  SizedBox(height: 10,),
                  Text(value,style:const  TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)
                ],
              ),
            ),
          ),
        );

  }
}
