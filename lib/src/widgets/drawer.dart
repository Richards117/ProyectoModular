import 'package:flutter/material.dart';

class DrawersList extends StatelessWidget {
  const DrawersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: Drawer(
        shape: const OutlineInputBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
        backgroundColor: Colors.grey.shade100,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(44, 172, 179, 1),
              ),
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(44, 172, 179, 1),
                ),
                accountName: Text(
                  "Nombre de la cuenta",
                  style: TextStyle(fontSize: 15),
                ),
                accountEmail: Text("abhishekm977@gmail.com"),
                currentAccountPictureSize: Size.square(50),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Color.fromRGBO(18, 226, 209, 0.815),
                  child: Text(
                    'A',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
                shadows: [BoxShadow(blurRadius: 8, color: Colors.black)],
              ),
              title: const Text(' Inicio '),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'home');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.star,
                  shadows: [BoxShadow(blurRadius: 8, color: Colors.black)]),
              title: const Text(' Favoritos '),
              onTap: () {
                Navigator.pushNamed(context, 'favorite');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(' Mi Perfil '),
              onTap: () {
                Navigator.pushNamed(context, 'perfil');
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
