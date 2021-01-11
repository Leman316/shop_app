import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product_provider.dart';
import 'package:shop_app/provider/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/editprod';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _pricefocusnode = FocusNode();
  final _descfocusnode = FocusNode();
  final _imageurlcontroller = TextEditingController();
  final _imageurlfocusnode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');
  var _initvalue = {
    'title': '',
    'description': '',
    'price': '',
    'imageurl': '',
  };

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    _imageurlfocusnode.addListener(() {
      if (_imageurlfocusnode.hasFocus) {}
    });
    super.initState();
  }

  var _isInit = true;
  var _isloading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      final prodId = ModalRoute.of(context).settings.arguments;
      if (prodId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findbyId(prodId);
        _initvalue = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageurl': '',
        };
        _imageurlcontroller.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    _pricefocusnode.dispose();
    _descfocusnode.dispose();
    _imageurlfocusnode.dispose();
    _imageurlcontroller.dispose();
    super.dispose();
  }

  void _saveForm() async {
    final isvalid = _form.currentState.validate();
    if (!isvalid) {
      return;
    }

    _form.currentState.save();

    setState(() {
      _isloading = true;
    });

    if (_editedProduct.id != null) {
      // print('BB ${_editedProduct.id}');
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);

      _isloading = false;
      Navigator.of(context).pop();
    } else {
      //  print(_editedProduct.title);
      // print(_editedProduct.price);
      Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct)
          .catchError((error) {
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error Detected'),
              content: Text('Something went Wrong. error'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }).then((_) {
        _isloading = false;
        Navigator.of(context).pop();
      });
    }

    // Navigator.of(context).pop();
  }

  void _updateimageurl() {
    if (_imageurlfocusnode.hasFocus) {
      var value = _imageurlcontroller.text;
      setState(() {
        if (value.isEmpty) return 'Enter a image URL';
        if (!value.startsWith('http') && !value.startsWith('https'))
          return 'Not a valid URL';
        return null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Added Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isloading
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
                      initialValue: _initvalue['title'],
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_pricefocusnode);
                      },
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Wrong';
                        }
                        return null;
                      },
                      onSaved: (newValue) => _editedProduct = Product(
                          id: _editedProduct.id,
                          title: newValue,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl),
                    ),
                    TextFormField(
                      initialValue: _initvalue['price'],
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (newValue) => _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(newValue),
                          imageUrl: _editedProduct.imageUrl),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter a Price';
                        }
                        if (double.tryParse(value) == null)
                          return 'Enter a valid number';
                        if (double.parse(value) <= 0)
                          return 'Enter a number >0';
                        return null;
                      },
                      focusNode: _pricefocusnode,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_descfocusnode),
                    ),
                    TextFormField(
                      initialValue: _initvalue['description'],
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                      focusNode: _descfocusnode,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value.isEmpty) return 'Enter a description';
                        if (value.length < 10)
                          return 'Needs a long description';
                        return null;
                      },
                      onSaved: (newValue) => _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: newValue,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl),

                      // textInputAction: TextInputAction.next,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 10, right: 8),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageurlcontroller.text.isEmpty
                              ? Text('Enter Url')
                              : FittedBox(
                                  child:
                                      Image.network(_imageurlcontroller.text),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            //initialValue: _initvalue['imageurl'],
                            decoration: InputDecoration(
                              labelText: 'Input Url',
                            ),
                            validator: (value) {
                              if (value.isEmpty) return 'Enter a image URL';
                              if (!value.startsWith('http:') &&
                                  !value.startsWith('https:'))
                                return 'Not a valid URL';
                              return null;
                            },
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageurlcontroller,
                            focusNode: _imageurlfocusnode,
                            onFieldSubmitted: (_) => _saveForm(),
                            onSaved: (newValue) => _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: newValue),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
