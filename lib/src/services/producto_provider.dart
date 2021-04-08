import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

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

  Future<bool> editarProducto(Producto producto) async {
    final String id = producto.id;
    final url = '$_url/productos/$id.json';
    final resp = await http.put(Uri.parse(url), body: productoToJson(producto));
    final decodedData = json.decode(resp.body);
    print(decodedData);
    return true;
  }

  Future<String> subirImagen(File image) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dg6zvbnbl/image/upload?upload_preset=gapt4paf');
    final mimeType = mime(image.path).split('/');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', image.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();

    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal alv');
      print(resp.body);
      return null;
    }

    final respData = json.decode(resp.body);
    print(respData);

    return respData['secure_url'];
  }
}
