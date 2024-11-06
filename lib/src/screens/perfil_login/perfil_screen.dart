import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_app/src/widgets/card_container.dart';
import 'package:flutter_application_app/src/widgets/drawer.dart';

import 'package:image_picker/image_picker.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  PerfilScreenState createState() => PerfilScreenState();
}

class PerfilScreenState extends State<PerfilScreen> {
  final String _defaultProfileImagePath = 'assets/perfil.png';
  String _selectedProfileImagePath = '';
  bool _profileImageSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 221, 230, 225),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(26, 150, 156, 1),
        iconTheme: const IconThemeData(color: Colors.white, size: 32),
        title: const Center(
          child: Text(
            'P E R F I L',
            style: TextStyle(
              color: Colors.white,
              shadows: [BoxShadow(color: Colors.white, blurRadius: 10)],
            ),
          ),
        ),
      ),
      drawer: const DrawersList(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 3),
                ),
                child: CircleAvatar(
                  maxRadius: 150,
                  backgroundImage: _profileImageSelected
                      ? FileImage(
                          File(_selectedProfileImagePath),
                        )
                      : AssetImage(_defaultProfileImagePath) as ImageProvider,
                ),
              ),
            ),
            const SizedBox(height: 20),
            CardContainer(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Bienvenido',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  PerflDecoration(
                    onImageSelected: (imagePath) {
                      setState(() {
                        _selectedProfileImagePath = imagePath;
                        _profileImageSelected = true;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class PerflDecoration extends StatelessWidget {
  final Function(String)? onImageSelected;

  const PerflDecoration({super.key, this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 64, 190, 197),
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextButton.icon(
              onPressed: () async {
                final selection = await showMyDialog(context);
                if (selection == null) return;
                final picker = ImagePicker();
                final XFile? pickedFile = await picker.pickImage(
                  source: (selection == 1)
                      ? ImageSource.camera
                      : ImageSource.gallery,
                  imageQuality: 100,
                );
                if (pickedFile == null) return;

                if (onImageSelected != null) {
                  onImageSelected!(pickedFile.path);
                }
              },
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.all(Colors.yellow),
              ),
              icon: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.black,
              ),
              label: const Text(
                'Cambiar Foto',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 64, 190, 197),
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextButton.icon(
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 64, 190, 197),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Row(
                          children: [
                            Icon(Icons.info,
                                size: 40,
                                color: Color.fromARGB(255, 248, 30, 15)),
                            SizedBox(width: 20),
                            Text(
                              '¡Alerta!',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    content: const Text(
                      '¿Esta seguro que quiere cerrar sesión?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancelar'),
                        child: const Text(
                          'NO',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            shadows: [
                              BoxShadow(color: Colors.black, blurRadius: 5),
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'login');
                        },
                        child: const Text(
                          'SI',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 25,
                            shadows: [
                              BoxShadow(color: Colors.red, blurRadius: 5),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.all(Colors.yellow),
              ),
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.black,
              ),
              label: const Text(
                'Cerrar Sesión',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

dynamic showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey[100],
        title: const Text('Seleccione una imagen o tome una fotografía'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      TextButton.icon(
                        style: ButtonStyle(
                          overlayColor: WidgetStateProperty.all(Colors.yellow),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(1);
                        },
                        icon: const Icon(Icons.camera_alt,
                            size: 50, color: Colors.indigo),
                        label: const Text(''),
                      ),
                      const Text('Cámara',
                          style: TextStyle(fontSize: 20, color: Colors.black)),
                    ],
                  ),
                  Column(
                    children: [
                      TextButton.icon(
                        style: ButtonStyle(
                          overlayColor: WidgetStateProperty.all(Colors.yellow),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(2);
                        },
                        icon: const Icon(Icons.storage,
                            size: 50, color: Colors.indigo),
                        label: const Text(''),
                      ),
                      const Text('Galería',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          )),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.all(Colors.red),
            ),
            child: const Icon(
              Icons.close_rounded,
              color: Colors.red,
              shadows: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black,
                ),
              ],
              size: 50,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
