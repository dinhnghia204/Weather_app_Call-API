import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/models/constants.dart';
import 'package:weather_app/screens/detail_page.dart';
import 'package:weather_app/widgets/weather_item.dart';
import 'package:weather_app/services/weather_service.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Constants myConstants = Constants();

  int temperature = 0;
  int maxTemp = 0;
  String weatherStateName = 'Loading...';
  int humidity = 0;
  int windSpeed = 0;
  String currentDate = 'Loading...';
  String imageUrl = '';
  String location = 'London'; // mặc định

  List consolidatedWeatherList = [];

  final WeatherService weatherService = WeatherService();

  final TextEditingController _searchController = TextEditingController();

  // Hàm lấy dữ liệu thời tiết từ OpenWeatherMap
  void fetchWeatherData(String city) async {
    try {
      List list = await weatherService.fetchForecast(city);

      // Lọc dữ liệu dự báo: chọn bản ghi có thời gian 12:00:00 cho mỗi ngày
      Map<String, dynamic> dailyData = {};
      for (var entry in list) {
        String date = entry["dt_txt"].substring(0, 10);
        if (entry["dt_txt"].contains("12:00:00")) {
          dailyData[date] = entry;
        }
      }
      // Nếu dữ liệu chưa đủ, lấy luôn bản ghi đầu tiên của mỗi ngày
      if (dailyData.length < 5) {
        for (var entry in list) {
          String date = entry["dt_txt"].substring(0, 10);
          if (!dailyData.containsKey(date)) {
            dailyData[date] = entry;
          }
        }
      }
      List consolidated = dailyData.values.toList();

      setState(() {
        consolidatedWeatherList = consolidated;
        var current = consolidatedWeatherList[0];
        temperature = current["main"]["temp"].round();
        weatherStateName = current["weather"][0]["main"];
        humidity = current["main"]["humidity"].round();
        windSpeed = current["wind"]["speed"].round();
        maxTemp = current["main"]["temp_max"].round();
        var myDate = DateTime.parse(current["dt_txt"]);
        currentDate = DateFormat('EEEE, d MMMM').format(myDate);

        // Ensure weather state names are mapped correctly to icons
        Map<String, String> weatherIcons = {
          'Rain': 'rain',
          'Clear': 'clear',
          'Clouds': 'clouds',
          'Snow': 'snow',
          'Thunderstorm': 'thunderstorm',
          'Drizzle': 'drizzle',
          'Mist': 'mist',
        };
        imageUrl =
            weatherIcons[weatherStateName] ?? 'default'; // Correct mapping
        location = city;
      });
    } catch (e) {
      setState(() {
        weatherStateName = "Error";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Gọi API cho thành phố mặc định
    fetchWeatherData(location);
  }

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Nhập tên thành phố",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: const Color(0xffE0E8FB),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 0,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  if (_searchController.text.trim().isNotEmpty) {
                    fetchWeatherData(_searchController.text.trim());
                  }
                },
              ),
            ],
          ),
        ),
      ),
      body:
          consolidatedWeatherList.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                // Added SingleChildScrollView
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                        ),
                      ),
                      Text(
                        currentDate,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 50),
                      Container(
                        width: size.width,
                        height: 200,
                        decoration: BoxDecoration(
                          color: myConstants.primaryColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: myConstants.primaryColor.withOpacity(.5),
                              offset: const Offset(0, 25),
                              blurRadius: 10,
                              spreadRadius: -12,
                            ),
                          ],
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: -40,
                              left: 20,
                              child:
                                  imageUrl == ''
                                      ? const Text('')
                                      : Image.asset(
                                        'assets/' + imageUrl + '.png',
                                        width: 150,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Image.asset(
                                            'assets/lowrain.png', // Updated fallback icon
                                            width: 150,
                                          );
                                        },
                                      ),
                            ),
                            Positioned(
                              bottom: 30,
                              left: 20,
                              child: Text(
                                weatherStateName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 20,
                              right: 20,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      temperature.toString(),
                                      style: TextStyle(
                                        fontSize: 80,
                                        fontWeight: FontWeight.bold,
                                        foreground:
                                            Paint()..shader = linearGradient,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '°',
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      foreground:
                                          Paint()..shader = linearGradient,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            weatherItem(
                              text: 'Wind Speed',
                              value: windSpeed,
                              unit: ' km/h',
                              imageUrl: 'assets/windspeed.png',
                            ),
                            weatherItem(
                              text: 'Humidity',
                              value: humidity,
                              unit: '%',
                              imageUrl: 'assets/humidity.png',
                            ),
                            weatherItem(
                              text: 'Max Temp',
                              value: maxTemp,
                              unit: '°C',
                              imageUrl: 'assets/max-temp.png',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Today',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            'Next Days',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: myConstants.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 150, // Set height for horizontal ListView
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: consolidatedWeatherList.length,
                          itemBuilder: (BuildContext context, int index) {
                            var forecast = consolidatedWeatherList[index];
                            String today = DateTime.now().toString().substring(
                              0,
                              10,
                            );
                            var forecastDate = forecast["dt_txt"].substring(
                              0,
                              10,
                            );
                            var futureWeatherName =
                                forecast["weather"][0]["main"];
                            var weatherUrl = futureWeatherName.toLowerCase();

                            var parsedDate = DateTime.parse(forecast["dt_txt"]);
                            var newDate = DateFormat(
                              'EEE',
                            ).format(parsedDate); // Short day format

                            // Debug log to verify data
                            print(
                              "Rendering weather card for date: $forecastDate",
                            );

                            return GestureDetector(
                              onTap: () {
                                // Debug log to verify navigation data
                                print(
                                  "Navigating to DetailPage with index: $index",
                                );
                                print(
                                  "Selected forecast: ${consolidatedWeatherList[index]}",
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => DetailPage(
                                          consolidatedWeatherList:
                                              consolidatedWeatherList,
                                          selectedId: index,
                                          location: location,
                                        ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                margin: const EdgeInsets.only(right: 15),
                                width: 80,
                                decoration: BoxDecoration(
                                  color:
                                      forecastDate == today
                                          ? myConstants.primaryColor
                                          : Colors.white,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, 1),
                                      blurRadius: 5,
                                      color:
                                          forecastDate == today
                                              ? myConstants.primaryColor
                                                  .withOpacity(0.5)
                                              : Colors.black54.withOpacity(.2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      forecast["main"]["temp"]
                                              .round()
                                              .toString() +
                                          "°C",
                                      style: TextStyle(
                                        fontSize: 17,
                                        color:
                                            forecastDate == today
                                                ? Colors.white
                                                : myConstants.primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Image.asset(
                                      'assets/' + weatherUrl + '.png',
                                      width: 40,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Image.asset(
                                          'assets/lowrain.png', // Updated fallback icon
                                          width: 40,
                                        );
                                      },
                                    ),
                                    Text(
                                      newDate,
                                      style: TextStyle(
                                        fontSize: 17,
                                        color:
                                            forecastDate == today
                                                ? Colors.white
                                                : myConstants.primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
