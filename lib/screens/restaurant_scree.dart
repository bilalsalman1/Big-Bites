import 'package:bigs_bites/models/product_tile.dart';
import 'package:bigs_bites/screens/productdetail_screen.dart';
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
      titles: data['titles'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
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

class RestaurantScreen extends StatefulWidget {
  final String restaurantId;
  const RestaurantScreen({super.key, required this.restaurantId});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  List<bool> isSelected = [true, false];

  Stream<List<Product>> getProductsFromFirestore() {
    print('Fetching products for restaurant: ${widget.restaurantId}');
    return FirebaseFirestore.instance
        .collection(widget.restaurantId)
        .snapshots()
        .map((QuerySnapshot query) {
      print('Number of documents fetched: ${query.docs.length}');
      return query.docs.map((doc) {
        print('Document ID: ${doc.id}');
        return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bj.jpg'), // Background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            // Make everything else scrollable
            child: Column(
              children: [
                SizedBox(
                  height: 440,
                  child: Stack(
                    children: [
                      const SizedBox(
                        width: double.infinity,
                        child: Image(
                          image: AssetImage('assets/images/Image.png'),
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
                        top: 280,
                        left: 15,
                        right: 15,
                        child: Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                            color: ColorStyles.deepPurple.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 05),
                              ListTile(
                                leading: Card(
                                  elevation: 2,
                                  child: Container(
                                    height: 30,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Icon(Icons.star),
                                  ),
                                ),
                                title: dynamicTitleText(
                                  text: widget.restaurantId,
                                  fontSize: 22,
                                  color: ColorStyles.white,
                                ),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    dynamicTitleText(
                                      text: 'Restaurant Address',
                                      fontSize: 15,
                                      color: ColorStyles.white,
                                    ),
                                    const Icon(Icons.arrow_forward_ios),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10),
                                child: Divider(),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  dynamicTitleText(
                                    text: 'Delivery Fee',
                                    fontSize: 13,
                                    color: ColorStyles.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  dynamicTitleText(
                                    text: '\$2.99',
                                    fontSize: 15,
                                    color: ColorStyles.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Container(
                          height: 44,
                          width: 165,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey,
                              width: 2,
                            ),
                          ),
                          child: ToggleButtons(
                            borderWidth: 0,
                            borderRadius: BorderRadius.circular(12),
                            fillColor: Colors.transparent,
                            selectedBorderColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            renderBorder: false,
                            isSelected: isSelected,
                            onPressed: (int index) {
                              setState(() {
                                for (int i = 0; i < isSelected.length; i++) {
                                  isSelected[i] = i == index;
                                }
                              });
                            },
                            children: [
                              Container(
                                width: 80,
                                height: 44,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(12),
                                  ),
                                  gradient: isSelected[0]
                                      ? const LinearGradient(
                                          colors: [
                                            Color(0xff3B72FF),
                                            Color(0xff262A34),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        )
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: dynamicTitleText(
                                  text: 'Delivery',
                                  fontSize: 14,
                                  color: isSelected[0]
                                      ? ColorStyles.white
                                      : ColorStyles.grey,
                                ),
                              ),
                              Container(
                                width: 80,
                                height: 44,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.horizontal(
                                    right: Radius.circular(12),
                                  ),
                                  gradient: isSelected[1]
                                      ? const LinearGradient(
                                          colors: [
                                            Color(0xff3B72FF),
                                            Color(0xff262A34),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        )
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: dynamicTitleText(
                                  text: 'Take Out',
                                  fontSize: 14,
                                  color: isSelected[1]
                                      ? ColorStyles.white
                                      : ColorStyles.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0x80000000),
                          ),
                          onPressed: () {},
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_add_alt_1,
                                color: ColorStyles.white,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              dynamicTitleText(
                                  text: 'Group Add',
                                  color: ColorStyles.white,
                                  fontSize: 15),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: ColorStyles.white,
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () {},
                        child: dynamicTitleText(
                          text: 'Featured Items',
                          fontSize: 15,
                          color: ColorStyles.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () {},
                        child: dynamicTitleText(
                          text: 'Appetizers',
                          fontSize: 15,
                          color: ColorStyles.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () {},
                        child: dynamicTitleText(
                          text: 'Sushi',
                          fontSize: 15,
                          color: ColorStyles.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      dynamicTitleText(
                        text: 'Featured Items',
                        fontSize: 15,
                        color: ColorStyles.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                StreamBuilder<List<Product>>(
                  stream: getProductsFromFirestore(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No products available.',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    final products = snapshot.data!;

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductTile(
                          titles: product.titles,
                          description: product.description,
                          price: product.price.toStringAsFixed(2),
                          image: NetworkImage(product.imageUrl),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductdetailScreen(
                                  productId: product.id,
                                  restaurantName: widget.restaurantId,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
