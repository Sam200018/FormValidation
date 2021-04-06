import 'package:flutter/material.dart';

import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/services/producto_provider.dart';
// import 'package:formvalidation/src/blocs/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final productosProvider = new ProductsProvider();

  @override
  Widget build(BuildContext context) {
    // final bloc = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: _crearListado(),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearListado() {
    return FutureBuilder(
      future: productosProvider.cargarProductos(),
      builder: (BuildContext context, AsyncSnapshot<List<Producto>> snapshot) {
        if (snapshot.hasData) {
          final productos = snapshot.data;

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, i) {
              return _productoItem(context, productos[i]);
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _productoItem(BuildContext context, Producto producto) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direccion) {
        productosProvider.borrarProducto(producto);
      },
      child: ListTile(
        title: Text('${producto.titulo} - ${producto.valor}'),
        subtitle: Text(producto.id),
        onTap: () =>
            Navigator.pushNamed(context, 'product', arguments: producto)
                .then((value) => setState(() {})),
      ),
    );
  }

  Widget _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'product')
          .then((value) => setState(() {})),
    );
  }
}
