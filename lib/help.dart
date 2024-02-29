import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
class HelpStack extends StatefulWidget {
  const HelpStack({super.key});

  @override
  State<HelpStack> createState() => _HelpStackState();
}

class _HelpStackState extends State<HelpStack> {
  List<Widget> cards = [];
  List<Map<String, dynamic>> items = [
    {
      'text': 'Clica en la noticia para ir a la web',
      'icon': Icons.touch_app_outlined
    },
    {
      'text': 'Doble click',
      'icon': Icons.touch_app
    },
    {
      'text': 'Triple click',
      'icon': Icons.touch_app
    },
  ];
  @override
  void initState() {
    for (int i = 0; i < items.length; i++) {
      Timer(Duration(seconds: 5 * (i + 1)), () {
        setState(() {
          cards.add(
            HelpItem(text: items[i]['text'], iconData: items[i]['icon'],),
          );
        });
      });
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(230),
      ),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: Alignment.center,
        children: cards,
      ),
    );
  }
}

class HelpItem extends StatefulWidget {
  const HelpItem({super.key, required this.text, required this.iconData});
  final String text;
  final IconData iconData;

  @override
  State<HelpItem> createState() => _HelpItemState();
}

class _HelpItemState extends State<HelpItem> {
  final Duration duration = const Duration(seconds: 5);
  double opacity = 0.0;
  double positionX = 70;
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_){
      setState(() {
        positionX = -70;
        opacity = 1.0;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedPositioned(
            duration: duration,
            curve: Curves.easeInQuint,
            right: positionX,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: AnimatedOpacity(
              opacity: opacity,
              duration: const Duration(milliseconds: 2500),
              onEnd: (){
                setState(() {
                  opacity = 0.0;
                });
              },
              curve: Curves.easeInSine,
              child: Column(
                children: [
                  const Expanded(child: SizedBox.shrink(),),
                  Icon(widget.iconData, size: 200, color: Colors.white70,),
                  Text(widget.text, style: const TextStyle(color: Colors.white, fontSize: 18.0),),
                  const Expanded(child: SizedBox.shrink(),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

