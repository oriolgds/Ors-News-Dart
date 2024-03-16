import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
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
                    onPressed: () {},
                    style: const ButtonStyle(
                      side: MaterialStatePropertyAll(BorderSide(
                        color: Color.fromRGBO(150, 20, 20, 0.7),
                        width: 1.0,
                        )
                      ),
                    ),
                    child: const Text('Buscar actualizaciones', style: TextStyle(color: Colors.black87),),
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),


              ],
            ),
            Divider(),
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text('Este proyecto es de codigo abierto y sin animo de lucro.', style: TextStyle(fontSize: 16.0, color: Colors.black),),
                ),
                const SizedBox(
                  height: 7,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text('Puedes ver el código, crear tu propia app a partir de esta, y hacer donaciones para mantener el servidor.', style: TextStyle(fontSize: 16.0, color: Colors.black),),
                )
              ],
            ),
            Divider(),
            Spacer(),
            IconButton.filledTonal(
              onPressed: () {  },
              icon: Icon(Icons.code, size: 50,),

            ),
            SizedBox(
              height: 9,
            )
          ],
        ),
      ),
    );
  }
}
