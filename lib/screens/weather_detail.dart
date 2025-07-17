// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/screens/hourly_screen.dart';
import 'package:weather_app/screens/weekly_screen.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/theme/color_styles.dart';
import 'package:weather_app/theme/text_styles.dart';
import 'package:weather_app/theme/weather_color_styles.dart';

class WeatherDetail extends StatefulWidget {
  final String city;
  const WeatherDetail({super.key, required this.city});

  @override
  State<WeatherDetail> createState() => _WeatherDetailState();
}

class _WeatherDetailState extends State<WeatherDetail> {
  String selectedCity = 'London';
  Map<String, dynamic>? currentWeather;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedCity = widget.city;
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    try {
      setState(() {
        isLoading = true;
      });

      final data = await WeatherAPI.getCurrentWeather(selectedCity);

      setState(() {
        currentWeather = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching weather data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
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

  String formatTime(String utcTime) {
    final dateTime = DateTime.parse(utcTime).toLocal();
    return DateFormat.jm().format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: WeatherColorStyles.linear2.withOpacity(0.7),
        body:
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
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    Text(widget.city, style: TextStyles.title1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${currentWeather!['temperature'].floor()}°',
                          style: TextStyles.caption1.copyWith(
                            color: WeatherColorStyles.textWeatherCondition,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 2.5,
                          height: 20,
                          color: WeatherColorStyles.textWeatherCondition,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          capitalizeEachWord(
                            currentWeather!['description'] ?? '',
                          ),
                          style: TextStyles.caption1.copyWith(
                            color: WeatherColorStyles.textWeatherCondition,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: WeatherColorStyles.container.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: [
                            Container(
                              color: WeatherColorStyles.container.withOpacity(
                                0.1,
                              ),
                              child: TabBar(
                                indicatorColor: WeatherColorStyles.quanternary
                                    .withOpacity(0.3),
                                labelColor: ColorStyles.text,
                                unselectedLabelColor: ColorStyles.text,
                                dividerColor: WeatherColorStyles.quanternary
                                    .withOpacity(0.2),
                                tabs: const [
                                  Tab(text: 'Hourly Forecast'),
                                  Tab(text: 'Weekly Forecast'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: TabBarView(
                                key: ValueKey(widget.city),
                                children: [
                                  HourlyScreen(city: selectedCity),
                                  WeeklyScreen(city: selectedCity),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Weather detail section scrollable
                    const SizedBox(height: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: buildWeatherDetailItem(
                                      SvgPicture.asset(
                                        'assets/icons/sunrise.svg',
                                        color:
                                            WeatherColorStyles
                                                .textWeatherCondition,
                                        width: 18,
                                        height: 18,
                                      ),
                                      'SUNRISE',
                                      formatTime(currentWeather!['sunrise']),
                                      'Sunset: ${formatTime(currentWeather!['sunset'])}',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: buildWeatherDetailItem(
                                      SvgPicture.asset(
                                        'assets/icons/wind.svg',
                                        color:
                                            WeatherColorStyles
                                                .textWeatherCondition,
                                        width: 18,
                                        height: 18,
                                      ),
                                      'WIND',
                                      '${currentWeather!['wind_speed']}\nkm/h',
                                      '',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              Row(
                                children: [
                                  Expanded(
                                    child: buildWeatherDetailItem(
                                      SvgPicture.asset(
                                        'assets/icons/rainfall.svg',
                                        color:
                                            WeatherColorStyles
                                                .textWeatherCondition,
                                        width: 18,
                                        height: 18,
                                      ),
                                      'RAINFALL',
                                      (currentWeather!['rain'] ?? 0) > 0
                                          ? '${currentWeather!['rain']} mm in last hour'
                                          : 'No data available',
                                      '',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: buildWeatherDetailItem(
                                      SvgPicture.asset(
                                        'assets/icons/feels-like.svg',
                                        color:
                                            WeatherColorStyles
                                                .textWeatherCondition,
                                        width: 18,
                                        height: 18,
                                      ),
                                      'FEELS LIKE',
                                      '${currentWeather!['feels_like']}°',
                                      'Similar to actual temperature.',
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              Row(
                                children: [
                                  Expanded(
                                    child: buildWeatherDetailItem(
                                      SvgPicture.asset(
                                        'assets/icons/humidity.svg',
                                        color:
                                            WeatherColorStyles
                                                .textWeatherCondition,
                                        width: 18,
                                        height: 18,
                                      ),
                                      'HUMIDITY',
                                      '${currentWeather!['humidity']}%',
                                      '',
                                    ),
                                  ),

                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: buildPressureItem(
                                      currentWeather!['pressure'],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
      ),
    );
  }
}

Widget buildWeatherDetailItem(
  SvgPicture icon,
  String title,
  String value,
  String subValue,
) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(24),
    child: Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      color: ColorStyles.container.withOpacity(0.6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  icon,
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyles.title2.copyWith(
                      color: WeatherColorStyles.textWeatherCondition,
                    ),
                  ),
                ],
              ),
              Text(value, style: TextStyles.callOut),
            ],
          ),
          const SizedBox(height: 4),
          subValue.isNotEmpty
              ? Text(subValue, style: TextStyles.caption2)
              : SizedBox.shrink(),
        ],
      ),
    ),
  );
}

Widget buildPressureItem(num pressure) {
  String formatPressurePercent(num pressure) {
    final percent = ((pressure - 950) / (1050 - 950)).clamp(0, 1);
    return (percent * 100).toStringAsFixed(0);
  }

  final percent = double.parse(formatPressurePercent(pressure)) / 100;

  return SizedBox(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        color: ColorStyles.container.withOpacity(0.6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/pressure.svg',
                  color: WeatherColorStyles.textWeatherCondition,
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 8),
                Text('PRESSURE', style: TextStyles.title2),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      value: percent,
                      strokeWidth: 6,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        WeatherColorStyles.textWeatherCondition,
                      ),
                    ),
                  ),
                  Text('${pressure.toInt()} hPa', style: TextStyles.footNote),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
