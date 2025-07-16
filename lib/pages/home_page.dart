// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:weather_app/screens/hourly_screen.dart';
import 'package:weather_app/screens/weekly_screen.dart';
import 'package:weather_app/theme/color_styles.dart';
import 'package:weather_app/theme/text_styles.dart';
import 'package:weather_app/theme/weather_color_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset('assets/images/background-home.png', fit: BoxFit.cover),

            // Weather information
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Montreal', style: TextStyles.title1),
                  Text('19°', style: TextStyles.largeTitle),
                  Text(
                    'Mostly Clear',
                    style: TextStyles.caption1.copyWith(
                      color: WeatherColorStyles.textWeatherCondition,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('H: 24°', style: TextStyles.caption2),
                      SizedBox(width: 12),
                      Text('L: 18°', style: TextStyles.caption2),
                    ],
                  ),
                ],
              ),
            ),

            // Container for the bottom
            Positioned(
              top: 480,
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(56),
                  topRight: Radius.circular(56),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: WeatherColorStyles.container.withOpacity(0.9),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // TabBar
                        Container(
                          color: WeatherColorStyles.container.withOpacity(0.1),
                          child: TabBar(
                            indicatorColor: WeatherColorStyles.quanternary
                                .withOpacity(0.3),
                            labelColor: ColorStyles.primary,
                            unselectedLabelColor: Colors.white70,
                            dividerColor: WeatherColorStyles.quanternary
                                .withOpacity(0.2),
                            tabs: [
                              Tab(text: 'Hourly Forecast'),
                              Tab(text: 'Weekly Forecast'),
                            ],
                          ),
                        ),

                        // TabBarView
                        SizedBox(
                          height: 300,
                          child: TabBarView(
                            children: [
                              // Tab 1
                              HourlyScreen(),
                              // Tab 2
                              WeeklyScreen(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              top: 785,
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(56),
                  topRight: Radius.circular(56),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.location_searching_rounded,
                          color: ColorStyles.primary,
                          size: 32,
                        ),
                        onPressed: () {
                          // Handle search button press
                        },
                      ),

                      IconButton(
                        icon: Icon(
                          Icons.add_circle_outline_rounded,
                          color: ColorStyles.primary,
                          size: 48,
                        ),
                        onPressed: () {
                          // Handle menu button press
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.list_rounded,
                          color: ColorStyles.primary,
                          size: 32,
                        ),
                        onPressed: () {
                          // Handle menu button press
                        },
                      ),
                    ],
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
