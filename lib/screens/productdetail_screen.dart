import 'package:bigs_bites/style/button_styles.dart';
import 'package:bigs_bites/style/color_styles.dart';
import 'package:bigs_bites/style/text_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Product {
  String id;
  String titles;
  String description;
  String imageUrl;
  double price;

  Product({
    required this.id,
    required this.titles,
    required this.description,
    required this.imageUrl,
    required this.price,
  });

  factory Product.fromMap(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      titles: data['titles'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      price: (data['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titles': titles,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
    };
  }
}

class ProductdetailScreen extends StatefulWidget {
  final String productId;
  final String restaurantName;
  const ProductdetailScreen(
      {super.key, required this.productId, required this.restaurantName});

  @override
  State<ProductdetailScreen> createState() => _ProductdetailScreenState();
}

class _ProductdetailScreenState extends State<ProductdetailScreen> {
  int quantity = 1;
  double totalPrice = 0.0;
  late Future<Product> productFuture;
  @override
  void initState() {
    super.initState();
    productFuture = getProductDetails();
  }

  Future<Product> getProductDetails() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection(widget.restaurantName)
        .doc(widget.productId)
        .get();
    Product product =
        Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);

    setState(() {
      totalPrice = product.price * quantity;
    });

    return product;
  }

  Future<void> _addToCart(Product product) async {
    try {
      final cartRef = FirebaseFirestore.instance.collection('cart');

      await cartRef.add({
        'titles': product.titles,
        'price': product.price,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'quantity': quantity,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product.titles} added to cart!')),
      );
      print(product);
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bj.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<Product>(
          future: productFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData) {
              return const Center(
                  child: Text(
                'No product found',
                style: TextStyle(color: Colors.white),
              ));
            }

            Product product = snapshot.data!;

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 650,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Image(
                          image: NetworkImage(product.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        left: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Card(
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back_ios),
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Card(
                                  color: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.favorite),
                                    color: Colors.white,
                                  ),
                                ),
                                Card(
                                  color: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.abc),
                                    iconSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 220,
                        left: 20,
                        right: 20,
                        child: Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width * 1,
                          decoration: BoxDecoration(
                            color: ColorStyles.deepPurple.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 25, right: 25),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 05,
                                ),
                                dynamicTitleText(
                                  text: product.titles,
                                  fontSize: 20,
                                  color: ColorStyles.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                dynamicTitleText(
                                  text: '\$${product.price}',
                                  fontSize: 20,
                                  color: ColorStyles.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                dynamicTitleText(
                                  text: product.description,
                                  fontSize: 17,
                                  color: const Color(0x99FFFFFF),
                                  fontWeight: FontWeight.w400,
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: ColorStyles.deepPurple),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              if (quantity > 1) {
                                                setState(() {
                                                  quantity--;
                                                  totalPrice =
                                                      product.price * quantity;
                                                });
                                              }
                                            },
                                            icon: Icon(
                                              Icons.remove,
                                              color: ColorStyles.grey,
                                            ),
                                          ),
                                          Text(
                                            '$quantity',
                                            style: TextStyle(
                                                color: ColorStyles.white),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                quantity++;
                                                totalPrice =
                                                    product.price * quantity;
                                              });
                                            },
                                            icon: Icon(
                                              Icons.add,
                                              color: ColorStyles.white,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                ButtonStyles(
                    onPressed: () async {
                      await _addToCart(product);
                    },
                    text: 'Add To Basket')
              ],
            );
          },
        ),
      ),
    );
  }
}
