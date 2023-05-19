class ProductItem {
  final String image;
  final int quantity;
  final String name;
  final String pricePerItem;
  final bool isInStock;
  final String productId;

  ProductItem({
    required this.productId,
    required this.image,
    required this.name,
    required this.pricePerItem,
    required this.isInStock,
    this.quantity = 0,
  });
}
