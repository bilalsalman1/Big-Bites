import 'package:bigs_bites/models/card.dart';
import 'package:bigs_bites/models/product_tile.dart';
import 'package:bigs_bites/screens/restaurant_scree.dart';
import 'package:bigs_bites/style/carosel_styles.dart';
import 'package:bigs_bites/style/color_styles.dart';
import 'package:bigs_bites/style/text_style.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({
    super.key,
  });
  final List<Categorycard> category = [
    const Categorycard(
        image: Image(
          image: AssetImage('assets/images/burger 1.png'),
          fit: BoxFit.cover,
        ),
        title: 'Burgers'),
    const Categorycard(
        image: Image(
          image: AssetImage('assets/images/cake 1.png'),
          fit: BoxFit.cover,
        ),
        title: 'Pastry'),
    const Categorycard(
        image: Image(
          image: AssetImage('assets/images/taco 1.png'),
          fit: BoxFit.cover,
        ),
        title: 'Mexican'),
    const Categorycard(
        image: Image(
          image: AssetImage('assets/images/Sushii.png'),
          fit: BoxFit.cover,
        ),
        title: 'Sushi'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const Drawer(),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/bj.jpg'),
                  fit: BoxFit.cover)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: const Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          child: dynamicTitleText(
                              text: 'Delivery \nMaplewoods Suites',
                              fontSize: 15,
                              color: ColorStyles.white),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 20, left: 80),
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/SegmentControl.png",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 10, left: 30, right: 30, bottom: 20),
                  width: double.infinity,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search Your Order",
                      hintStyle: const TextStyle(color: Colors.white),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      suffixIcon: const Icon(
                        Icons.qr_code,
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(width: 2, color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(width: 2, color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(width: 2, color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      dynamicTitleText(
                          text: 'Categories',
                          fontSize: 17,
                          color: ColorStyles.white),
                      dynamicTitleText(
                          text: 'See All',
                          fontSize: 12,
                          color: ColorStyles.white,
                          fontWeight: FontWeight.w400),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: category.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: category[index],
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                const CaroselStyles(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(15),
                        child: dynamicTitleText(
                            text: 'Fastest Near You',
                            fontSize: 17,
                            color: ColorStyles.white)),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const RestaurantScreen(restaurantId: 'SuperBurger'),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(15),
                    child: ImageContainer(
                      image: 'assets/images/burgers.png',
                      restaurantName: 'SuperBurger',
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const RestaurantScreen(restaurantId: 'PizzaSpice'),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(15),
                    child: ImageContainer(
                      image: 'assets/images/pizza.png',
                      restaurantName: 'PizzaSpice',
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const RestaurantScreen(restaurantId: 'CoffeeBar'),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(15),
                    child: ImageContainer(
                      image: 'assets/images/coffee.png',
                      restaurantName: 'CoffeeBar',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
