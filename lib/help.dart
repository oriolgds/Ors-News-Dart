import 'package:flutter/material.dart';
class HelpStack extends StatefulWidget {
  const HelpStack({super.key});

  @override
  State<HelpStack> createState() => _HelpStackState();
}

class _HelpStackState extends State<HelpStack> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(230),
      ),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HelpItem(text: 'Clica en la noticia para ir a la web', iconData: Icons.touch_app_outlined,)
        ],
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
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(seconds: 1),

          child: Column(
            children: [
              Icon(widget.iconData, size: 200, color: Colors.white70,),
              Text(widget.text, style: const TextStyle(color: Colors.white, fontSize: 18.0),)
            ],
          )
        ),
      ],
    );
  }
}

