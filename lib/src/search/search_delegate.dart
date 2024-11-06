import 'package:flutter/material.dart';
import 'package:flutter_application_app/src/screens/places/details_screen.dart';
import 'package:flutter_application_app/src/service/places_service.dart';
import 'package:provider/provider.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(
          Icons.clear,
          color: Colors.red,
          size: 30,
          shadows: [
            BoxShadow(color: Colors.black, blurRadius: 10),
          ],
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.black,
        size: 30,
      ),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Center(child: Text('Seleccione un lugar de la lista'));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final placesService = Provider.of<PlacesService>(context);
    final List<dynamic> places = placesService.places;

    if (query.isEmpty) {
      return _emptyContainer();
    }

    final List<dynamic> suggestionList = places.where((place) {
      if (place == null || place['name'] == null) {
        return false;
      }
      return place['name'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final place = suggestionList[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.location_on,
                color: Colors.blueAccent,
                size: 30,
              ),
              title: Text(
                place['name'] ?? 'Nombre no disponible',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                place['location']?['address'] ?? 'Sin dirección',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 18,
              ),
              onTap: () {
                placesService.selectPlace(place);
                query = place['name'];

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlaceDetailScreen2(place: place),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _emptyContainer() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_on_outlined,
            color: Colors.grey,
            size: 80,
          ),
          SizedBox(height: 16),
          Text(
            'Busca lugares aquí',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
