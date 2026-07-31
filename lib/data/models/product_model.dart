class ProductModel {
  final String id;
  final String image;
  final String name;
  final double price;
  final String descrp;
  final String category;
  final String collection;
  final List<String> keywords;

  const ProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.descrp,
    this.category = '',
    this.collection = '',
    this.keywords = const [],
  });

  static List<ProductModel> products = [
    const ProductModel(
      id: 'p1',
      name: "Boots",
      image: 'assets/product/product1.png',
      price: 50,
      descrp: 'reversible angora cardigan',
      category: 'Shoes',
      collection: 'Black collection',
      keywords: ['footwear', 'leather', 'winter', 'ankle'],
    ),
    const ProductModel(
      id: 'p2',
      name: "Earrings",
      image: 'assets/product/product2.png',
      price: 100,
      descrp: 'reversible angora cardigan',
      category: 'Accessories',
      collection: 'HAE BY HAEKIM',
      keywords: ['jewelry', 'gold', 'silver', 'accessory'],
    ),
    const ProductModel(
      id: 'p3',
      name: "stalesteel\nring",
      image: 'assets/product/product3.png',
      price: 40,
      descrp: 'reversible angora cardigan',
      category: 'Accessories',
      collection: 'HAE BY HAEKIM',
      keywords: ['jewelry', 'ring', 'steel', 'accessory'],
    ),
    const ProductModel(
      id: 'p4',
      name: "Gold-plated\nring",
      image: 'assets/product/product4.png',
      price: 100,
      descrp: 'reversible angora cardigan',
      category: 'Accessories',
      collection: 'HAE BY HAEKIM',
      keywords: ['jewelry', 'ring', 'gold', 'accessory'],
    ),
    const ProductModel(
      id: 'p5',
      name: "Gold-plated\nring",
      image: 'assets/product/product5.png',
      price: 80,
      descrp: 'reversible angora cardigan',
      category: 'Accessories',
      collection: 'White collection',
      keywords: ['jewelry', 'ring', 'gold', 'accessory'],
    ),
    const ProductModel(
      id: 'p6',
      name: "Dress",
      image: 'assets/product/product6.png',
      price: 120,
      descrp: 'reversible angora cardigan',
      category: 'Women',
      collection: 'White collection',
      keywords: ['fashion', 'formal', 'party', 'women'],
    ),
  ];

  static List<ProductModel> allProducts() => products;
}
