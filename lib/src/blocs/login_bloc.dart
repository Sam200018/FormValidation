import 'dart:async';

import 'package:formvalidation/src/blocs/validators.dart';

class LoginBloc with Validators {
  // aquí lo que estamos diciendo es que varios sink van a poder oir nuestros streams controllers y <Aquí decimos que lo que se transmite>
  final _emailController = StreamController<String>.broadcast();
  final _passwordController = StreamController<String>.broadcast();

  //Insertar valores al stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  //recuperar los datos de esos streams
  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);

  //Cerrar los streams
  dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}
