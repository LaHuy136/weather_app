// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/theme/color_styles.dart';
import 'package:weather_app/theme/text_styles.dart';
import 'package:weather_app/theme/weather_color_styles.dart';

class HourlyScreen extends StatefulWidget {
  final String city;
  const HourlyScreen({super.key, required this.city});

  @override
  State<HourlyScreen> createState() => _HourlyScreenState();
}

class _HourlyScreenState extends State<HourlyScreen> {
  List<dynamic> hourlyData = [];
  bool isLoading = true;
  int? nowIndex;

  @override
  void initState() {
    super.initState();
    fetchHourlyWeather();
  }

  Future<void> fetchHourlyWeather() async {
    try {
      final data = await WeatherAPI.getHourlyWeather(widget.city);

      final currentHour = DateTime.now().hour;
      int closestDiff = 24;
      int selectedIndex = 0;

      for (int i = 0; i < data.length; i++) {
        final hour = int.tryParse(data[i]['time'].split(':')[0]) ?? 0;
        final diff = (hour - currentHour).abs();
        if (diff < closestDiff) {
          closestDiff = diff;
          selectedIndex = i;
        }
      }

      setState(() {
        hourlyData = data;
        nowIndex = selectedIndex;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
    }
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
          hourlyData.isEmpty
              ? const Center(
                child: Text('No data available', style: TextStyles.caption1),
              )
              : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: hourlyData.length,
                itemBuilder: (context, index) {
                  final item = hourlyData[index];
                  final description = item['description'];

                  final isNow = index == nowIndex;

                  String getDisplayTime(String? rawTime) {
                    if (rawTime == null) return '--';

                    final hour = int.tryParse(rawTime.split(':')[0]) ?? 0;
                    final amPm = hour < 12 ? 'AM' : 'PM';
                    final displayHour =
                        hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
                    return '$displayHour $amPm';
                  }

                  final time = isNow ? 'Now' : getDisplayTime(item['time']);

                  final temp = item['temperature'].floor();
                  final humidity = item['humidity'].toString();

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
                          Text(time, style: TextStyles.caption2),
                          const SizedBox(height: 8),
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
                          const SizedBox(height: 8),
                          Text('$temp°C', style: TextStyles.caption2),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
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

    return 'assets/icons/cloud-fast-wind.svg';
  }
}
