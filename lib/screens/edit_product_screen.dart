import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFoucsNode = FocusNode();
  final _descreptinFouceNode = FocusNode();
  final _imageUrlConttroller = TextEditingController();
  final _imageUrlFoucsNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedtProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');

  var _isInit = true;
  var _isLoading = false;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedtProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedtProduct.title,
          'description': _editedtProduct.description,
          'price': _editedtProduct.price.toString(),
          'imageUrl': ''
        };
        _imageUrlConttroller.text = _editedtProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _imageUrlFoucsNode.addListener(_updateImageurl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFoucsNode.removeListener(_updateImageurl);
    _priceFoucsNode.dispose();
    _descreptinFouceNode.dispose();
    _imageUrlConttroller.dispose();
    _imageUrlFoucsNode.dispose();
    super.dispose();
  }

  void _updateImageurl() {
    if ((!_imageUrlConttroller.text.startsWith('http') &&
            !_imageUrlConttroller.text.startsWith('https')) ||
        (!_imageUrlConttroller.text.endsWith('.png') &&
            !_imageUrlConttroller.text.endsWith('.jpg') &&
            !_imageUrlConttroller.text.endsWith('.jpeg'))) {
      return;
    }
    if (!_imageUrlFoucsNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedtProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedtProduct.id, _editedtProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedtProduct);
      } catch (error) {
        await showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error occurred'),
                  content: Text('Something went wrong'),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text('Okay'))
                  ],
                ));
      }
      // finally {
      //  setState(() {
      //    _isLoading = false;
      //  });
     //   Navigator.of(context).pop();
     // }
    }
     setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm)
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFoucsNode);
                      },
                      onSaved: (value) {
                        _editedtProduct = Product(
                            id: _editedtProduct.id,
                            title: value,
                            description: _editedtProduct.description,
                            price: _editedtProduct.price,
                            imageUrl: _editedtProduct.imageUrl,
                            isFavorite: _editedtProduct.isFavorite);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a velue.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFoucsNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descreptinFouceNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter a Price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter a number greater than zero';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedtProduct = Product(
                              id: _editedtProduct.id,
                              title: _editedtProduct.title,
                              description: _editedtProduct.description,
                              price: double.parse(value),
                              imageUrl: _editedtProduct.imageUrl,
                              isFavorite: _editedtProduct.isFavorite);
                        }),
                    TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descreptinFouceNode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a descriptions';
                          }
                          if (value.length < 10) {
                            return 'Should ne at least 10 characters long';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedtProduct = Product(
                              id: _editedtProduct.id,
                              title: _editedtProduct.title,
                              description: value,
                              price: _editedtProduct.price,
                              imageUrl: _editedtProduct.imageUrl,
                              isFavorite: _editedtProduct.isFavorite);
                        }),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageUrlConttroller.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                      _imageUrlConttroller.text,
                                      fit: BoxFit.cover),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlConttroller,
                              focusNode: _imageUrlFoucsNode,
                              onFieldSubmitted: (_) => _saveForm(),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter an image Url. ';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please enter a vaild URL.';
                                }
                                if (!value.endsWith('.png') &&
                                    !value.endsWith('.jpg') &&
                                    !value.endsWith('.jpeg') &&
                                    !value.endsWith('image=9')) {
                                  return 'Please enter a vaild image URL.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _editedtProduct = Product(
                                    id: _editedtProduct.id,
                                    title: _editedtProduct.title,
                                    description: _editedtProduct.description,
                                    price: _editedtProduct.price,
                                    imageUrl: value,
                                    isFavorite: _editedtProduct.isFavorite);
                              }),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
