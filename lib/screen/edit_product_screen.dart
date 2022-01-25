import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _form = GlobalKey<FormState>();
  final _priceFN = FocusNode();
  final _descriFN = FocusNode();
  final _imageUrlFN = FocusNode();
  final _imageUrlController = TextEditingController();
  bool _isInitiated = true;
  Product _newProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0.0,
    imageUrl: '',
  );
  var _initValue = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _imageUrlController.addListener(_updateImageListener);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInitiated) {
      final _productId = ModalRoute.of(context).settings.arguments;
      // print(_productId);

      if (_productId != null) {
        final _newProduct =
            Provider.of<Products>(context, listen: false).findbyID(_productId);

        print(_newProduct.id);
        _initValue = {
          'id': _newProduct.id,
          'title': _newProduct.title,
          'price': _newProduct.price.toString(),
          'description': _newProduct.description,
        };
        _imageUrlController.text = _newProduct.imageUrl;
      }
    }
    _isInitiated = false;
    super.didChangeDependencies();
  }

  void _updateImageListener() {
    if (!_imageUrlFN.hasFocus &&
        _imageUrlController.text.contains('http') &&
        _imageUrlController.text.isEmpty) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageUrlFN.dispose();
    _imageUrlController.removeListener(_updateImageListener);
    _descriFN.dispose();
    _priceFN.dispose();
    super.dispose();
  }

  void _saveForm() {
    final _val = _form.currentState.validate();
    if (!_val) {
      return;
    }
    _form.currentState.save();
    if (_newProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_newProduct.id, _newProduct);
    }
    if (_newProduct.id == null) {
      Provider.of<Products>(context, listen: false).addProduct(_newProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Product'),
        actions: [
          IconButton(
            onPressed: () {
              _saveForm();
            },
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _initValue['title'],
                  decoration: InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFN);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a title';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    _newProduct = Product(
                      id: _initValue['id'],
                      title: value,
                      description: _newProduct.description,
                      price: _newProduct.price,
                      imageUrl: _newProduct.imageUrl,
                    );
                  },
                ),
                TextFormField(
                  initialValue: _initValue['price'],
                  focusNode: _priceFN,
                  decoration: InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  validator: (_) {
                    if (_.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(_) == null) {
                      return 'Please enter a valid price';
                    }
                    if (double.parse(_) < 0) {
                      return 'Please enter grater than zero';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    _newProduct = Product(
                      id: _newProduct.id,
                      title: _newProduct.title,
                      description: _newProduct.description,
                      price: double.parse(value),
                      imageUrl: _newProduct.imageUrl,
                    );
                  },
                ),
                TextFormField(
                  initialValue: _initValue['description'],
                  focusNode: _descriFN,
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (_) {
                    if (_.isEmpty) {
                      return 'Please enter a description';
                    }
                    if (_.length < 10) {
                      return 'Please enter at least 10 charecter';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    _newProduct = Product(
                      id: _newProduct.id,
                      title: _newProduct.title,
                      description: value,
                      price: _newProduct.price,
                      imageUrl: _newProduct.imageUrl,
                    );
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      margin: EdgeInsets.only(top: 4, right: 6),
                      decoration: BoxDecoration(
                          border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      )),
                      child: _imageUrlController.text.isEmpty
                          ? Text('Enter a URL')
                          : Image.network(_imageUrlController.text),
                    ),
                    Expanded(
                      child: TextFormField(
                        focusNode: _imageUrlFN,
                        // initialValue: _imageUrlController.text,
                        decoration: InputDecoration(labelText: 'Image URL'),
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        validator: (value) {
                          if (value.startsWith('http')) {
                            return null;
                          } else {
                            return 'Please enter a valid URL';
                          }
                        },
                        onSaved: (value) {
                          _newProduct = Product(
                            id: _newProduct.id,
                            title: _newProduct.title,
                            description: _newProduct.description,
                            price: _newProduct.price,
                            imageUrl: value,
                          );
                        },
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
