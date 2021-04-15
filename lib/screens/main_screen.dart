import 'package:clima/classes/custom_outline_input_border.dart';
import 'package:clima/delegates/weather_manager_delegate.dart';
import 'package:clima/models/weather_manager.dart';
import 'package:clima/models/weather_model.dart';
import 'package:clima/services/location_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    implements WeatherManagerDelegate {
  // Screen properties
  var weatherIcon = Icons.wb_sunny_outlined;
  var temperature = '21.0';
  var city = 'London';

  final searchTextFieldController = TextEditingController();
  final weatherManager = WeatherManager();
  final locationService = LocationService();

  @override
  void initState() {
    weatherManager.delegate = this;
    super.initState();

    locationPressed();
  }

  @override
  void dispose() {
    searchTextFieldController.dispose();
    super.dispose();
  }

  void textFieldDidEndEditing() {
    var city = searchTextFieldController.text;
    weatherManager.fetchWeatherByCityName(city);
    // restore
    searchTextFieldController.clear();
  }

  Future<void> locationPressed() async {
    LocationData locationData = await locationService.requestLocation();
    weatherManager.fetchWeatherByLocation(
        locationData.latitude, locationData.longitude);
  }

  @override
  void didFailWithError(Error error) {
    showDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text('Error'),
        content: Text('Location not found'),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Close'),
            onPressed: () {
              Navigator.of(ctx).pop('Discard');
            },
          )
        ],
      ),
    );
  }

  @override
  void didUpdateWeather(WeatherModel weather) {
    setState(() {
      weatherIcon = weather.conditionIcon;
      temperature = weather.temperatureString;
      city = weather.cityName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.all(20.0),
      child: Column(
        children: [
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: IconButton(
                    icon: Icon(
                      Icons.my_location,
                    ),
                    iconSize: 40.0,
                    onPressed: () => locationPressed(),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: TextField(
                    controller: searchTextFieldController,
                    onEditingComplete: () {
                      FocusScope.of(context).unfocus();
                      textFieldDidEndEditing();
                    },
                    decoration: InputDecoration(
                      hintText: 'Search ...',
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.5),
                      border: CustomOutlineInputBorder(),
                      focusedBorder: CustomOutlineInputBorder(
                        borderColor: Colors.blueGrey,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(
                      Icons.search_sharp,
                    ),
                    iconSize: 40.0,
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      textFieldDidEndEditing();
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      weatherIcon,
                      size: 120.0,
                    ),
                    Text(
                      '$temperature°C',
                      style: TextStyle(fontSize: 80.0),
                    ),
                    Text(
                      city,
                      style: TextStyle(fontSize: 30.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
