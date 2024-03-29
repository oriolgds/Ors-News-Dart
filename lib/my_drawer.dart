
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



import 'upgrade.dart' as upgrade;

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String upgradeButtonText = 'Descargar última versión';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          ListView(
            shrinkWrap: true,
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('lib/images/office.jpg'),
                        opacity: 0.8)),
                child: SizedBox.shrink(),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                child: RichText(
                  text: const TextSpan(
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'En Ors News trabajamos ',
                        ),
                        TextSpan(
                          text: 'muy duro',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' 🫡 para ofrecerte las ',
                        ),
                        TextSpan(
                          text: 'mejores 🔝',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' noticias.',
                        ),
                      ]),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                child: Text(
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                    'Gracias por confiar en nosotros 🥰'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: OutlinedButton(
                  onPressed: () async {
                    setState(() {
                      upgradeButtonText = 'Buscando actualizaciones...';
                    });
                    if(await upgrade.upgrade()){
                      setState(() {
                        upgradeButtonText = 'Comprueba las notificaciones';
                      });
                    }
                    else {
                      setState(() {
                        upgradeButtonText = '¡Tienes la última versión!';
                      });
                    }
                  },
                  style: const ButtonStyle(
                    side: MaterialStatePropertyAll(BorderSide(
                      color: Color.fromRGBO(150, 20, 20, 0.7),
                      width: 1.0,
                      )
                    ),
                  ),
                  child: Text(upgradeButtonText, style: const TextStyle(color: Colors.black87),),
                ),
              ),
              const SizedBox(
                height: 7,
              ),


            ],
          ),
          const Divider(),
          const Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text('Este proyecto es de código abierto y sin animo de lucro.', style: TextStyle(fontSize: 16.0, color: Colors.black),),
              ),
              SizedBox(
                height: 7,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text('Puedes ver el código, crear tu propia app a partir de esta, y hacer donaciones para mantener el servidor.', style: TextStyle(fontSize: 16.0, color: Colors.black),),
              )
            ],
          ),
          const Divider(),
          const Spacer(),
          const Wrap(
            spacing: 8.0,
            alignment: WrapAlignment.center,
            children: [
              BottomIconButton(url: 'https://github.com/oriolgds/Ors-News-Dart', iconData: FontAwesomeIcons.github, tooltip: 'Ver el código'),
              BottomIconButton(url: 'https://ors.22web.org/', iconData: FontAwesomeIcons.user, tooltip: 'Sobre mi'),
              BottomIconButton(url: 'https://www.linkedin.com/in/oriol-giner/', iconData: FontAwesomeIcons.linkedinIn, tooltip: 'Linkedin'),
              BottomIconButton(url: 'https://www.instagram.com/oriolgds/', iconData: FontAwesomeIcons.instagram, tooltip: 'Instagram'),
              BottomIconButton(url: 'https://www.youtube.com/channel/UCXBLxox6etKtcCTh-OeMrUg', iconData: FontAwesomeIcons.youtube, tooltip: 'Youtube'),
            ],
          ),
          const SizedBox(
            height: 9,
          )
        ],
      ),
    );
  }
}
class BottomIconButton extends StatelessWidget {
  const BottomIconButton({super.key, required this.url, required this.iconData, required this.tooltip});
  final String url;
  final IconData iconData;
  final String tooltip;
  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      padding: const EdgeInsets.all(17.0),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.orange.shade100),
      ),
      enableFeedback: true,
      tooltip: tooltip,
      onPressed: () async {
        launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      },
      icon: Icon(iconData, size: 40,),

    );
  }
}

