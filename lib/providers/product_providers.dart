import 'package:flutter/material.dart';
import './product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';
//here we use a mixin "with",  which is used to merge two class

class ProductProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg
    //       '',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal yo want.',
    //   price: 49.99,u
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  //here we are returning a copy of _items which we do by adding [...<name>],spread operator ... and square brackets
  var showFavorite = false;
  final userId;
  final String authToken;
  ProductProvider(this.authToken, this._items, this.userId);
  List<Product> get items {
    if (showFavorite) {
      return [
        ..._items.where((element) => element.isFavorite == true).toList()
      ];
    }
    return [..._items];
  }

  // List<Product> get showFav {
  //   return _items.where((element) => element.isFavorite).toList();
  // }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> deleteproduct(String prodid) async {
    final url = Uri.parse(
        'https://shop-app-1f3ec-default-rtdb.firebaseio.com/products/$prodid.json?auth=$authToken');
    final existingproductindex =
        _items.indexWhere((element) => element.id == prodid);
    var existingproduct = _items[existingproductindex];
    _items.removeAt(existingproductindex);
    notifyListeners();
    final response = await http.delete(
        url); //for delete,put and patch request server doesnt returns error it inly ereturns error fro get and post request
    //...........................................fro delete,patch and put it returnd http errors or STATUSCODES
    if (response.statusCode >= 400) {
      _items.insert(existingproductindex, existingproduct);

      notifyListeners();
//throw works as return, so if throw executesw then functin will go any futher in this function
      throw HttpException('COuld not delete product');
    }
    existingproduct = null;
  }

  Future<void> fetchandsetproducts() async {
    final url = Uri.parse(
        'https://shop-app-1f3ec-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.get(url);

      final extracteddata = json.decode(response.body) as Map<String, dynamic>;
      if (extracteddata == null) {
        return;
      }
      final favststus = Uri.parse(
          'https://shop-app-1f3ec-default-rtdb.firebaseio.com/userfav/$userId.json?auth=$authToken');
      final favodata = await http.get(favststus);
      final favo = json.decode(favodata.body);
      List<Product> loadedproduct = [];
      extracteddata.forEach((prodid, prodata) {
        loadedproduct.add(Product(
            imageUrl: prodata['imageurl'],
            description: prodata['description'],
            id: prodid,
            isFavorite: favo == null ? false : favo[prodid] ?? false,
            price: prodata['price'],
            title: prodata['title']));
      });
      _items = loadedproduct;
      notifyListeners();
      //print(json.decode(response.body));
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addproduct(Product product) async {
    //here Uri requires <your domain> section only name of your domain which means https:// in starting
    //are not required and / in the end is also not required
    //and  uncodedpath is thefolder in whcih your want to store the data
    final url = Uri.parse(
        'https://shop-app-1f3ec-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    //here we put products in the end
    //because we wanrt to create a folder with that name and dave the products in

//here we cannot use product directly so we convert it using json.encode
//which requires dart:convert
////// returns a future object the future object(response) is a unique cryptic key which firebase generates for us
    ///       |
    ///       V
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageurl': product.imageUrl,
          'price': product.price,
        }),
      );
      final newpro = Product(
          description: product.description,
          // id: DateTime.now().toString(),
          //HERE WE REPLACE THE ID WITH THE RESPONSE PROVIDED BY FIREBASE,it will help if we want to delete or up
          //update some produts ,because the firebase only knows its own IDS
          id: json.decode(response.body)['name'],
          imageUrl: product.imageUrl,
          price: product.price,
          title: product.title);
      _items.add(newpro);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }

    //_items.insert(0, newpro)

    //here then runs only after post have returned a future after its completion,
    //if the code would have been outside of then then it would have immediatly ran after the post was exceuted
    //it would not have waited for post returning a future
  }

  Future<void> updateproduct(String id, Product newProduct) async {
    final prodindx = _items.indexWhere((element) => element.id == id);
    if (prodindx >= 0) {
      final url = Uri.parse(
          'https://shop-app-1f3ec-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      //patch will merge the exiasting data with the new data
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'description': newProduct.description,
            'imageurl': newProduct.imageUrl,
          }));
      _items[prodindx] = newProduct;
      notifyListeners();
    } else {
      print('no prodcut ');
    }
  }
}
