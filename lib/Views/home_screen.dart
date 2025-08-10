import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/Controllers/api_controller.dart';
import 'package:weather_app/Controllers/theme_controller.dart';
import 'package:weather_app/Models/current_weather_model.dart';
import 'package:weather_app/Models/hourly_weatherdata_model.dart';
import 'package:weather_app/Services/api_service.dart';

class HomeScreen extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());
  final ApiController apiController = Get.put(ApiController());
  @override
  Widget build(BuildContext context) {
    var date = DateFormat("yMMMMd").format(DateTime.now());
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          date,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            color: theme.primaryColor,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          Obx(
            () => IconButton(
              onPressed: () {
                themeController.toggleTheme();
              },
              icon: Icon(
                themeController.isDarkMode.value
                    ? Icons.light_mode
                    : Icons.dark_mode,
                color: theme.primaryColor,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert, color: theme.primaryColor),
          ),
        ],
      ),
      body: FutureBuilder(
        future: apiController.CurrentWeatherData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            CurrentWeatherData weatherData = snapshot.data;
            var temp = (weatherData.main!.temp! - 273);
            var maxtemp = (weatherData.main!.tempMax! - 273);
            var mintemp = (weatherData.main!.tempMin! - 273);

            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weatherData.name!,
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        letterSpacing: 3,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Image.asset(
                            "assets/weather/${weatherData.weather![0].icon}.png",
                            width: 60,
                            height: 60,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: temp.round().toString(),
                                style: TextStyle(
                                  color: theme.primaryColor,

                                  fontSize: 50,
                                  fontFamily: "poppins",
                                ),
                              ),
                              TextSpan(
                                text: "°C",
                                style: TextStyle(
                                  color: theme.primaryColor,

                                  letterSpacing: 3,
                                  fontSize: 14,
                                  fontFamily: "poppins",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: null,
                          icon: Icon(
                            Icons.expand_less_rounded,
                            color: theme.primaryColor,
                          ),
                          label: Text(
                            maxtemp.round().toString(),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: null,
                          icon: Icon(
                            Icons.expand_more_rounded,
                            color: theme.primaryColor,
                          ),
                          label: Text(
                            mintemp.round().toString(),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(3, (index) {
                        // Fixed icons list
                        var iconsList = [
                          "assets/icons/clouds.png",
                          "assets/icons/humidity.png",
                          "assets/icons/windspeed.png",
                        ];
                        var labels = ["Clouds", "Humidity", "Wind"];
                        var values = [
                          weatherData.clouds!.all,
                          weatherData.main!.humidity,
                          weatherData.wind!.speed,
                        ];

                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: theme.cardColor,

                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: EdgeInsets.all(6),
                              child: Image.asset(iconsList[index], width: 80),
                            ),
                            Text(
                              labels[index],
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: theme.primaryColor,

                                fontSize: 12,
                              ),
                            ),
                            Text(
                              values[index].toString(),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: theme.primaryColor,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                    SizedBox(height: 10),
                    Divider(),

                    SizedBox(height: 10),
                    FutureBuilder(
                      future: apiController.HourlyWeatherData,

                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          HourlyWeatherData hourlyWeather = snapshot.data;

                          return SizedBox(
                            height: 150,
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: hourlyWeather.list!.length,
                              itemBuilder: (BuildContext context, int index) {
                                DateTime dateTime =
                                    hourlyWeather.list![index].dtTxt!;
                                String time = DateFormat(
                                  "HH:mm",
                                ).format(dateTime);
                                double temp =
                                    hourlyWeather.list![index].main!.temp! -
                                    273.15;

                                return Container(
                                  margin: const EdgeInsets.only(right: 4),
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: theme.cardColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        time,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                      Image.asset(
                                        'assets/weather/${hourlyWeather.list![index].weather![0].icon}.png',
                                        width: 100,
                                      ),
                                      Text(
                                        temp.toStringAsFixed(0),
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    Divider(),

                    SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "7 Days Forecast ",
                          style: GoogleFonts.poppins(
                            color: theme.primaryColor,

                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                      ],
                    ),
                    FutureBuilder(
                      future: apiController.HourlyWeatherData,

                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          HourlyWeatherData hourlyWeather = snapshot.data;
                          return ListView.builder(
                            itemCount: 7,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),

                            itemBuilder: (BuildContext context, int index) {
                              var day = DateFormat("EEEE").format(
                                DateTime.now().add(Duration(days: index + 1)),
                              );
                              double temp =
                                  hourlyWeather.list![index].main!.temp! -
                                  273.15;
                              double maxtemp =
                                  hourlyWeather.list![index].main!.tempMax! -
                                  273.15;
                              double mintemp =
                                  hourlyWeather.list![index].main!.tempMin! -
                                  273.15;
                              String max = maxtemp.toStringAsFixed(0);
                              String min = mintemp.toStringAsFixed(0);
                              return Card(
                                color: theme.cardColor,

                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          day,
                                          style: GoogleFonts.poppins(
                                            color: theme.primaryColor,

                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),

                                      Expanded(
                                        child: TextButton.icon(
                                          onPressed: () {},
                                          icon: Image.asset(
                                            'assets/weather/${hourlyWeather.list![index].weather![0].icon}.png',
                                            width: 40,
                                          ),
                                          label: Text(
                                            temp.toStringAsFixed(0),
                                            style: GoogleFonts.poppins(
                                              color: theme.primaryColor,

                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          "$max / $min",
                                          textAlign: TextAlign.end,
                                          style: GoogleFonts.poppins(
                                            color: theme.primaryColor,

                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
