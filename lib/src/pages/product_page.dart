import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/services/producto_provider.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  //Keys
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  //Providers
  final productoProvider = new ProductsProvider();
  //Globals
  bool _guardando = false;
  File photo;

  Producto producto = new Producto();
  @override
  Widget build(BuildContext context) {
    final Producto prodData = ModalRoute.of(context).settings.arguments;
    if (prodData != null) {
      producto = prodData;
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title:
            prodData != null ? Text(prodData.titulo) : Text('Nuevo Producto'),
        actions: [
          IconButton(
              icon: Icon(Icons.photo_size_select_actual),
              onPressed: _seleccionarFoto),
          IconButton(icon: Icon(Icons.camera_alt), onPressed: _tomarFoto),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Producto'),
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese más de 3 caracteres';
        } else
          return null;
      },
      onSaved: (value) => producto.titulo = value,
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Precio MXN.00'),
      validator: (value) {
        if (utils.isANumber(value)) {
          return null;
        } else
          return 'Solo números';
      },
      onSaved: (value) => producto.valor = double.parse(value),
    );
  }

  Widget _crearBoton() {
    return TextButton.icon(
      style: TextButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        primary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      icon: Icon(Icons.save),
      label: Text('Guardar'),
      onPressed: _guardando ? null : _submit,
    );
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() {
        producto.disponible = value;
      }),
    );
  }

  void _submit() {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    setState(() {
      _guardando = true;
    });

    if (producto.id != null) {
      productoProvider.editarProducto(producto);
    } else {
      productoProvider.creaProducto(producto);
    }
    setState(() {
      _guardando = false;
    });
    mostraSnackbar(context, 'Registro Guardado!');
  }

  void mostraSnackbar(BuildContext context, String message) {
    final snackbar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 2000),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    Navigator.pop(context);
  }

  Widget _mostrarFoto() {
    if (producto.fotoUrl != '') {
      //TODO: fix it
      return Container();
    } else {
      return Image(
        image: photo != null
            ? FileImage(photo)
            : AssetImage('assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }

  Future _seleccionarFoto() async {
    _procesarFoto(ImageSource.gallery);
  }

  Future _tomarFoto() async {
    _procesarFoto(ImageSource.camera);
  }

  _procesarFoto(ImageSource origin) async {
    final _picker = ImagePicker();
    final pickedPhoto = await _picker.getImage(source: origin);
    setState(() {
      if (pickedPhoto != null) {
        photo = File(pickedPhoto.path);
      } else {
        print('No se selecciono ninguna foto');
      }
    });
  }
}
