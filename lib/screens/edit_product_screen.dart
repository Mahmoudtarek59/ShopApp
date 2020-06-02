import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  final Product EProduct;
  EditProductScreen({this.EProduct});
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final _priceFocusNode = FocusNode(); //to move from text form field to another
  final _decriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  Product product = Product(
    id: null,
    title: '',
    description: '',
    imageUrl: '',
    price: 0,
  );

  var initValue = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  String title;
  double price;
  String description;

  bool isLoading = false;

  @override
  void initState() {
    if (widget.EProduct != null) {
      product = widget.EProduct;
      initValue = {
        'title': product.title,
        'description': product.description,
        'price': product.price.toString(),
        'imageUrl': '',
      };
      _imageUrlController.text = product.imageUrl;
    }
    _imageUrlFocusNode.addListener(_updateImageURL);
    super.initState();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _decriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageURL);
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageURL() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() async {
    final formData = _formState.currentState;
    if (formData.validate()) {
      formData.save();
      setState(() {
        isLoading = true;
      });
      if (product.id == null) {
        product = Product(
          id: null,
          title: title,
          description: description,
          imageUrl: _imageUrlController.text,
          price: price,
        );
        try {
          await Provider.of<Products>(context, listen: false)
              .addProduct(product); //wait for complete this step or use then
        } catch (e) {
          await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('An error occurred!'),
                    content: Text(e.toString()),
                    actions: [
                      FlatButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Okay'))
                    ],
                  ));
        } finally {
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).pop();
        }
      } else {
        product = Product(
          id: widget.EProduct.id,
          title: title,
          description: description,
          imageUrl: _imageUrlController.text,
          price: price,
          isFavorite: widget.EProduct.isFavorite,
        );
        await Provider.of<Products>(context, listen: false)
            .updateProduct(product);
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      }
//      formData.reset();

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formState,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: initValue['title'],
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_priceFocusNode),
                      validator: (val) {
                        if (val.isEmpty) return 'enter Title';
                      },
                      onSaved: (val) => title = val,
                    ),
                    TextFormField(
                      initialValue: initValue['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_decriptionFocusNode),
                      validator: (val) {
                        if (val.isEmpty) return 'enter Price';
                        if (double.parse(val) == null)
                          return 'enter a valid number';
                        if (double.parse(val) <= 0)
                          return 'enter a number greater than zero';
                      },
                      onSaved: (val) => price = double.parse(val),
                    ),
                    TextFormField(
                      initialValue: initValue['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      textInputAction: TextInputAction.next,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _decriptionFocusNode,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_imageUrlFocusNode),
                      validator: (val) {
                        if (val.isEmpty) return 'enter a Description';
                      },
                      onSaved: (val) => description = val,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Center(
                                  child: Text('Enter a URL'),
                                )
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageUrlFocusNode,
                            controller: _imageUrlController,
                            validator: (val) {
                              if (val.isEmpty) return 'enter a URL';
                              if (!val.toLowerCase().startsWith('http') &&
                                  !val.toLowerCase().startsWith('https'))
                                return 'please enter avalid URL';
                              if (!val.toLowerCase().endsWith('.png') &&
                                  !val.toLowerCase().endsWith('.jpg') &&
                                  !val.toLowerCase().endsWith('.jpeg'))
                                return 'please enter a valid image url';
                            },
                            onFieldSubmitted: (_) => _saveForm(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
