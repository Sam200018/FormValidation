import 'package:flutter/material.dart';
import 'package:formvalidation/src/blocs/provider.dart';

import 'package:formvalidation/src/models/producto_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final productsBloc = Provider.productsBloc(context);
    productsBloc.cargarProductos();

    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: _crearListado(productsBloc),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearListado(ProductsBloc productsBloc) {
    return StreamBuilder(
      stream: productsBloc.productosStream,
      builder: (BuildContext context, AsyncSnapshot<List<Producto>> snapshot) {
        if (snapshot.hasData) {
          final productos = snapshot.data;

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, i) {
              return _productoItem(context, productsBloc, productos[i]);
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

  Widget _productoItem(
      BuildContext context, ProductsBloc productsBloc, Producto producto) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red[900],
        ),
        onDismissed: (direccion) => productsBloc.borrarProducto(producto),
        child: Card(
          child: Column(
            children: [
              ListTile(
                title: Text('${producto.titulo} - ${producto.valor}'),
                subtitle: Text(producto.id),
                onTap: () =>
                    Navigator.pushNamed(context, 'product', arguments: producto)
                        .then((value) => setState(() {})),
              ),
              (producto.fotoUrl == '')
                  ? Image(image: AssetImage('assets/no-image.png'))
                  : FadeInImage(
                      placeholder: AssetImage('assets/jar-loading.gif'),
                      image: NetworkImage(producto.fotoUrl),
                      height: 200.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ],
          ),
        ));
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
