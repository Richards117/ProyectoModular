import 'package:flutter/material.dart';
import 'package:flutter_application_app/src/provider/login_provider.dart';
import 'package:flutter_application_app/src/service/auth_service.dart';
import 'package:flutter_application_app/src/widgets/card_container.dart';

import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 250),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text('Bienvenido Usuario',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: _LoginForm(),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 50),
              TextButton(
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(Colors.yellow),
                ),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, 'register'),
                child: const Text(
                  'Crear una \'Nueva Cuenta\'',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
                hintText: 'john.doe@gmail.com',
                labelText: 'Correo electrónico',
                prefixIcon: Icons.alternate_email_rounded),
            onChanged: (value) => loginForm.email = value,
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = RegExp(pattern);

              return regExp.hasMatch(value ?? '')
                  ? null
                  : 'El valor ingresado no luce como un correo';
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
                hintText: '*****',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline),
            onChanged: (value) => loginForm.password = value,
            validator: (value) {
              return (value != null && value.length >= 6)
                  ? null
                  : 'La contraseña debe de ser de 6 caracteres';
            },
          ),
          const SizedBox(height: 30),
          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: const Color.fromARGB(255, 64, 190, 197),
              onPressed: loginForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final authService =
                          Provider.of<AuthService>(context, listen: false);
                      if (!loginForm.isValidForm()) return;

                      loginForm.isLoading = true;

                      // todo:validar si el login es correcto
                      final String? errorMessage = await authService.login(
                          loginForm.email, loginForm.password);

                      if (errorMessage == null) {
                        Navigator.pushReplacementNamed(context, 'home');
                      } else {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                child: Row(
                                  children: [
                                    Icon(Icons.info,
                                        size: 40, color: Colors.red),
                                    SizedBox(width: 20),
                                    Text(
                                      '¡Alerta!',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            content: const Text(
                                ' El correo o la contraseña esta incorrecta',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold)),
                            actions: <Widget>[
                              TextButton(
                                style: ButtonStyle(
                                  overlayColor:
                                      WidgetStateProperty.all(Colors.yellow),
                                ),
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text(
                                  'Aceptar',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    shadows: [
                                      BoxShadow(
                                          color: Colors.black, blurRadius: 10)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                        loginForm.isLoading = false;
                      }
                    },
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: Text(
                    loginForm.isLoading ? 'Espere' : 'Ingresar',
                    style: const TextStyle(color: Colors.white),
                  )))
        ],
      ),
    );
  }
}

class InputDecorations {
  static InputDecoration authInputDecoration({
    required String hintText,
    required String labelText,
    IconData? prefixicon,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.black, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.blue, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(30)),
      labelText: labelText,
      labelStyle: const TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
      filled: true,
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
      ),
      prefixIcon:
          prefixicon != null ? Icon(prefixicon, color: Colors.indigo) : null,
      fillColor: Colors.grey.shade100,
    );
  }
}

class AuthBackground extends StatelessWidget {
  final Widget child;
  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      width: double.infinity,
      height: double.infinity,
      child: Stack(children: [
        //contenedor superior morado-----------------------
        const _PurpleBox(),

        //Icono superior de Person--------------------------
        const _IconHeard(),

        //contenedor blanco---------------------------------
        Positioned(child: child)
      ]),
    );
  }
}

//Icono superior de Person-----------------------------------------
class _IconHeard extends StatelessWidget {
  const _IconHeard();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        width: double.infinity,
        child: const Icon(
          Icons.person_pin,
          size: 160,
          color: Colors.white,
          shadows: [
            BoxShadow(color: Colors.white, blurRadius: 40),
          ],
        ),
      ),
    );
  }
}

//Contenedor morado parte superior estructura-----------------------
class _PurpleBox extends StatelessWidget {
  const _PurpleBox();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: authBoxDecoration(),
      child: const PosisionetBooble(),
    );
  }

  //Decoracion del contenedor morado-----------------------------------
  BoxDecoration authBoxDecoration() => const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(8, 140, 163, 1),
            Color.fromRGBO(26, 150, 156, 1),
          ],
        ),
      );
}

class Bubble extends StatelessWidget {
  const Bubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color.fromRGBO(255, 255, 255, 0.05)),
    );
  }
}

//Posiciones de las Burbujas de fondo en el contendor morado---------------
class PosisionetBooble extends StatelessWidget {
  const PosisionetBooble({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned(left: -10, top: 0, child: Bubble()),
        Positioned(left: -35, top: 250, child: Bubble()),
        Positioned(left: 330, top: -10, child: Bubble()),
        Positioned(left: 330, top: 190, child: Bubble()),
        Positioned(left: 200, top: 260, child: Bubble()),
        Positioned(left: 60, top: 168, child: Bubble()),
        Positioned(left: 200, top: 40, child: Bubble()),
        Positioned(left: 150, top: -80, child: Bubble()),
      ],
    );
  }
}
