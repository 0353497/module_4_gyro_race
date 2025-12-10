import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:module_4/pages/gamepage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String selectedCar = "red";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Pick your car",
              style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: Get.height / 2,
              child: GridView.count(
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                crossAxisCount: 2,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedCar = "red";
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffD9D9D9),
                          borderRadius: BorderRadius.circular(16),
                          border: selectedCar == "red"
                              ? Border.all(color: Color(0xff76b92c), width: 5)
                              : null,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 24,
                            right: 24,
                            bottom: 24,
                          ),
                          child: Transform.rotate(
                            angle: pi,
                            child: Image.asset(
                              "assets/images/red-car.png",
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedCar = "blue";
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffD9D9D9),
                          borderRadius: BorderRadius.circular(16),
                          border: selectedCar == "blue"
                              ? Border.all(color: Color(0xff76b92c), width: 5)
                              : null,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 24,
                            right: 24,
                            bottom: 24,
                          ),
                          child: Transform.rotate(
                            angle: pi,
                            child: Image.asset(
                              "assets/images/blue-car.png",
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedCar = "pink";
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffD9D9D9),
                          borderRadius: BorderRadius.circular(16),
                          border: selectedCar == "pink"
                              ? Border.all(color: Color(0xff76b92c), width: 5)
                              : null,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 24,
                            right: 24,
                            bottom: 24,
                          ),
                          child: Transform.rotate(
                            angle: pi,
                            child: Image.asset(
                              "assets/images/pink-car.png",
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedCar = "yellow";
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffD9D9D9),
                          borderRadius: BorderRadius.circular(16),
                          border: selectedCar == "yellow"
                              ? Border.all(color: Color(0xff76b92c), width: 5)
                              : null,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 24,
                            right: 24,
                            bottom: 24,
                          ),
                          child: Transform.rotate(
                            angle: pi,
                            child: Image.asset(
                              "assets/images/yellow-car.png",
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: Get.width - 50,
              height: 70,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Color(0xff76b92c)),
                ),
                onPressed: () {
                  Get.to(() => Gamepage(car: selectedCar));
                },
                child: Text(
                  "Start race",
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
