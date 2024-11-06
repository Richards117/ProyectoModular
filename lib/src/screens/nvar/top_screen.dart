import 'package:flutter/material.dart';
import 'package:flutter_application_app/src/screens/places/details_screen.dart';
import 'package:flutter_application_app/src/service/places_service.dart';
import 'package:flutter_application_app/src/widgets/drawer.dart';
import 'package:provider/provider.dart';

class TopScreen extends StatefulWidget {
  final dynamic place;

  const TopScreen({super.key, this.place});

  @override
  State<TopScreen> createState() => _TopScreenState();
}

class _TopScreenState extends State<TopScreen> {
  String? selectedOption;
  String? sortOrder = 'Más popular';

  @override
  void initState() {
    super.initState();

    // Verifica si widget.place es null antes de llamar a selectPlace
    if (widget.place != null) {
      Provider.of<PlacesService>(context, listen: false)
          .selectPlace(widget.place);
    }
  }

  @override
  Widget build(BuildContext context) {
    final placesService = Provider.of<PlacesService>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white, size: 30),
        title: const Center(
          child: Text(
            'Top',
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
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
                      'Cultural',
                      'Monumentos',
                      'Parques',
                      'Hoteles',
                      'Restaurantes',
                      'Eventos',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) async {
                      setState(() {
                        selectedOption = newValue;
                      });

                      // Busca places basados en la opción seleccionada
                      if (newValue != null) {
                        await placesService.fetchPlaces(category: newValue);
                      }
                    },
                    dropdownColor: Colors.white,
                    icon:
                        const Icon(Icons.arrow_drop_down, color: Colors.black),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox.fromSize(
                    size: const Size(50, 50),
                    child: ClipOval(
                      child: Material(
                        color: Colors.white,
                        elevation: 4,
                        child: PopupMenuButton<String>(
                          icon: const Icon(Icons.filter_list,
                              color: Colors.black),
                          tooltip: 'Ordenar',
                          onSelected: (String value) {
                            setState(() {
                              sortOrder = value;
                            });
                          },
                          itemBuilder: (BuildContext context) {
                            return {'Más popular', 'Menos popular'}
                                .map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(
                                  choice,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            }).toList();
                          },
                          splashRadius: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (selectedOption != null)
            Expanded(
              child: BuildSelectedOptionContainer(selectedOption!, sortOrder!),
            ),
        ],
      ),
    );
  }
}

//widget de la opcion seleccionada
class BuildSelectedOptionContainer extends StatefulWidget {
  final String selectedOption;
  final String sortOrder;

  const BuildSelectedOptionContainer(this.selectedOption, this.sortOrder,
      {super.key});

  @override
  State<BuildSelectedOptionContainer> createState() =>
      _BuildSelectedOptionContainerState();
}

class _BuildSelectedOptionContainerState
    extends State<BuildSelectedOptionContainer> {
  @override
  Widget build(BuildContext context) {
    final placesService = Provider.of<PlacesService>(context);

    // Ordenar lugares según el orden seleccionado
    List<dynamic> sortedPlaces = List.from(placesService.places);
    if (widget.sortOrder == 'Menos popular') {
      sortedPlaces
          .sort((a, b) => (a['rating'] ?? 0).compareTo(b['rating'] ?? 0));
    } else {
      sortedPlaces
          .sort((a, b) => (b['rating'] ?? 0).compareTo(a['rating'] ?? 0));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                widget.selectedOption,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [BoxShadow(blurRadius: 10, color: Colors.black)],
                ),
              ),
            ),
          ),
        ),

        //texto de estado de ordenación
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            widget.sortOrder == 'Más popular'
                ? 'Ordenado por Más Popular'
                : 'Ordenado por Menos Popular',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: ListView.builder(
              key: ValueKey<String>(widget.sortOrder),
              itemCount: sortedPlaces.length,
              itemBuilder: (context, index) {
                final place = sortedPlaces[index];
                final placeRating = place['rating'] != null
                    ? place['rating'].toString()
                    : 'Sin ranking';
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Card(
                      color: Colors.white,
                      elevation: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(4, 4),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.teal.shade200,
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            trailing: SizedBox.fromSize(
                              size: const Size(45, 45),
                              child: ClipOval(
                                child: Material(
                                  color: Colors.teal.shade100,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.teal.shade600,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              place['name'] ?? 'Sin nombre',
                              style: TextStyle(
                                color: Colors.teal.shade900,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Ranking: $placeRating',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceDetailScreen2(place: place),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
