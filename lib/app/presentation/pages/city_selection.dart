import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_user/app/data/local/data_sources/cities_data_source.dart';
import 'package:weather_user/app/domain/entities/cities.dart';
import 'package:weather_user/app/domain/entities/location/latlng.dart';
import 'package:weather_user/app/presentation/manager/permission/app_permission_bloc.dart';
import 'package:weather_user/utils/weather_status.dart';

class CitySelectionScreen extends StatefulWidget {
  final String cityName;
  final String backgroundImage;

  CitySelectionScreen(
      {Key? key, this.cityName = '', required this.backgroundImage})
      : super(key: key);

  @override
  _CitySelectionScreenState createState() => _CitySelectionScreenState();
}

class _CitySelectionScreenState extends State<CitySelectionScreen> {
  final TextEditingController _searchTextField = TextEditingController();
  String _searchText = " ";
  List<CitiesModel> cities = [];
  List<CitiesModel> filteredCities = [];
  Icon _searchIcon = Icon(Icons.search);
  bool isSearching = false;
  String cityName = '';
  String savedLocation = '';
  late AppPermissionBloc appPermissionBloc;
  String errorMessage = '';
  bool hasError = false;
  LatLng? latLng;

  @override
  void initState() {
    super.initState();
    appPermissionBloc = BlocProvider.of<AppPermissionBloc>(context);
    _searchTextField.addListener(() {
      setState(() {
        if (_searchTextField.text.isEmpty) {
          _searchText = "";
          filteredCities = cities;
        } else {
          _searchText = _searchTextField.text;
        }
      });
    });
    this._getCities();
    this.savedLocation = widget.cityName;
  }

  void _getCities() async {
    List<CitiesModel> tempList = [];
    tempList = await readAllCitiesJson();
    setState(() {
      cities = tempList;
      filteredCities = cities;
    });
  }

  Widget _appBarTitle() {
    return isSearching
        ? TextField(
            autofocus: true,
            controller: _searchTextField,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Where do you want to check?",
              hintStyle: TextStyle(
                color: Colors.white70,
              ),
            ),
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Colors.white70,
                ),
          )
        : SizedBox();
  }

  void _onSearchPressed() {
    setState(() {
      this.savedLocation = '';
      if (_searchTextField.text == "" || _searchTextField.text == null) {
        isSearching = isSearching ? false : true;
        if (isSearching) {
          _searchIcon = Icon(Icons.close);
        } else {
          _searchIcon = Icon(Icons.search);
          filteredCities = cities;
          _searchTextField.clear();
        }
      } else {
        _searchTextField.text = "";
      }
      Navigator.of(context).pop(this.cityName);
    });
  }

  Widget _searchList() {
    if (_searchText.isNotEmpty) {
      List<CitiesModel> tempList = [];
      for (int i = 0; i < cities.length; i++) {
        if (cities[i].city.toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(cities[i]);
        }
      }
      filteredCities = tempList;
    }

    return Column(
      children: <Widget>[
        BlocConsumer<AppPermissionBloc, AppPermissionState>(
            bloc: appPermissionBloc,
            listener: (context, state) {
              if (state is GetCurrentLocationState) {
              } else if (state is UpdateLocationState) {
                if (state.hasPlace) {
                  Navigator.of(context).pop([state.place, state.latLng]);
                } else {
                  debugPrint('${state.message}');
                }
              }
            },
            builder: (context, state) {
              if (state is CheckLocationServiceEnableState) {
              } else if (state is RequestLocationServiceState) {
              } else if (state is CheckLocationPermissionEnableState) {
              } else if (state is RequestLocationPermissionState) {
              } else if (state is GetCurrentLocationState) {
              } else if (state is UpdateLocationState) {
                hasError = state.hasPlace;
                if (state.hasPlace) {
                  this.cityName = state.place;
                }
              }
              return ListTile(
                dense: true,
                onTap: () {
                  /*setState(() {
                _searchTextField.text = "";
                this.cityName = '';
              });
              _onSearchPressed();*/
                  BlocProvider.of<AppPermissionBloc>(context)
                      .add(CheckLocationServiceEnable());
                },
                title: Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 18.0,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      "Current Location",
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.white70,
                            fontWeight: FontWeight.w700,
                            fontSize: 18.0,
                          ),
                    ),
                  ],
                ),
              );
            }),
        Expanded(
          child: ListView.builder(
            itemCount: filteredCities.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                dense: true,
                onTap: () {
                  setState(() {
                    this.cityName = "${filteredCities[index].city}";
                    this.savedLocation = '';
                  });
                  _searchTextField.text = "";
                  _onSearchPressed();
                },
                title: Text(
                  "${filteredCities[index].city}",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.0,
                      ),
                ),
                subtitle: Text(
                  "Loc: ${filteredCities[index].lat},${filteredCities[index].lng}",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                      ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    if (savedLocation != null) {
      this.cityName = savedLocation;
    }

    return WillPopScope(
      onWillPop: () async {
        if (this.isSearching) {
          setState(() {
            _searchTextField.text = "";
            this._onSearchPressed();
          });
        } else {
          return true;
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: _appBarTitle(),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: _onSearchPressed,
              icon: _searchIcon,
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: DefaultGradient(
          backgroundImage: widget.backgroundImage,
          child: cities.isNotEmpty || filteredCities.isNotEmpty
              ? _searchList()
              : Text(
                  'No cities found',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                      ),
                ),
          //: CurrentWeatherDetailsPage(cityName: this.cityName),
        ),
      ),
    );
  }
}

class DefaultGradient extends StatelessWidget {
  final Widget child;
  final String backgroundImage;

  const DefaultGradient(
      {Key? key, required this.child, required this.backgroundImage})
      : assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(
          weatherStatus[backgroundImage]['img'],
        ),
        fit: BoxFit.cover,
      )),
      child: child,
    );
  }
}
