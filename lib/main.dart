import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';


// Other pages
import 'help.dart';


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
  double listViewScroll = 0;
  final ScrollController _scrollController = ScrollController();
  List<dynamic> news = [];
  String date = '...';
  bool viewingCachedNews = true;

  // Help variables
  Widget helpWidget = const SizedBox.shrink();
  Future<void> fetchDateData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? cachedDate = prefs.getString('newsDate');
    if(cachedDate!= null){
      setState(() {
        date = cachedDate;
      });
    }
    String apiDate = await http.read(Uri.parse('http://oriolsnews.000webhostapp.com/date.txt'));
    setState(() {
      date = apiDate;
    });
  }
  Future<void> fetchApiData() async {
    // Get cached news
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? cachedNews = prefs.getString('newsJSON');
    if (cachedNews!= null) {
      setState(() {
        news = jsonDecode(cachedNews)['news'];
      });
    }
    final content = (await http.read(Uri.parse('http://oriolsnews.000webhostapp.com/')));
    final json = jsonDecode(content);
    setState(() {
      news = json['news'];
      viewingCachedNews = false;
    });
    prefs.setString('newsJSON', jsonEncode(json));
    fetchDateData();
  }
  Future<void> showHelp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? helpShown = prefs.getBool('helpShown');
    if(helpShown== null || helpShown == false) {
      await prefs.setBool('helpShown', true);
      helpWidget = const HelpStack();
    }

  }
  @override
  void initState() {
    showHelp();
    fetchApiData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                TopLabel(listViewScroll),
                Expanded(
                  child: NotificationListener(
                    child: ListView.separated(
                      controller: _scrollController,
                      cacheExtent: 200,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: news.length + 1,
                      itemBuilder: (context, index){
                        if (index == 0) {
                          return TopListView(date: date, viewingChachedNews: viewingCachedNews,);
                        }
                        final inew = news[index - 1];
                        return NewCard(title: inew['Title'], image: inew['Image'], description: inew['Summary'], source: inew['Source'], url: inew['Url'],);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(height: 5,);
                      },

                    ),
                    onNotification: (t){
                      setState(() {
                        listViewScroll = _scrollController.position.pixels;
                      });

                      return true;
                    },
                  ),
                ),
              ],
            ),
            helpWidget
          ],
        ),
      ),
    );
  }
}
class TopListView extends StatefulWidget {
  const TopListView({super.key, required this.date, required this.viewingChachedNews});
  final String date;
  final bool viewingChachedNews;
  @override
  State<TopListView> createState() => _TopListViewState();
}

class _TopListViewState extends State<TopListView> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text((widget.viewingChachedNews)?'Viendo noticias cacheadas':'Viendo noticias de la red'),
        Text('Noticias actualizadas el: ${widget.date}'),
      ],
    );
  }
}


class TopLabel extends StatelessWidget {
  const TopLabel(this.listViewScrolled, {super.key,} );
  final double listViewScrolled;
  final double initialFontSize = 80;
  final double finalFontSize = 60;
  final double endScroll = 100;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('lib/images/header.png'), fit: BoxFit.cover),
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 2000),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: listViewScrolled > 100 ? 100 : 200 - listViewScrolled,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedDefaultTextStyle(
                style: TextStyle(fontSize: listViewScrolled < endScroll ? initialFontSize - (listViewScrolled * (initialFontSize - finalFontSize) / endScroll) : finalFontSize),
                duration: const Duration(milliseconds: 400),
                child: const Text('Ors News', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontFamily: 'Anta', height: 0),)
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NewCard extends StatefulWidget {
  const NewCard({super.key, required this.image, required this.title, required this.description, required this.source, required this.url});
  final String image;
  final String title;
  final String description;
  final String source;
  final String url;

  @override
  State<NewCard> createState() => _NewCardState();
}


class _NewCardState extends State<NewCard> {
  final int descriptionCharLimit = 100;
  bool opened = false;
  bool doubleClicked = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(0),
        onTap: () async {
          if(opened){
            return;
          }
          opened = true;
          final Uri url2 = Uri.parse(widget.url);
          await launchUrl(url2);
          Timer(const Duration(milliseconds: 500), () {
            opened = false;
          });
        },
        onDoubleTap: (){
          setState(() {
            doubleClicked = !doubleClicked;
          });

        },
        onLongPress: (){
          Share.share('Mira esta noticia que he encontrado en Ors News ${widget.url}', subject: widget.title);
        },
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.source, textAlign: TextAlign.center,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        child: Image.network(
                          widget.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                // Titular
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold
                  ),
                ),
                // Pequeño resumen
                Text(widget.description.length > descriptionCharLimit && !doubleClicked ? '${widget.description.substring(0, descriptionCharLimit)}...' : widget.description),
                widget.description.length > descriptionCharLimit && !doubleClicked ? Text('Doble click para leer más', style: TextStyle(color: Colors.black.withAlpha(150)), textAlign: TextAlign.start,): const SizedBox.shrink(),
              ],
            ),
          ),
        ));
  }
}


