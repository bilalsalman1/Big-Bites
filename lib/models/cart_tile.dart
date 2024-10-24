import 'package:bigs_bites/style/color_styles.dart';
import 'package:bigs_bites/style/text_style.dart';
import 'package:flutter/material.dart';

class CartTile extends StatefulWidget {
  final Image image;
  final String price;
  final Function(int newQuantity) onQuantityChanged;
  final int quantity;
  final String titles;
  final String description;
  final VoidCallback onRemove;

  const CartTile({
    super.key,
    required this.image,
    required this.price,
    required this.titles,
    required this.description,
    required this.onRemove,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  State<CartTile> createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.quantity;
  }

  void updateQuantity(int newQuantity) {
    setState(() {
      quantity = newQuantity;
    });
    widget.onQuantityChanged(newQuantity);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 120,
              width: 120,
              child: FittedBox(
                fit: BoxFit.cover,
                child: widget.image,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.titles,
                  style: TextStyle(
                    color: ColorStyles.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.description,
                  style: TextStyle(
                    color: ColorStyles.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '\$${(double.parse(widget.price) * quantity).toStringAsFixed(2)}', // Update based on current quantity
                  style: TextStyle(
                    color: ColorStyles.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: ColorStyles.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (quantity > 1) {
                                updateQuantity(quantity - 1);
                              }
                            },
                            icon: Icon(Icons.remove, color: ColorStyles.grey),
                            iconSize: 18,
                          ),
                          dynamicTitleText(
                            text: '$quantity',
                            color: Colors.black,
                          ),
                          IconButton(
                            onPressed: () {
                              updateQuantity(quantity + 1);
                            },
                            icon: Icon(Icons.add, color: ColorStyles.grey),
                            iconSize: 18,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: widget.onRemove,
                      icon: Icon(Icons.delete, color: ColorStyles.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
