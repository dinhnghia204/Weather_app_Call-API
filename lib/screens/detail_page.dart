import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/constants.dart';
import 'package:weather_app/widgets/weather_item.dart';

class DetailPage extends StatefulWidget {
  final List consolidatedWeatherList;
  final int selectedId;
  final String location;

  // Xóa const ở đây để cho phép truyền dữ liệu runtime
  DetailPage({
    Key? key,
    required this.consolidatedWeatherList,
    required this.selectedId,
    required this.location,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String imageUrl = '';
  late int selectedIndex; // Make selectedIndex a state variable

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedId; // Initialize selectedIndex
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Constants myConstants = Constants();

    final Shader linearGradient = const LinearGradient(
      colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)],
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    var currentForecast = widget.consolidatedWeatherList[selectedIndex];
    var weatherStateName =
        currentForecast["weather"][0]["main"]; // Define weatherStateName here

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
    imageUrl = weatherIcons[weatherStateName] ?? 'default'; // Correct mapping

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: myConstants.secondaryColor,
        elevation: 0.0,
        title: Text(widget.location),
      ),
      body: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 10,
            left: 10,
            child: SizedBox(
              height: 150,
              width: 400,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.consolidatedWeatherList.length,
                itemBuilder: (BuildContext context, int index) {
                  var forecast = widget.consolidatedWeatherList[index];
                  var futureWeatherName = forecast["weather"][0]["main"];
                  var weatherURL = futureWeatherName.toLowerCase();
                  var parsedDate = DateTime.parse(forecast["dt_txt"]);
                  var newDate = DateFormat(
                    'EEEE',
                  ).format(parsedDate).substring(0, 3);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index; // Update selectedIndex on click
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      margin: const EdgeInsets.only(right: 20),
                      width: 80,
                      decoration: BoxDecoration(
                        color:
                            index == selectedIndex
                                ? Colors.white
                                : const Color(0xff9ebcf9),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 1),
                            blurRadius: 5,
                            color: Colors.blue.withOpacity(.3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            forecast["main"]["temp"].round().toString() + "°C",
                            style: TextStyle(
                              fontSize: 17,
                              color:
                                  index == selectedIndex
                                      ? Colors.blue
                                      : Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Image.asset(
                            'assets/' + weatherURL + ".png",
                            width: 40,
                            errorBuilder: (context, error, stackTrace) {
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
                                  index == selectedIndex
                                      ? Colors.blue
                                      : Colors.white,
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
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              height: size.height * .55,
              width: size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -50,
                    right: 20,
                    left: 20,
                    child: Container(
                      width: size.width * .7,
                      height: 300,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.center,
                          colors: [Color(0xffa9c1f5), Color(0xff6696f5)],
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(.1),
                            offset: const Offset(0, 25),
                            blurRadius: 3,
                            spreadRadius: -10,
                          ),
                        ],
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -40,
                            left: 20,
                            child: Image.asset(
                              'assets/' + imageUrl + '.png',
                              width: 150,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/lowrain.png', // Updated fallback icon
                                  width: 150,
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 120,
                            left: 30,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                weatherStateName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: Container(
                              width: size.width * .8,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  weatherItem(
                                    text: 'Wind Speed',
                                    value:
                                        currentForecast["wind"]["speed"]
                                            .round(),
                                    unit: ' km/h',
                                    imageUrl: 'assets/windspeed.png',
                                  ),
                                  weatherItem(
                                    text: 'Humidity',
                                    value:
                                        currentForecast["main"]["humidity"]
                                            .round(),
                                    unit: '%',
                                    imageUrl: 'assets/humidity.png',
                                  ),
                                  weatherItem(
                                    text: 'Max Temp',
                                    value:
                                        currentForecast["main"]["temp_max"]
                                            .round(),
                                    unit: '°C',
                                    imageUrl: 'assets/max-temp.png',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            right: 20,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentForecast["main"]["temp"]
                                      .round()
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    foreground:
                                        Paint()..shader = linearGradient,
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
                  ),
                  Positioned(
                    top: 300,
                    left: 20,
                    child: SizedBox(
                      height: 200,
                      width: size.width * .9,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: widget.consolidatedWeatherList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var forecast = widget.consolidatedWeatherList[index];
                          var futureWeatherName =
                              forecast["weather"][0]["main"];
                          var futureImageURL = futureWeatherName.toLowerCase();
                          var myDate = DateTime.parse(forecast["dt_txt"]);
                          var currentDate = DateFormat(
                            'd MMMM, EEEE',
                          ).format(myDate);
                          return Container(
                            margin: const EdgeInsets.only(
                              left: 10,
                              top: 10,
                              right: 10,
                              bottom: 5,
                            ),
                            height: 80,
                            width: size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: myConstants.secondaryColor.withOpacity(
                                    .1,
                                  ),
                                  spreadRadius: 5,
                                  blurRadius: 20,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    currentDate,
                                    style: const TextStyle(
                                      color: Color(0xff6696f5),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        forecast["main"]["temp_max"]
                                            .round()
                                            .toString(),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Text(
                                        '/',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 30,
                                        ),
                                      ),
                                      Text(
                                        forecast["main"]["temp_min"]
                                            .round()
                                            .toString(),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/' + futureImageURL + '.png',
                                        width: 30,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Image.asset(
                                            'assets/lowrain.png', // Updated fallback icon
                                            width: 30,
                                          );
                                        },
                                      ),
                                      Text(forecast["weather"][0]["main"]),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
