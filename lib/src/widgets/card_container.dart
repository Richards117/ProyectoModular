import 'package:flutter/material.dart';

//contenedor Blanco ---------------------
class CardContainer extends StatelessWidget {
  final Widget child;
  const CardContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.black, width: 2),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 40,
              color: Colors.black,
            )
          ],
        ),
        child: child,
      ),
    );
  }
}
