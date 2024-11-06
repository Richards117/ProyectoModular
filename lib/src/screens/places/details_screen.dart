import 'package:flutter/material.dart';
import 'package:flutter_application_app/src/service/places_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class PlaceDetailScreen2 extends StatefulWidget {
  final dynamic place;

  const PlaceDetailScreen2({super.key, required this.place});

  @override
  PlaceDetailScreen2State createState() => PlaceDetailScreen2State();
}

class PlaceDetailScreen2State extends State<PlaceDetailScreen2>
    with SingleTickerProviderStateMixin {
  bool isFav = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    Provider.of<PlacesService>(context, listen: false)
        .selectPlace(widget.place);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final placesService = Provider.of<PlacesService>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(26, 150, 156, 1),
        title: const Text(
          'Detalles',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                isFav = !isFav;
              });
            },
            child: Icon(
              Icons.favorite,
              color: isFav ? Colors.red : Colors.grey.shade300,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: AnimationLimiter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre del lugar
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      widget.place['name'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              // Imagen del lugar
              Padding(
                padding: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (placesService.imageUrl != null)
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Image.network(
                            placesService.imageUrl!,
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                _controller.forward();
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/jar-loading.gif',
                                height: 220,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        )
                      else
                        const SizedBox(
                          height: 220,
                          width: double.infinity,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Detalles del lugar
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detalles del Lugar',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Direccion
                      AnimationConfiguration.staggeredList(
                        position: 0,
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Colors.blue),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    widget.place['location']['address'] ??
                                        'Sin dirección',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Distancia
                      AnimationConfiguration.staggeredList(
                        position: 1,
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Row(
                              children: [
                                const Icon(Icons.directions_walk,
                                    color: Colors.green),
                                const SizedBox(width: 10),
                                Text(
                                  'Distancia: ${widget.place['distance']} metros',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Categoría
                      AnimationConfiguration.staggeredList(
                        position: 2,
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Row(
                              children: [
                                const Icon(Icons.category,
                                    color: Colors.orange),
                                const SizedBox(width: 10),
                                Text(
                                  'Categoría: ${widget.place['categories'][0]['name']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Horario
                      if (placesService.hour != null)
                        AnimationConfiguration.staggeredList(
                          position: 3,
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Row(
                                  children: [
                                    const Icon(Icons.watch_later_rounded,
                                        color: Colors.blue, size: 40),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        placesService.hour!,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      // Rating
                      AnimationConfiguration.staggeredList(
                        position: 4,
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Row(
                              children: [
                                const Icon(Icons.star, color: Colors.red),
                                const SizedBox(width: 10),
                                Text(
                                  'Ranking: ${widget.place['rating'] ?? 'Sin ranking'}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Reseñas
                      if (placesService.reviews != null &&
                          placesService.reviews!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Reseñas:',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: placesService.reviews!.length,
                                itemBuilder: (context, index) {
                                  var review = placesService.reviews![index];
                                  return AnimationConfiguration.staggeredList(
                                    position: index + 5,
                                    child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: Card(
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          margin:
                                              const EdgeInsets.only(bottom: 15),
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    const CircleAvatar(
                                                      radius: 25,
                                                      backgroundColor:
                                                          Colors.grey,
                                                      child: Icon(Icons.person,
                                                          color: Colors.white),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        review['user']
                                                                ?['name'] ??
                                                            'Reseñador',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                    // Display rating if available
                                                    if (review['rating'] !=
                                                        null)
                                                      Row(
                                                        children: List.generate(
                                                          review['rating'],
                                                          (index) => const Icon(
                                                            Icons.star,
                                                            color:
                                                                Colors.yellow,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                // Review text
                                                Text(
                                                  review['text'],
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black54),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
