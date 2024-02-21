import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ONews',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void fetchRTVEData() async {
    var url = Uri.parse('https://api.rtve.es/');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        // Handle the response data here
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to make request: $e');
    }
  }
  @override
  void initState() {
    fetchRTVEData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(

      ),
      home: const Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              TopLabel(),
              NewCard()
            ],
          ),
        ),
      ),
    );
  }
}

class TopLabel extends StatelessWidget {
  const TopLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('lib/images/header.png'), fit: BoxFit.cover),
      ),
      child: SizedBox(
        height: 200,
        width: MediaQuery.sizeOf(context).width,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Ors News', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 80, fontFamily: 'Anta', height: 0),)
          ],
        ),
      ),
    );
  }
}

class NewCard extends StatelessWidget {
  const NewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(0),
          onTap: (){

          },
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: Image.network(
                      'https://media.traveler.es/photos/63838947050e0f92cd80c982/16:9/w_2560%2Cc_limit/GettyImages-1392907424.jpg',
                      fit: BoxFit.cover,
                      ),
                  ),
                  // Titular
                  const Text('Barcelona se convierte en la ciudad más visitada', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
                  // Pequeño resumen
                  const Text('Barcelona este año se ha visitado un 6% más y esto la coloca en el ranking de las 10 ciudades más visitadas')
                ],
              ),
            ),
          )
        ),
        const Divider(height: 3.0,)
      ],
    );
  }
}


