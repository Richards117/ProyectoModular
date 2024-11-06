/*import 'package:flutter/material.dart';
import 'package:flutter_application_app/src/screens/places/details_screen.dart';

// Widget para mostrar reseñas
class ReviewsWidget extends StatelessWidget {
  final List<Review> reviews;

  const ReviewsWidget({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return ListTile(
          title: Text(review.user),
          subtitle: Text(review.comment),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (i) {
              return Icon(
                i < review.rating ? Icons.star : Icons.star_border,
              );
            }),
          ),
        );
      },
    );
  }
}

// Pantalla para agregar nueva reseña
class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({super.key});

  @override
  State createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  int _rating = 0;

  void _setRating(int rating) {
    setState(() {
      _rating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 27, 184, 192),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
          shadows: [BoxShadow(color: Colors.white, blurRadius: 10)],
        ),
        title: const Center(
          child: Text('Añadir Reseña'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _userController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese su nombre';
                  }
                  return null;
                },
                decoration:
                    const InputDecoration(labelText: 'Nombre de usuario'),
              ),
              TextFormField(
                controller: _commentController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese un comentario';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Comentario'),
              ),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                    ),
                    onPressed: () => _setRating(index + 1),
                  );
                }),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: WidgetStateProperty.all(
                    Colors.yellow,
                  ),
                  backgroundColor: WidgetStateProperty.all(
                    const Color.fromARGB(255, 27, 184, 192),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate() && _rating > 0) {
                    final newReview = Review(
                      user: _userController.text,
                      comment: _commentController.text,
                      rating: _rating,
                    );

                    Navigator.pop(context, newReview);
                  } else if (_rating == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor, ingrese una calificación'),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Guardar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/