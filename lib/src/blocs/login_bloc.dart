import 'dart:async';

import 'package:formvalidation/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators {
  // aquí lo que estamos diciendo es que varios sink van a poder oir nuestros streams controllers y <Aquí decimos que lo que se transmite>
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //Insertar valores al stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  //recuperar los datos de esos streams
  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);
  //Ya que ambos streams tiene la información correcta podemos continuar con la activación del botton
  Stream<bool> get formValidStream =>
      CombineLatestStream.combine2(emailStream, passwordStream, (e, o) => true);

  //Obtener los valores de los streams
  String get email => _emailController.value;
  String get password => _passwordController.value;
  //Cerrar los streams
  dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}
