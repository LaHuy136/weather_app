// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/theme/color_styles.dart';
import 'package:weather_app/theme/text_styles.dart';
import 'package:weather_app/theme/weather_color_styles.dart';

class WeeklyScreen extends StatefulWidget {
  final String city;
  const WeeklyScreen({super.key, required this.city});

  @override
  State<WeeklyScreen> createState() => _WeeklyScreenState();
}

class _WeeklyScreenState extends State<WeeklyScreen> {
  List<dynamic> weeklyData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWeeklyWeather();
  }

  Future<void> fetchWeeklyWeather() async {
    try {
      final data = await WeatherAPI.getDailyWeather(widget.city);
      setState(() {
        weeklyData = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  bool isToday(String dateString) {
    final now = DateTime.now();
    final date = DateTime.tryParse(dateString);
    if (date == null) return false;

    return now.year == date.year &&
        now.month == date.month &&
        now.day == date.day;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: SizedBox(
          width: 25,
          height: 25,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: ColorStyles.primary,
          ),
        ),
      );
    }

    return SizedBox(
      height: 80,
      child:
          weeklyData.isEmpty
              ? const Center(
                child: Text('No data available', style: TextStyles.caption1),
              )
              : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: weeklyData.length,
                itemBuilder: (context, index) {
                  final item = weeklyData[index];

                  final dateStr = item['date'];
                  final isNow = isToday(dateStr);

                  final day = isNow ? 'Now' : getShortWeekday(item['weekday']);
                  final temp = item['temperature'].floor();
                  final humidity = item['humidity'];
                  final description = item['description'];

                  return SizedBox(
                    width: 100,
                    height: 80,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(
                        right: 12,
                        bottom: 45,
                        top: 28,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isNow
                                ? WeatherColorStyles.focusedContainer
                                    .withOpacity(0.9)
                                : WeatherColorStyles.container,
                        borderRadius: BorderRadius.circular(56),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Weekday
                          Text(day, style: TextStyles.body),

                          // Weather icon
                          Column(
                            children: [
                              SvgPicture.asset(
                                getWeatherIconPath(description),
                                width: 32,
                                height: 32,
                                color: ColorStyles.primary,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$humidity%',
                                style: TextStyles.body.copyWith(
                                  color:
                                      WeatherColorStyles.textWeatherCondition,
                                ),
                              ),
                            ],
                          ),

                          // Temperature
                          Text('$temp°C', style: TextStyles.caption2),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }

  String getShortWeekday(String weekday) {
    return weekday.substring(0, 3).toUpperCase();
  }

  String getWeatherIconPath(String description) {
    description = description.toLowerCase().trim();

    if (description.contains('clear')) {
      return 'assets/icons/clear-cloud.svg';
    } else if (description.contains('few clouds')) {
      return 'assets/icons/few-clouds.svg';
    } else if (description.contains('scattered clouds') ||
        description.contains('broken clouds')) {
      return 'assets/icons/broken-cloud.svg';
    } else if (description.contains('clouds')) {
      return 'assets/icons/clouds.svg';
    } else if (description.contains('light rain') ||
        description.contains('moderate rain')) {
      return 'assets/icons/light-rain.svg';
    } else if (description.contains('rain')) {
      return 'assets/icons/rainy.svg';
    }
    return 'assets/icons/moon-cloud-mid-rain.svg';
  }
}
