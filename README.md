
## flutter_csc_picker

A flutter package for showing a selected country, states, and cities.

<img src="https://raw.githubusercontent.com/fozlerabbi321/flutter_csc_picker/master/screenshot/1.png" width="240"/>
<img src="https://raw.githubusercontent.com/fozlerabbi321/flutter_csc_picker/master/screenshot/2.png" width="240"/>
<img src="https://raw.githubusercontent.com/fozlerabbi321/flutter_csc_picker/master/screenshot/3.png" width="240"/>
<img src="https://raw.githubusercontent.com/fozlerabbi321/flutter_csc_picker/master/screenshot/4.png" width="240"/>
<img src="https://raw.githubusercontent.com/fozlerabbi321/flutter_csc_picker/master/screenshot/5.png" width="240"/>

## Usage

To use this Package, add flutter_csc_picker as a dependency in your pubspec.yaml.

```dart
FlutterCSCPicker(
              layout: Layout.vertical,
              onCountryChanged: (value) {
                setState(() {
                  countryValue = value;
                });
              },
              onStateChanged:(value) {
                setState(() {
                  stateValue = value;
                });
              },
              onCityChanged:(value) {
                setState(() {
                  cityValue = value;
                });
              },

            )
```

## Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_csc_picker/flutter_csc_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      title: 'Country State and City Picker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter CSC Picker"),),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: 600,
        child: Column(
          children: [
            ///Adding Flutter CSC Picker Widget in app
            FlutterCSCPicker(
              /// County and state same line [OPTIONAL PARAMETER]
              layout: Layout.vertical,
              /// Enable county title [OPTIONAL PARAMETER]
              isCountyTitle: false,
              /// Enable state title [OPTIONAL PARAMETER]
              isStateTitle: false,
              /// Enable county city [OPTIONAL PARAMETER]
              isCityTitle: false,
              onCountryChanged: (value) {
                setState(() {
                  countryValue = value;
                });
              },
              onStateChanged:(value) {
                setState(() {
                  stateValue = value;
                });
              },
              onCityChanged:(value) {
                setState(() {
                  cityValue = value;
                });
              },

            ),
          ],
        ),
      ),
    );
  }
}
```