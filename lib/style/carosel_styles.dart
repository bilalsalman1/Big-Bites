import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CaroselStyles extends StatefulWidget {
  const CaroselStyles({super.key});

  @override
  State<CaroselStyles> createState() => _CaroselStylesState();
}

class _CaroselStylesState extends State<CaroselStyles> {
  final dicountBanner = [
    'assets/images/Card.png',
    'assets/images/Card.png',
    'assets/images/Card.png',
    'assets/images/Card.png',
  ];
  int currentindex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
            itemCount: dicountBanner.length,
            itemBuilder: (context, index, realIndex) {
              final image = dicountBanner[index];
              return buildImage(image, index);
            },
            options: CarouselOptions(
              height: 193,
              autoPlay: true,
              enableInfiniteScroll: false,
              autoPlayInterval: const Duration(seconds: 2),
              enlargeCenterPage: true,
              enlargeStrategy: CenterPageEnlargeStrategy.height,
              onPageChanged: (index, reason) => setState(() {
                currentindex = index;
              }),
            )),
        const SizedBox(
          height: 20,
        ),
        buildindicator(),
      ],
    );
  }

  Widget buildImage(String image, int index) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          color: const Color(0xff1D102D),
        ),
        child: Image.asset(
          image,
          fit: BoxFit.cover,
        ),
      );
  Widget buildindicator() => AnimatedSmoothIndicator(
        activeIndex: currentindex,
        count: dicountBanner.length,
        effect: const JumpingDotEffect(
            dotHeight: 10,
            dotWidth: 10,
            dotColor: Colors.white,
            activeDotColor: Color(0xff0b1225)),
      );
}
