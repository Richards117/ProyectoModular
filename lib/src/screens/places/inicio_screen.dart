import 'package:flutter/material.dart';
import 'package:flutter_application_app/src/screens/places/details_screen.dart';
import 'package:flutter_application_app/src/search/search_delegate.dart';
import 'package:flutter_application_app/src/service/places_service.dart';
import 'package:flutter_application_app/src/widgets/drawer.dart';
import 'package:provider/provider.dart';

class FoursquarePlaces extends StatelessWidget {
  const FoursquarePlaces({super.key});

  @override
  Widget build(BuildContext context) {
    final placesService = Provider.of<PlacesService>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white, size: 30),
        backgroundColor: const Color.fromRGBO(26, 150, 156, 1),
        title: const Text(
          "Discover Places",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: SizedBox.fromSize(
              size: const Size(45, 45),
              child: ClipOval(
                child: Material(
                  color: Colors.grey.shade200,
                  child: InkWell(
                    onTap: () async {
                      await showSearch(
                        context: context,
                        delegate: CustomSearchDelegate(),
                      );
                    },
                    child: const Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 27,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      drawer: const DrawersList(),
      body: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: HorizontalOptions(),
          ),
          Expanded(
            child: PlacesList(placesService: placesService),
          ),
        ],
      ),
    );
  }
}

// widget para botones de seleccion de una categoria
class HorizontalOptions extends StatefulWidget {
  const HorizontalOptions({super.key});

  @override
  HorizontalOptionsState createState() => HorizontalOptionsState();
}

class HorizontalOptionsState extends State<HorizontalOptions> {
  String? selectedOption;

  final List<String> topOptions = ['Cultural', 'Monuments', 'Parques'];
  final List<String> bottomOptions = ['Hotels', 'Restaurants', 'Eventos'];

  @override
  Widget build(BuildContext context) {
    final placesService = Provider.of<PlacesService>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Selecciona una Categoria:',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54),
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: topOptions.map((String option) {
                  bool isSelected = selectedOption == option;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: isSelected ? 120 : 100,
                    height: isSelected ? 50 : 40,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: ChoiceChip(
                      elevation: 5,
                      backgroundColor: Colors.grey.shade200,
                      selectedColor: Colors.teal.shade300,
                      label: Text(option),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        setState(() {
                          selectedOption = selected ? option : null;
                          placesService.fetchPlaces(category: selectedOption);
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: bottomOptions.map((String option) {
                  bool isSelected = selectedOption == option;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: isSelected ? 120 : 100,
                    height: isSelected ? 50 : 40,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: ChoiceChip(
                      elevation: 5,
                      backgroundColor: Colors.grey.shade200,
                      selectedColor: Colors.teal.shade300,
                      label: Text(option),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        setState(() {
                          selectedOption = selected ? option : null;
                          placesService.fetchPlaces(category: selectedOption);
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget  que lanza la lista de los lugares del servicio
class PlacesList extends StatelessWidget {
  const PlacesList({
    super.key,
    required this.placesService,
  });

  final PlacesService placesService;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: placesService.places.length,
      itemBuilder: (context, index) {
        final place = placesService.places[index];
        final address = place['location']['address'] ?? 'Address not available';
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Card(
              color: Colors.white,
              elevation: 10,
              child: ListTile(
                leading: Icon(
                  Icons.place_outlined,
                  color: Colors.teal.shade300,
                ),
                title: Text(
                  place['name'],
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  address,
                  style: const TextStyle(color: Colors.black54),
                ),
                trailing: SizedBox.fromSize(
                  size: const Size(45, 45),
                  child: ClipOval(
                    child: Material(
                      color: Colors.grey.shade200,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.teal.shade300,
                        size: 25,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlaceDetailScreen2(place: place),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
