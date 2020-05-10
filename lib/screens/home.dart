import 'package:country_pickers/countries.dart';
import 'package:flutter/material.dart';
import 'package:covid19_tracker/Widgets/charts.dart';
import 'package:covid19_tracker/Widgets/details.dart';
import 'package:covid19_tracker/services/api_service.dart';
import 'package:covid19_tracker/services/shared_preferences.dart';
import 'package:covid19_tracker/models/data.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';

class Home extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Data _res;
  bool _loading = true;
  Country _selectedDialogCountry = CountryPickerUtils.getCountryByIsoCode("IN");
  Country _defaultCountry = CountryPickerUtils.getCountryByIsoCode("IN");
  DefaultCountry defCountry = DefaultCountry();
  String def = '';

  @override
  void initState() {
    super.initState();
    defCountry.getCountry().then((val) {
      setState(
          () => _defaultCountry = CountryPickerUtils.getCountryByIsoCode(val));
      _selectedDialogCountry = _defaultCountry;
      _fetchData();
    });
  }

  //calls fetchApi and return data
  void _fetchData() {
    setState(() {});
    fetchApi(_selectedDialogCountry.isoCode).then(
      (val) => setState(
        () {
          _res = val;
          _loading = false;
        },
      ),
    );
  }

  //create dialog items comtaining country flag and name
  Widget _buildDialogItem(Country country) => Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: CountryPickerUtils.getDefaultFlagImage(country),
          ),
          SizedBox(width: 8.0),
          Flexible(
            child: Text(
              country.name,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          )
        ],
      );

  //creates dialog box with list of countries to select
  void _openCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
          data: Theme.of(context),
          child: CountryPickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Colors.black,
            searchInputDecoration: InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            title: Text('Search Country'),
            onValuePicked: (Country country) {
              setState(() {
                _selectedDialogCountry = country;
                _loading = true;
              });

              _fetchData();
            },
            itemBuilder: _buildDialogItem,
          ),
        ),
      );

  //select default country dialog
  void _selectDefaultCountry() => showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Default Country'),
              content: TextFormField(
                initialValue: _defaultCountry.name,
                onChanged: (val) => setState(() => def = val),
              ),
              actions: [
                FlatButton(
                    onPressed: () {
                      setState(() {
                        _defaultCountry = countryList.firstWhere(
                          (country) =>
                              country.name.toLowerCase() == def.toLowerCase(),
                        );
                        _selectedDialogCountry = _defaultCountry;
                        _loading = true;
                      });
                      _fetchData();

                      defCountry.save(_defaultCountry);
                      Navigator.pop(context);
                    },
                    child: Text('Done')),
                FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel')),
              ],
            );
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.deepPurple[600],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[600],
        elevation: 0.0,
        title: Text(
          "Covid-19 Tracker",
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => _selectDefaultCountry(),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: EdgeInsets.all(10.0),
            child: Row(children: <Widget>[
              Flexible(child: _buildDialogItem(_selectedDialogCountry)),
              IconButton(
                onPressed: _openCountryPickerDialog,
                icon: Icon(Icons.search),
              ),
            ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 180.0,
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.white,
                  margin: EdgeInsets.all(10.0),
                  elevation: 4.0,
                  child: _loading
                      ? Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        )
                      : _res.latestData.confirmed == 0
                          ? Center(
                              child: Center(
                                child: Text(
                                  'No Cases Found',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Image.asset(
                                        CountryPickerUtils
                                            .getFlagImageAssetPath(
                                                _selectedDialogCountry.isoCode),
                                        height: 40.0,
                                        width: 60.0,
                                        fit: BoxFit.fill,
                                        package: "country_pickers",
                                      ),
                                      SizedBox(
                                        width: 20.0,
                                      ),
                                      Flexible(
                                        child: Text(
                                          _res.name,
                                          style: TextStyle(
                                            fontSize: 34.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    height: 28.0,
                                    thickness: 2.0,
                                  ),
                                  Details(res: _res),
                                  Divider(
                                    height: 28.0,
                                    thickness: 2.0,
                                  ),
                                  SimpleTimeSeriesChart.withData(
                                    _res.timeLine,
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        _loading = true;
                                      });
                                      _fetchData();
                                    },
                                    child: Text(
                                      "Refresh",
                                      style: TextStyle(
                                        color: Colors.indigoAccent,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
