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
  List<dynamic> news = [];
  Future<void> fetchRTVEData() async {

    final content = (await http.read(Uri.parse('http://oriolsnews.000webhostapp.com/')));
    final json = jsonDecode(content);
    setState(() {
      news = json['news'];
    });
  }
  @override
  void initState() {
    fetchRTVEData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: Scaffold(
        body: Column(
          children: [
            const TopLabel(),
            Expanded(
              child: ListView.separated(
                cacheExtent: 200,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: news.length + 1,
                itemBuilder: (context, index){
                  if (index == 0) {
                    return const TopListView();
                  }
                  final inew = news[index - 1];
                  return NewCard(title: inew['Title'], image: inew['Image'], description: inew['Summary'], source: inew['Source'],);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(height: 5,);
                },

              ),
            ),
          ],
        ),
      ),
    );
  }
}
class TopListView extends StatefulWidget {
  const TopListView({super.key});

  @override
  State<TopListView> createState() => _TopListViewState();
}

class _TopListViewState extends State<TopListView> {
  String date = '...';
  Future<void> fetchDateData() async {
    String apiDate = await http.read(Uri.parse('http://oriolsnews.000webhostapp.com/date.txt'));
    setState(() {
      date = apiDate;
    });
  }
  @override
  void initState() {
    fetchDateData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Noticias actualizadas el: $date'),
      ],
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
  const NewCard({super.key, required this.image, required this.title, required this.description, required this.source});
  final String image;
  final String title;
  final String description;
  final String source;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(0),
        onTap: () {},
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(source),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
                // Titular
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
                // Pequeño resumen
                Text(description.length > 300 ? '${description.substring(0, 300)}...' : description)
              ],
            ),
          ),
        ));
  }
}


