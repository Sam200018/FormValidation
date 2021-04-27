import 'dart:io';

import 'package:formvalidation/src/services/producto_provider.dart';
import 'package:rxdart/rxdart.dart';

import 'package:formvalidation/src/models/producto_model.dart';

class ProductsBloc {
  final _productsController = new BehaviorSubject<List<Producto>>();
  final _cargandoController = new BehaviorSubject<bool>();

  final _productsProvider = new ProductsProvider();

  Stream<List<Producto>> get productosStream => _productsController.stream;
  Stream<bool> get cargando => _cargandoController.stream;

  void cargarProductos() async {
    final productos = await _productsProvider.cargarProductos();
    _productsController.sink.add(productos);
  }

  void agregarProducto(Producto producto) async {
    _cargandoController.sink.add(true);
    await _productsProvider.creaProducto(producto);
    _cargandoController.sink.add(false);
  }

  Future<String> subirFoto(File photo) async {
    _cargandoController.sink.add(true);
    final fotoUrl = await _productsProvider.subirImagen(photo);

    _cargandoController.sink.add(false);
    return fotoUrl;
  }

  void editarProducto(Producto producto) async {
    _cargandoController.sink.add(true);
    await _productsProvider.editarProducto(producto);
    _cargandoController.sink.add(false);
  }

  void borrarProducto(Producto producto) async {
    await _productsProvider.borrarProducto(producto);
  }

  dispose() {
    _productsController?.close();
    _cargandoController?.close();
  }
}
