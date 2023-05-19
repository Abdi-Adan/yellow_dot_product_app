import 'package:flutter/material.dart';
import 'package:testingapp/product.dart';
import 'package:testingapp/product_list_store.dart';

void main() {
  runApp(const MyApp());
}

ProductListStore productState = ProductListStore();
GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Product List page'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  setState(() {});
                },
                child: const Icon(Icons.refresh),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: StreamBuilder<List<ProductItem>>(
            stream: productState.productList.stream,
            builder: (BuildContext ctx, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: Card(
                          child: ProductWidget(
                              product: productState.productList.value[index]),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                    child: Text('This is the product list page'));
              }
            },
          ),
        ),
      ),
    );
  }
}

class ProductWidget extends StatefulWidget {
  final ProductItem product;

  const ProductWidget({super.key, required this.product});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          ImageSide(
            prod: widget.product,
          ),
          DetailsSide(prodItem: widget.product)
        ],
      ),
    );
  }
}

class ImageSide extends StatefulWidget {
  final ProductItem prod;

  const ImageSide({super.key, required this.prod});

  @override
  State<ImageSide> createState() => _ImageSideState();
}

class _ImageSideState extends State<ImageSide> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Container(width: 100, height: 100, color: Colors.red),
          SizedBox(
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    incrementQuantity(widget.prod);
                  },
                  child: const Text('+'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${widget.prod.quantity}'),
                ),
                ElevatedButton(
                  onPressed: () {
                    decrementQuantity(widget.prod);
                  },
                  child: const Text('-'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsSide extends StatefulWidget {
  final ProductItem prodItem;

  const DetailsSide({super.key, required this.prodItem});

  @override
  State<DetailsSide> createState() => _DetailsSideState();
}

class _DetailsSideState extends State<DetailsSide> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.prodItem.name),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.prodItem.pricePerItem),
            ),
            Text(widget.prodItem.isInStock
                ? 'In stock'
                : 'The vendor is out of this item'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {}, child: const Text('Buy')),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        deleteProduct(widget.prodItem);
                      },
                      child: const Icon(Icons.delete),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void incrementQuantity(ProductItem currentItem) {
  var newQuantity = currentItem.quantity + 1;
  int currentIndex = productState.productList.value
      .indexWhere((e) => e.productId == currentItem.productId);
  productState.productList.value
      .removeWhere((e) => e.productId == currentItem.productId);
  var newProduct = ProductItem(
    image: currentItem.image,
    isInStock: currentItem.isInStock,
    name: currentItem.name,
    pricePerItem: currentItem.pricePerItem,
    quantity: newQuantity,
    productId: currentItem.productId,
  );
  productState.productList.value.insert(currentIndex, newProduct);
}

void decrementQuantity(ProductItem currentItem) {
  var newQuantity = (currentItem.quantity != 1)
      ? (currentItem.quantity - 1)
      : (currentItem.quantity);
  int currentIndex = productState.productList.value
      .indexWhere((e) => e.productId == currentItem.productId);
  productState.productList.value
      .removeWhere((e) => e.productId == currentItem.productId);
  var newProduct = ProductItem(
    image: currentItem.image,
    isInStock: currentItem.isInStock,
    name: currentItem.name,
    pricePerItem: currentItem.pricePerItem,
    quantity: newQuantity,
    productId: currentItem.productId,
  );
  productState.productList.value.insert(currentIndex, newProduct);
}

void deleteProduct(ProductItem currentItem) {
  var listOfProducts = productState.productList.value;
  listOfProducts.removeWhere((e) => e.productId == currentItem.productId);
}
