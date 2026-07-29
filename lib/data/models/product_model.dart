class ProductModel {
  final String image;
  final String name;
  final double price;
  final String descrp;
  ProductModel({
    required this.name,
    required this.image,
    required this.price,
    required this.descrp,
  });
  static List<ProductModel> products = [
    ProductModel(
      name: "Boots",
      image: 'assets/product/product1.png',
      price: 50,
      descrp: 'reversible angora cardigan',
    ),
    ProductModel(
      name: "Earrings",
      image: 'assets/product/product2.png',
      price: 100,
      descrp: 'reversible angora cardigan',
    ),
    ProductModel(
      name: "stalesteel\nring",
      image: 'assets/product/product3.png',
      price: 40,
      descrp: 'reversible angora cardigan',
    ),
    ProductModel(
      name: "Gold-plated\nring",
      image: 'assets/product/product4.png',
      price: 100,
      descrp: 'reversible angora cardigan',
    ),
    ProductModel(
      name: "Gold-plated\nring",
      image: 'assets/product/product5.png',
      price: 80,
      descrp: 'reversible angora cardigan',
    ),
    ProductModel(
      name: "Dress",
      image: 'assets/product/product6.png',
      price: 120,
      descrp: 'reversible angora cardigan',
    ),
  ];
}
