// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:weather_app/screens/hourly_screen.dart';
import 'package:weather_app/screens/weather_detail.dart';
import 'package:weather_app/screens/weekly_screen.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/theme/color_styles.dart';
import 'package:weather_app/theme/text_styles.dart';
import 'package:weather_app/theme/weather_color_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCity = 'London';
  Map<String, dynamic>? currentWeather;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final data = await WeatherAPI.getCurrentWeather(selectedCity);

      setState(() {
        currentWeather = data;
      });
    } catch (e) {
      setState(() {
        currentWeather = null;
        errorMessage = 'No finding data for "$selectedCity"';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showCitySearchSheet() {
    String cityInput = selectedCity;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: ColorStyles.quanternary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) => cityInput = value,
                  style: TextStyle(
                    color: ColorStyles.primary,
                    decoration: TextDecoration.none,
                  ),
                  cursorColor: ColorStyles.primary,
                  decoration: InputDecoration(
                    labelText: 'Search for a city',
                    labelStyle: TextStyles.footNote.copyWith(
                      color: ColorStyles.primary,
                    ),
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: ColorStyles.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      setState(() {
                        selectedCity = cityInput;
                      });
                      await fetchWeather();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorStyles.tertiary,
                    ),
                    child: Text(
                      'Search',
                      style: TextStyles.caption2.copyWith(
                        color: ColorStyles.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String capitalizeEachWord(String input) {
    return input
        .split(' ')
        .map(
          (word) =>
              word.isEmpty ? word : word[0].toUpperCase() + word.substring(1),
        )
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/background-home.png', fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child:
                  isLoading
                      ? const Center(
                        child: SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: ColorStyles.primary,
                          ),
                        ),
                      )
                      : errorMessage != null
                      ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          errorMessage!,
                          style: TextStyle(color: Colors.red, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      )
                      : Column(
                        children: [
                          Text(
                            capitalizeEachWord(selectedCity),
                            style: TextStyles.title1,
                          ),
                          Text(
                            '${currentWeather!['temperature'].floor()}°',
                            style: TextStyles.largeTitle,
                          ),
                          Text(
                            capitalizeEachWord(
                              currentWeather!['description'] ?? '',
                            ),
                            style: TextStyles.caption1.copyWith(
                              color: WeatherColorStyles.textWeatherCondition,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'H: ${currentWeather!['temp_max'].floor()}°',
                                style: TextStyles.caption2,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'L: ${currentWeather!['temp_min'].floor()}°',
                                style: TextStyles.caption2,
                              ),
                            ],
                          ),
                        ],
                      ),
            ),

            // Bottom sheet with tabs for hourly and weekly forecasts
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
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        WeatherColorStyles.linear1.withOpacity(0.9),
                        WeatherColorStyles.linear11.withOpacity(0.9),
                      ],
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                WeatherColorStyles.linear1.withOpacity(0.1),
                                WeatherColorStyles.linear11.withOpacity(0.2),
                              ],
                            ),
                          ),
                          child: TabBar(
                            indicatorColor: WeatherColorStyles.linear4
                                .withOpacity(0.8),
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorWeight: 2.5,
                            labelColor: ColorStyles.text,
                            unselectedLabelColor: ColorStyles.text,
                            dividerColor: WeatherColorStyles.linear4
                                .withOpacity(0.1),
                            labelStyle: TextStyle(
                              color: ColorStyles.text,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                            tabs: const [
                              Tab(text: 'Hourly Forecast'),
                              Tab(text: 'Weekly Forecast'),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 300,
                          child: TabBarView(
                            key: ValueKey(selectedCity),
                            children: [
                              HourlyScreen(
                                key: ValueKey(selectedCity),
                                city: selectedCity,
                              ),
                              WeeklyScreen(
                                key: ValueKey(selectedCity),
                                city: selectedCity,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom navigation bar
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
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.location_searching_rounded,
                          color: ColorStyles.primary,
                          size: 32,
                        ),
                        onPressed: showCitySearchSheet,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add_circle_outline_rounded,
                          color: ColorStyles.primary,
                          size: 48,
                        ),
                        onPressed:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        WeatherDetail(city: selectedCity),
                              ),
                            ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.list_rounded,
                          color: ColorStyles.primary,
                          size: 32,
                        ),
                        onPressed: () {},
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
