import 'package:flutter/material.dart';

import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

  final _nameController =
      TextEditingController();

  final _emailController =
      TextEditingController();

  final _passwordController =
      TextEditingController();

  final _confirmController =
      TextEditingController();

  final _universidadController =
      TextEditingController();

  final _carreraController =
      TextEditingController();

  final _direccionController =
      TextEditingController();

  String _selectedRole =
      'pasajero';

  bool _loading=false;

  String? _error;



  @override
  void dispose(){

    _nameController.dispose();

    _emailController.dispose();

    _passwordController.dispose();

    _confirmController.dispose();

    _universidadController.dispose();

    _carreraController.dispose();

    _direccionController.dispose();

    super.dispose();

  }



  Future<void> _register() async {

    setState(() {

      _loading=true;

      _error=null;

    });

    final nombre =
    _nameController.text.trim();

    final email =
    _emailController.text.trim();

    final password =
    _passwordController.text.trim();

    final confirm =
    _confirmController.text.trim();

    if(

    nombre.isEmpty ||

    email.isEmpty ||

    password.isEmpty ||

    confirm.isEmpty ||

    _universidadController.text.isEmpty ||

    _carreraController.text.isEmpty ||

    _direccionController.text.isEmpty

    ){

      setState(() {

        _error=
        "Todos los campos son obligatorios";

        _loading=false;

      });

      return;

    }

    if(password!=confirm){

      setState(() {

        _error=
        "Las contraseñas no coinciden";

        _loading=false;

      });

      return;

    }

    try{

      await ApiService().register(

        username:
        nombre,

        email:
        email,

        password:
        password,

        universidad:
        _universidadController.text,

        carrera:
        _carreraController.text,

        direccion:
        _direccionController.text,

      );

      if(!mounted)return;

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content:
          Text(
            "Registro exitoso"
          ),

        ),

      );

      Navigator.pop(context);

    }

    catch(e){

      setState(() {

        _error=
        "Error registrando usuario";

      });

    }

    setState(() {

      _loading=false;

    });

  }



  @override
  Widget build(
      BuildContext context
      ) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
            'Carpulia - Registro'
        ),

      ),

      body: SingleChildScrollView(

        padding:
        const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.stretch,

          children: [

            const SizedBox(
                height:20),

            Image.asset(
              'assets/images/Logo_V.png',
              height:120,
            ),

            const SizedBox(
                height:20),

            TextField(

              controller:
              _nameController,

              decoration:
              const InputDecoration(

                labelText:
                "Nombre completo",

              ),

            ),

            const SizedBox(
                height:12),

            TextField(

              controller:
              _emailController,

              decoration:
              const InputDecoration(

                labelText:
                "Correo",

              ),

            ),

            const SizedBox(
                height:12),

            DropdownButtonFormField<String>(

              initialValue:
              _selectedRole,

              items: const [

                DropdownMenuItem(

                  value:
                  'pasajero',

                  child:
                  Text(
                      'Pasajero'
                  ),

                ),

                DropdownMenuItem(

                  value:
                  'conductor',

                  child:
                  Text(
                      'Conductor'
                  ),

                ),

              ],

              onChanged:(v){

                if(v!=null){

                  setState(() {

                    _selectedRole=v;

                  });

                }

              },

            ),

            const SizedBox(
                height:12),

            TextField(

              controller:
              _universidadController,

              decoration:
              const InputDecoration(

                labelText:
                "Universidad",

              ),

            ),

            const SizedBox(
                height:12),

            TextField(

              controller:
              _carreraController,

              decoration:
              const InputDecoration(

                labelText:
                "Carrera",

              ),

            ),

            const SizedBox(
                height:12),

            TextField(

              controller:
              _direccionController,

              decoration:
              const InputDecoration(

                labelText:
                "Dirección residencia",

              ),

            ),

            const SizedBox(
                height:12),

            TextField(

              controller:
              _passwordController,

              obscureText:true,

              decoration:
              const InputDecoration(

                labelText:
                "Contraseña",

              ),

            ),

            const SizedBox(
                height:12),

            TextField(

              controller:
              _confirmController,

              obscureText:true,

              decoration:
              const InputDecoration(

                labelText:
                "Confirmar contraseña",

              ),

            ),

            const SizedBox(
                height:20),

            if(_error!=null)

              Text(

                _error!,

                style:
                const TextStyle(
                    color: Colors.red
                ),

              ),

            const SizedBox(
                height:20),

            FilledButton.tonal(

              onPressed:

              _loading
                  ?null
                  :_register,

              child:

              _loading

                  ?const CircularProgressIndicator()

                  :const Text(
                  'Registrarse'
              ),

            )

          ],

        ),

      ),

    );

  }

}