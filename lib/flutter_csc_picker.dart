library flutter_csc_picker;

import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'model/select_status_model.dart' as status_model;
enum Layout { vertical, horizontal }

class FlutterCSCPicker extends StatefulWidget {
  final ValueChanged<String> onCountryChanged;
  final ValueChanged<String> onStateChanged;
  final ValueChanged<String> onCityChanged;
  final VoidCallback? onCountryTap;
  final VoidCallback? onStateTap;
  final VoidCallback? onCityTap;
  final Layout layout;
  final Widget arrowIcon;
  final TextStyle? style;
  final Color? dropdownColor;
  final InputDecoration decoration;
  final double spacing;
  final double titleSpacing;
  final bool isCountyTitle, isStateTitle, isCityTitle;
  final String countyTitle, stateTitle, cityTitle;
  final TextStyle? titleStyle;

  const FlutterCSCPicker({
    Key? key,
    required this.onCountryChanged,
    required this.onStateChanged,
    required this.onCityChanged,
    this.decoration = const InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF808080), width: .3),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
    ),
    this.arrowIcon = const Icon(
      Icons.keyboard_arrow_right_outlined,
      color: Colors.black,
    ),
    this.spacing = 10.0,
    this.titleSpacing = 5.0,
    this.style,
    this.dropdownColor,
    this.onCountryTap,
    this.onStateTap,
    this.onCityTap,
    this.isCountyTitle = true,
    this.isStateTitle = true,
    this.isCityTitle = true,
    this.layout = Layout.vertical,
    this.countyTitle = 'Country*',
    this.stateTitle = 'State*',
    this.cityTitle = 'City*',
    this.titleStyle,
  }) : super(key: key);

  @override
  _MyState createState() => _MyState();
}

class _MyState extends State<FlutterCSCPicker> {
  List<String> _cities = ["Choose City"];
  final List<String> _country = ["Choose Country"];
  String _selectedCity = "Choose City";
  String _selectedCountry = "Choose Country";
  String _selectedState = "Choose State/Province";
  List<String> _states = ["Choose State/Province"];

  @override
  void initState() {
    getCounty();
    super.initState();
  }

  Future getResponse() async {
    var res = await rootBundle.loadString('lib/assets/country.json');
    return jsonDecode(res);
  }

  Future getCounty() async {
    var countryres = await getResponse() as List;
    for (var data in countryres) {
      var model = status_model.StatusModel();
      model.name = data['name'];
      model.emoji = data['emoji'];
      if (!mounted) return;
      setState(() {
        _country.add(model.emoji! + "    " + model.name!);
      });
    }

    return _country;
  }

  Future getState() async {
    var response = await getResponse();
    var takestate = response
        .map((map) => status_model.StatusModel.fromJson(map))
        .where((item) => item.emoji + "    " + item.name == _selectedCountry)
        .map((item) => item.state)
        .toList();
    var states = takestate as List;
    for (var f in states) {
      if (!mounted) return;
      setState(() {
        var name = f.map((item) => item.name).toList();
        for (var statename in name) {
          log(statename.toString());

          _states.add(statename.toString());
        }
      });
    }

    return _states;
  }

  Future getCity() async {
    var response = await getResponse();
    var takestate = response
        .map((map) => status_model.StatusModel.fromJson(map))
        .where((item) => item.emoji + "    " + item.name == _selectedCountry)
        .map((item) => item.state)
        .toList();
    var states = takestate as List;
    for (var f in states) {
      var name = f.where((item) => item.name == _selectedState);
      var cityname = name.map((item) => item.city).toList();
      cityname.forEach((ci) {
        if (!mounted) return;
        setState(() {
          var citiesname = ci.map((item) => item.name).toList();
          for (var citynames in citiesname) {
            log(citynames.toString());

            _cities.add(citynames.toString());
          }
        });
      });
    }
    return _cities;
  }

  void _onSelectedCountry(String value) {
    if (!mounted) return;
    setState(() {
      _selectedState = "Choose  State/Province";
      _states = ["Choose  State/Province"];
      _selectedCountry = value;
      widget.onCountryChanged(value);
      getState();
    });
  }

  void _onSelectedState(String value) {
    if (!mounted) return;
    setState(() {
      _selectedCity = "Choose City";
      _cities = ["Choose City"];
      _selectedState = value;
      widget.onStateChanged(value);
      getCity();
    });
  }

  void _onSelectedCity(String value) {
    if (!mounted) return;
    setState(() {
      _selectedCity = value;
      widget.onCityChanged(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: widget.layout == Layout.vertical ?
          Column(
            children: [
              countySelect(),
              stateSelect(),
            ],
          ) : Row(
            children: [
              Expanded(child: countySelect(),),
              const SizedBox(
                width: 10,
              ),
              Expanded(child: stateSelect(),)

            ],
          ),
        ),
        if (widget.isCityTitle)
          Text(
            widget.cityTitle,
            style: widget.titleStyle ?? Theme.of(context).textTheme.subtitle1,
          ),
        if (widget.isCityTitle)
          SizedBox(
            height: widget.titleSpacing,
          ),
        InputDecorator(
          decoration: widget.decoration,
          child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: widget.dropdownColor,
                isExpanded: true,
                icon: widget.arrowIcon,
                items: _cities.map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            dropDownStringItem,
                            style: widget.style,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => _onSelectedCity(value!),
                onTap: widget.onCityTap,
                value: _selectedCity,
              )),
        ),
      ],
    );
  }

  Widget countySelect() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isCountyTitle)
          Text(
            widget.countyTitle,
            style: widget.titleStyle ?? Theme.of(context).textTheme.subtitle1,
          ),
        if (widget.isCountyTitle)
          SizedBox(
            height: widget.titleSpacing,
          ),
        InputDecorator(
          decoration: widget.decoration,
          child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: widget.dropdownColor,
                isExpanded: true,
                icon: widget.arrowIcon,
                items: _country.map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            dropDownStringItem,
                            style: widget.style,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
                // onTap: ,
                onChanged: (value) => _onSelectedCountry(value!),
                onTap: widget.onCountryTap,
                // onChanged: (value) => _onSelectedCountry(value!),
                value: _selectedCountry,
              )),
        ),
        SizedBox(
          height: widget.spacing,
        ),
      ],
    );
  }

  Widget stateSelect() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isStateTitle)
          Text(
            widget.stateTitle,
            style: widget.titleStyle ?? Theme.of(context).textTheme.subtitle1,
          ),
        if (widget.isStateTitle)
          SizedBox(
            height: widget.titleSpacing,
          ),
        InputDecorator(
          decoration: widget.decoration,
          child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: widget.dropdownColor,
                isExpanded: true,
                icon: widget.arrowIcon,
                items: _states.map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            dropDownStringItem,
                            style: widget.style,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => _onSelectedState(value!),
                onTap: widget.onStateTap,
                value: _selectedState,
              )),
        ),
        SizedBox(
          height: widget.spacing,
        ),
      ],
    );
  }
}