import 'package:flutter/material.dart';
import 'package:flutter_application_app/src/widgets/drawer.dart';

class Recommendations extends StatefulWidget {
  const Recommendations({super.key});

  @override
  State<Recommendations> createState() => _RecommendationsState();
}

class _RecommendationsState extends State<Recommendations> {
  String? selectedOption;
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Recomendaciones',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: const Color.fromRGBO(26, 150, 156, 1),
      ),
      drawer: const DrawersList(),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  filled: true,
                  fillColor: Colors.white,
                  // Borde cuando no está enfocado
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Colors.black, width: 1.5),
                  ),
                  // Borde cuando está enfocado
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Colors.black, width: 1.5),
                  ),
                ),
                hint: const Text(
                  'Elige una opción',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: selectedOption,
                items: <String>[
                  'Museos',
                  'Monumentos',
                  'Parques',
                  'Hoteles',
                  'Restaurantes',
                  'Eventos',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedOption = newValue;
                  });
                },
                dropdownColor: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                style: const TextStyle(color: Colors.black),
              )),
          if (selectedOption != null)
            Expanded(child: buildSelectedOptionContainer(selectedOption!)),
        ],
      ),
    );
  }

  Widget buildSelectedOptionContainer(String selectedOption) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 64, 190, 197),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                width: 1.5,
                color: Colors.black,
              ),
            ),
            child: Center(
              child: Text(
                selectedOption,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [BoxShadow(blurRadius: 12, color: Colors.black)],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) => GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'details');
              },
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Produc(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Produc extends StatelessWidget {
  const Produc({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: const Column(
        children: [
          DrawerButton(
            color: Colors.amber,
          )
        ],
      ),
    );
  }
}

/* 987321 */