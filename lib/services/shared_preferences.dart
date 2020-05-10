import 'package:country_pickers/country.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DefaultCountry {
  SharedPreferences sharedPreferences;
  //saves Default country
  void save(Country country) async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("Default Country", country.isoCode);
  }

  //loads Default country
  Future<String> getCountry() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("Default Country") ?? "IN";
  }
}
