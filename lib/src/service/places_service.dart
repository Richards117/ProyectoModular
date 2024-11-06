import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class PlacesService extends ChangeNotifier {
  final String apiKey = 'fsq3KoRGZegdRu+MZKLyb4vCZUP7x2zQniKeeZxdmpspUfI=';
  List<dynamic> _places = [];
  dynamic _selectedPlace;
  String? _imageUrl;
  String? _hour;
  double? _rating;
  List<dynamic>? _reviews;

  List<dynamic> get places => _places;
  dynamic get selectedPlace => _selectedPlace;
  String? get imageUrl => _imageUrl;
  String? get hour => _hour;
  double? get rating => _rating;
  List<dynamic>? get reviews => _reviews;

  PlacesService() {
    fetchPlaces();
  }

  // Método para obtener la lista de lugares y cargar detalles adicionales para cada uno
  Future<void> fetchPlaces({String? category}) async {
    String baseUrl =
        'https://api.foursquare.com/v3/places/search?ll=20.67501,-103.34740&radius=5223';

    if (category != null) {
      baseUrl += '&query=$category';
    }

    final url = Uri.parse(baseUrl);

    final response = await http.get(
      url,
      headers: {'Authorization': apiKey, 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _places = data['results'];

      for (var place in _places) {
        await fetchPlaceDetails(place['fsq_id'], place);
      }
      notifyListeners();
    } else {
      throw Exception('Error al cargar lugares');
    }
  }

  // Método para seleccionar un lugar y cargar sus fotos, horarios, rating, y reseñas
  Future<void> selectPlace(dynamic place) async {
    _selectedPlace = place;
    await fetchPlacePhotos(place['fsq_id']);
    await fetchPlaceDetails(place['fsq_id'], place);
    notifyListeners();
  }

  // Método para obtener fotos de un lugar utilizando su fsq_id
  Future<void> fetchPlacePhotos(String fsqId) async {
    final url = Uri.parse('https://api.foursquare.com/v3/places/$fsqId/photos');

    final response = await http.get(
      url,
      headers: {
        'Authorization': apiKey,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.isNotEmpty) {
        _imageUrl = '${data[0]['prefix']}500x500${data[0]['suffix']}';
      } else {
        _imageUrl = 'https://placehold.jp/300x250.png';
      }
    } else {
      _imageUrl = 'https://placehold.jp/300x250.png';
    }
    notifyListeners();
  }

  // Método para obtener detalles adicionales de un lugar, como horarios, rating y reseñas
  Future<void> fetchPlaceDetails(String fsqId, [dynamic place]) async {
    final url = Uri.parse(
        'https://api.foursquare.com/v3/places/$fsqId?fields=hours,rating,tips');

    final response = await http.get(
      url,
      headers: {
        'Authorization': apiKey,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // rating y las reseñas si están disponibles
      place['rating'] = data['rating']?.toDouble();

      if (data.containsKey('hours')) {
        _hour = _formatHours(data['hours']);
      } else {
        _hour = 'Horario no disponible';
      }

      _reviews = data['tips'] ?? [];
    } else {
      place['rating'] = null;
      _reviews = [];
    }
    notifyListeners();
  }

  // Método para formatear el horario (esto es solo un ejemplo, ajusta según necesites)
  String _formatHours(dynamic hoursData) {
    if (hoursData == null || hoursData['regular'] == null) {
      return 'Horario no disponible';
    }

    final regularHours = hoursData['regular'] as List<dynamic>;
    String formattedHours = '';
    for (var entry in regularHours) {
      final day = _getDayName(entry['day']);
      final open = entry['open'];
      final close = entry['close'];
      formattedHours += '$day: $open - $close\n';
    }

    return formattedHours.trim();
  }

  // Método auxiliar para obtener el nombre del día a partir del número
  String _getDayName(int dayNumber) {
    const daysOfWeek = [
      'Domingo',
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado'
    ];
    if (dayNumber >= 0 && dayNumber < 7) {
      return daysOfWeek[dayNumber];
    } else {
      return 'Día inválido/Cerrado';
    }
  }
}
