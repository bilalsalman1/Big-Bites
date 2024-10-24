// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:bigs_bites/Screens/bottomnavigation.dart';
import 'package:bigs_bites/models/cart_tile.dart';
import 'package:bigs_bites/screens/checkout_screen.dart';
import 'package:bigs_bites/style/button_styles.dart';
import 'package:bigs_bites/style/color_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    try {
      final cartSnapshot =
          await FirebaseFirestore.instance.collection('cart').get();
      setState(() {
        cartItems = cartSnapshot.docs
            .map((doc) => {
                  ...doc.data(),
                  'docId': doc.id,
                })
            .toList();
        print('abc');
      });
    } catch (e) {
      print('Error fetching cart items: $e');
    }
  }

  Future<void> removeItemFromCart(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('cart').doc(docId).delete();
      setState(
        () {
          cartItems.removeWhere((item) => item['docId'] == docId);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Item removed from cart'),
            ),
          );
        },
      );
    } catch (e) {
      print('Error removing item from cart: $e');
    }
  }

  Future<void> updateItemQuantityInFirestore(
      String docId, int newQuantity) async {
    try {
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(docId)
          .update({'quantity': newQuantity});
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  Future<void> onCheckout() async {
    try {
      if (cartItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cart is empty! Add some items first.'),
          ),
        );
        return;
      }

      double totalBill = calculateSubtotal() + 2.00;

      String orderNumber = DateTime.now().millisecondsSinceEpoch.toString();

      await FirebaseFirestore.instance.collection('orders').add({
        'orderNumber': orderNumber,
        'products': cartItems,
        'totalBill': totalBill,
        'timestamp': FieldValue.serverTimestamp(),
      });

      for (var item in cartItems) {
        await FirebaseFirestore.instance
            .collection('cart')
            .doc(item['docId'])
            .delete();
      }

      setState(() {
        cartItems.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully!'),
        ),
      );
    } catch (e) {
      print('Error during checkout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Checkout failed, please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorStyles.deepPurple,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BottomNavigation()));
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: ColorStyles.white,
            )),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bj.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Order Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return CartTile(
                        image: Image.network(item['imageUrl']),
                        price: item['price'].toString(),
                        titles: item['titles'],
                        quantity: item['quantity'],
                        description: item['description'],
                        onRemove: () => removeItemFromCart(item['docId']),
                        onQuantityChanged: (newQuantity) {
                          setState(() {
                            cartItems[index]['quantity'] = newQuantity;
                          });
                          updateItemQuantityInFirestore(
                              item['docId'], newQuantity);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: ColorStyles.deepPurple,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Subtotal',
                          style: TextStyle(
                              color: ColorStyles.white, fontSize: 16)),
                      const SizedBox(height: 10),
                      Text('Delivery',
                          style: TextStyle(
                              color: ColorStyles.white, fontSize: 16)),
                      const SizedBox(height: 10),
                      Text('Total',
                          style: TextStyle(
                              color: ColorStyles.white, fontSize: 16)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('\$${calculateSubtotal().toStringAsFixed(2)}',
                          style: TextStyle(
                              color: ColorStyles.white, fontSize: 16)),
                      const SizedBox(height: 10),
                      Text('\$2.00',
                          style: TextStyle(
                              color: ColorStyles.white, fontSize: 16)),
                      const SizedBox(height: 10),
                      Text(
                          '\$${(calculateSubtotal() + 2.00).toStringAsFixed(2)}',
                          style: TextStyle(
                              color: ColorStyles.white, fontSize: 16)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Center(
                child: ButtonStyles(
                    onPressed: () {
                      onCheckout();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const OrderConfirmationScreen()));
                    },
                    text: 'Check Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double calculateSubtotal() {
    double subtotal = 0;
    for (var item in cartItems) {
      subtotal += item['price'] * item['quantity'];
    }
    return subtotal;
  }
}
