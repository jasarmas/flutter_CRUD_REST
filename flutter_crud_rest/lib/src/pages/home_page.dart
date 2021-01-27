import 'package:flutter/material.dart';
import 'package:flutter_patron_bloc/src/bloc/provider.dart';
import 'package:flutter_patron_bloc/src/models/product_model.dart';
import 'package:flutter_patron_bloc/src/providers/products_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final productsProvider = new ProductsProvider();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("HomePage")),
      ),
      body: _createProductList(),
      floatingActionButton: _createButton(context),
    );
  }

  Widget _createButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, "product")
          .then((value) => setState(() {})),
      child: Icon(Icons.add),
      backgroundColor: Colors.deepOrangeAccent,
    );
  }

  Widget _createProductList() {
    return FutureBuilder(
      future: productsProvider.loadProducts(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if (snapshot.hasData) {
          final products = snapshot.data;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, i) => _createItem(products[i], context),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _createItem(ProductModel product, BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(color: Colors.red),
      onDismissed: (direction) =>
          productsProvider.deleteProduct(product.id), //borrar item,
      child: ListTile(
        title: Text("${product.title} - ${product.value}"),
        subtitle: Text(product.id),
        onTap: () => Navigator.pushNamed(context, "product", arguments: product)
            .then((value) => setState(() {})),
      ),
    );
  }
}
