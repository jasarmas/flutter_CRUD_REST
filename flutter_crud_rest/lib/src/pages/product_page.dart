import 'package:flutter/material.dart';
import 'package:flutter_patron_bloc/src/models/product_model.dart';
import 'package:flutter_patron_bloc/src/providers/products_provider.dart';
import 'package:flutter_patron_bloc/src/utils/utils.dart' as utils;

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final productsProvider = new ProductsProvider();

  ProductModel product = new ProductModel();
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final ProductModel prodData = ModalRoute.of(context).settings.arguments;
    if (prodData != null) {
      product = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Producto"),
        actions: [
          IconButton(
              icon: Icon(Icons.photo_size_select_actual), onPressed: () {}),
          IconButton(icon: Icon(Icons.camera_alt), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _createName(),
                _createPrice(),
                _createAvailable(),
                _createButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createName() {
    return TextFormField(
      initialValue: product.title,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: "Producto",
      ),
      onSaved: (newValue) => product.title = newValue,
      validator: (value) {
        if (value.length < 3) {
          return "Ingrese nombre del producto";
        }
        return null;
      },
    );
  }

  Widget _createPrice() {
    return TextFormField(
      initialValue: product.value.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: "Precio",
      ),
      onSaved: (newValue) => product.value = double.parse(newValue),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return "Solo números";
        }
      },
    );
  }

  Widget _createButton() {
    return RaisedButton.icon(
      onPressed: _saving ? null : _submit,
      icon: Icon(Icons.save),
      label: Text("Guardar"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
    );
  }

  void _submit() {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    setState(() {
      _saving = true;
    });

    if (product.id == null) {
      productsProvider.createProduct(product);
    } else {
      productsProvider.editProduct(product);
    }

    displaySnackBar("Registro guardado");

    Navigator.pop(context);
  }

  Widget _createAvailable() {
    return SwitchListTile(
      value: product.available,
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() {
        product.available = value;
      }),
      title: Text("Disponible"),
    );
  }

  void displaySnackBar(String message) {
    final snackbar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }
}
