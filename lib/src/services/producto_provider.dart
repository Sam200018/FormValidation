import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:formvalidation/src/models/producto_model.dart';

class ProductsProvider {
  final String _url = 'https://restaurant-dcde0-default-rtdb.firebaseio.com';

  Future<bool> creaProducto(Producto producto) async {
    final url = '$_url/productos.json';

    final resp =
        await http.post(Uri.parse(url), body: productoToJson(producto));

    final decodedData = json.decode(resp.body);

    print(decodedData);
    return true;
  }

  Future<List<Producto>> cargarProductos() async {
    final url = '$_url/productos.json';
    final List<Producto> productos = [];
    final resp = await http.get(Uri.parse(url));

    final Map<String, dynamic> decodedData = json.decode(resp.body);

    if (decodedData == null) return [];

    decodedData.forEach((id, producto) {
      final produTemp = Producto.fromJson(producto);
      produTemp.id = id;
      productos.add(produTemp);
    });

    return productos;
  }

  Future<bool> borrarProducto(Producto producto) async {
    final String id = producto.id;
    final url = '$_url/productos/$id.json';
    final resp = await http.delete(Uri.parse(url));
    final decodedData = json.decode(resp.body);
    print(decodedData);
    return true;
  }
}
