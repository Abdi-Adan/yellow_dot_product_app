import 'package:rxdart/subjects.dart';
import 'package:testingapp/fixtures.dart';
import 'package:testingapp/product.dart';

class ProductListStore {
  factory ProductListStore() {
    return _singleton;
  }

  ProductListStore._internal();

  final productList = BehaviorSubject<List<ProductItem>>.seeded([product1, product2, product3]);

  static final ProductListStore _singleton = ProductListStore._internal();
}