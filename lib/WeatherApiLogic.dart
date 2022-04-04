import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = 'bd76e8b62c99c1866c065e7b6c211459';
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';

Future getData(String url) async {
  http.Response response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    String data = response.body;
    return jsonDecode(data);
  }
}

Future<int> getLocationWeather(double latitude, double longitude) async {
  var weatherData = await getData(
      '$openWeatherMapURL?lat=${latitude}&lon=${longitude}&appid=$apiKey&units=metric');
  var temp = weatherData['main']['temp'];
  int temperature = temp.toInt();
  return temperature;
}

Stream<int> getNumbers(double latitude, double longitude) async* {
  yield await getLocationWeather(latitude, longitude);
  while (true) {
    await Future.delayed(const Duration(milliseconds: 20000));
    yield await getLocationWeather(latitude, longitude);
  }
}