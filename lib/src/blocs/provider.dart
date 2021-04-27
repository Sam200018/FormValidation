import 'package:flutter/material.dart';

import 'package:formvalidation/src/blocs/login_bloc.dart';
export 'package:formvalidation/src/blocs/login_bloc.dart';

import 'package:formvalidation/src/blocs/products_bloc.dart';
export 'package:formvalidation/src/blocs/products_bloc.dart';

class Provider extends InheritedWidget {
  //Aqui es donde colocamos todos los blocs para poder usarlos en el mantenimiento de estado de la app
  final loginBloc = LoginBloc();
  final _productsBloc = ProductsBloc();

  //De esta manera podemos mantener la información dentro del patron BLoC
  static Provider _instancia;

  factory Provider({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = new Provider._internal(key: key, child: child);
    }

    return _instancia;
  }

  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  // Provider({Key key, Widget child}) : super(key: key, child: child);
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  //Cada static es para poder regresar un BLoC en especifico, para agregar un nuevo solamente
  //necesitamos cambiar las propiedades de ProductsBloc y el ()._productsBloc por sus respectivos
  //BLoCs
  static LoginBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }

  static ProductsBloc productsBloc(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()._productsBloc;
  }
}
