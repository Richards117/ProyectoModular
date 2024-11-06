import 'package:flutter/material.dart';
import 'package:flutter_application_app/src/widgets/drawer.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(26, 150, 156, 1),
      ),
      drawer: const DrawersList(),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.circular(28),
              ),
              child: GestureDetector(
                onTap: () {},
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      ListTile(
                        title: const Center(child: Text('Nombre lugar')),
                        subtitle: Center(
                          child: Text(
                            'address',
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        ),
                      ),
                      const Image(
                        image: NetworkImage('https://placehold.jp/400x250.png'),
                        fit: BoxFit.cover,
                      ),
                      OverflowBar(
                        alignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            width: 150,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(38, 185, 196, 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Eliminar',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
