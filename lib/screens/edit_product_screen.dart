import 'package:flutter/material.dart';
import '../providers/product.dart';
import '../providers/product_providers.dart';
import 'package:provider/provider.dart';

class EditedProduct extends StatefulWidget {
  static const routeName = 'edit-screen';
  @override
  _EditedProductState createState() => _EditedProductState();
}

class _EditedProductState extends State<EditedProduct> {
//we willuse FocusNode to store the value in TextFormField
  final _pricefocusNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageURLCOntroller = TextEditingController();
  final _imageurlNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editedproduct = Product(
    description: '',
    id: null,
    imageUrl: '',
    price: 0,
    title: '',
  );
  var _isLoading = false;
  var _initialvalues = {
    'description': '',
    'id': '',
    'imageUrl': '',
    'price': '',
    'title': '',
  };
  void _updateurl() {
    //HERE WE chech if the node still have focus andif not, then
    // we rebuild the page using the setState()
    //we do thos so that afetr putting the url,if we click anaywherer the page is rebuild and image is shown
    if (!_imageurlNode.hasFocus) {
      setState(() {});
    }
  }

  var _isinit = true;

  void initState() {
    _imageurlNode.addListener(_updateurl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isinit) {
      //because modalroute does not works in initState()
      final productid = ModalRoute.of(context).settings.arguments as String;
      if (productid != null) {
        _editedproduct =
            Provider.of<ProductProvider>(context).findById(productid);
        _initialvalues = {
          'title': _editedproduct.title,
          'price': _editedproduct.price.toString(),
          'description': _editedproduct.description,
          //'imageUrl': _editedproduct.imageUrl,
          'imageUrl': '',
          'id': _editedproduct.id,
        };
        //beacues we are using controller for image url in textfieldform,so we cannot use initiLAL VASLUE
        _imageURLCOntroller.text = _editedproduct.imageUrl;
      }
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  void _saveForm() async {
    setState(() {
      _isLoading = true;
    });

    //herer if dstatement is executed which means the value is empty then return cancles the futher prosseswes
    final valid = _formKey.currentState.validate();

    if (!valid) {
      return;
    }
    _formKey.currentState.save();
    if (_editedproduct.id != null) {
      await Provider.of<ProductProvider>(context, listen: false)
          .updateproduct(_editedproduct.id, _editedproduct);
    } else {
      try {
        await Provider.of<ProductProvider>(context, listen: false)
            .addproduct(_editedproduct);
      } catch (error) {
        //here we use await on showdialoge because we dont want to run finally directly,it will pop the screen,so
        //we wait till the showdialoge returns a future
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An Error ocurred!'),
            content: Text('Something went Wrong!!!!'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Okay'))
            ],
          ),
        );
      } //finally {
      //finally rns  o matter what happes that is wheate the try succeds or fails or error is encountered or not
      // setState(() {
      //   _isLoading = false;
      //   Navigator.of(context).pop();
      // });
      //}
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  void dispose() {
    //we dispose addlistener because if we will not do it h=then it weillkeep on listneing even the
    _imageurlNode.removeListener(_updateurl);
    _pricefocusNode.dispose();
    _descriptionNode.dispose();
    _imageURLCOntroller.dispose();
    _imageurlNode.dispose();
    super.dispose();
  }
  //here it is needed because FocuusNode sticks to the valuse  even after we are out of the screen
  //so we use dispose() method to dispose them after we leave the screen

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],
        title: Text('Edit Product'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                  key: _formKey,
                  //here we can also use Column() with singlechilscroolview()
                  //here we use listView becausae we have a small list,
                  //if we have a large INPUT LIST then we should use COLUMN with SINGLECHILDSCROlLVIEW
                  //because listview DYNMICSLLY REMOVES AND RE ADD Data that is out of the screen or scroll
                  //ListView have a cenain therhold till which it keeps data in memory
                  child: ListView(
                    children: [
                      //the values we will enter we automatically managed (saved)by Form() whwn we saubmitted
                      //but if we want touse the values before submitting we need to use controller
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Title'),
                        initialValue:
                            _initialvalues['title'], //previosulty saVED VALUE
                        //textInputAction buuton is the bottom right buutton on the soft keyboard
                        //and it tell swhat sdhould be done on pressing
                        //like in this case we will go to next field
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => {
                          FocusScope.of(context).requestFocus(_pricefocusNode)
                        },
                        //here value is automatically passed , it is the enterd value by the user
                        onSaved: (value) {
                          //here we creaste a new oblect of type productand overwrite the editedoriduct
                          _editedproduct = Product(
                              description: _editedproduct.description,
                              id: _editedproduct.id,
                              isFavorite: _editedproduct.isFavorite,
                              imageUrl: _editedproduct.imageUrl,
                              price: _editedproduct.price,
                              title: value);
                        }, //validtes the input ,if iput is correct like it is url or not,
                        //return null means correct and retirning any string means error//
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter a value';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initialvalues['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _pricefocusNode,
                        onFieldSubmitted: (_) => {
                          FocusScope.of(context).requestFocus(_descriptionNode)
                        },
                        onSaved: (value) {
                          //value if of string type
                          //here we creaste a new oblect of type productand overwrite the editedoriduct
                          _editedproduct = Product(
                              description: _editedproduct.description,
                              id: _editedproduct.id,
                              isFavorite: _editedproduct.isFavorite,
                              imageUrl: _editedproduct.imageUrl,
                              price: double.parse(
                                  value), //this converts value which is a string into  anumber
                              title: _editedproduct.title);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a price';
                          }
                          //tryparse returns null if fails
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid price';
                          }
                          if (double.parse(value) <= 0) {
                            return 'price too samll';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initialvalues['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        //textInputAction: TextInputAction.next,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionNode,
                        onSaved: (value) {
                          //here we creaste a new oblect of type productand overwrite the editedoriduct
                          _editedproduct = Product(
                              description: value,
                              id: _editedproduct.id,
                              isFavorite: _editedproduct.isFavorite,
                              imageUrl: _editedproduct.imageUrl,
                              price: _editedproduct.price,
                              title: _editedproduct.title);
                        },
                        validator: (value) {
                          if (value.length < 10) {
                            return 'AT least 10 characters required';
                          }
                          return null;
                        },
                        //onFieldSubmitted: (_) =>
                        //      {FocusScope.of(context).requestFocus(_pricefocusNode)},
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: Colors.brown[400]),
                            ),
                            child: Container(
                              //we need to used .text. before using is Empty if we a usng object of TextEDitingCOntroller type
                              child: _imageURLCOntroller.text.isEmpty
                                  ? Center(
                                      child: Text(
                                        'Image URL Empty',
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : FittedBox(
                                      fit: BoxFit.fill,
                                      child: Image.network(
                                          _imageURLCOntroller.text),
                                    ),
                            ),
                          ),

                          // SizedBox(
                          //   width: 10,
                          // ),
                          Expanded(
                            child: TextFormField(
                              //we cannot use oinitiaalvaluie if we are using controller
                              //initialValue: _initialvalues['imageUrl'],
                              decoration:
                                  InputDecoration(labelText: 'Image Url'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              //here we are using controller because we want to uise the value user entered
                              //before ther form is submitted
                              controller: _imageURLCOntroller,
                              focusNode: _imageurlNode,
                              onSaved: (value) {
                                //here we creaste a new oblect of type productand overwrite the editedoriduct
                                _editedproduct = Product(
                                    description: _editedproduct.description,
                                    id: _editedproduct.id,
                                    isFavorite: _editedproduct.isFavorite,
                                    imageUrl: value,
                                    price: _editedproduct.price,
                                    title: _editedproduct.title);
                              },
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              validator: (val) {
                                if (val.isEmpty) {
                                  return 'Please enter a url';
                                }
                                // if (!val.startsWith('http') &&
                                //     !val.startsWith('https')) {
                                //   return 'Please enter a valid url';
                                // }
                                // if (!val.endsWith('.png') && !val.endsWith('jpg')) {
                                //   return 'enter a url for a image';
                                // }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
    );
  }
}
