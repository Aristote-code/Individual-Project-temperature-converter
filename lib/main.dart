import 'package:flutter/material.dart';
import 'Splashscreen.dart';

void main() {
  runApp(MaterialApp(
    home: SplashScreen(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const TempApp(),
    );
  }
}

class TempApp extends StatefulWidget {
  const TempApp({super.key});

  @override
  TempState createState() => TempState();
}

class TempState extends State<TempApp> {
  late double input;
  double output = 0.0;
  bool? fOrC = true;
  List<String> calculationHistory = [];

  @override
  void initState() {
    super.initState();
    input = 0.0;
    output = 0.0;
    fOrC = true;
  }

  @override
  Widget build(BuildContext context) {
    TextField inputField = TextField(
      keyboardType: TextInputType.number,
      onChanged: (str) {
        try {
          input = double.parse(str);
        } catch (e) {
          input = 0.0;
        }
      },
      decoration: InputDecoration(
        labelText:
            "Input a Value in °${fOrC == false ? "Fahrenheit" : "Celsius"}",
      ),
      textAlign: TextAlign.center,
    );

    AppBar appBar = AppBar(
      title: const Text("Temperature Calculator"),
    );

    Container tempSwitch = Container(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          const Text("°F"),
          Radio<bool>(
              groupValue: fOrC,
              value: false,
              onChanged: (v) {
                setState(() {
                  fOrC = v;
                });
              }),
          const Text("°C"),
          Radio<bool>(
              groupValue: fOrC,
              value: true,
              onChanged: (v) {
                setState(() {
                  fOrC = v;
                });
              }),
        ],
      ),
    );

    Container calcBtn = Container(
      child: ElevatedButton(
        child: const Text("Convert"),
        onPressed: () {
          setState(() {
            fOrC == false
                ? output = (input - 32) * (5 / 9)
                : output = (input * 9 / 5) + 32;

            String calculation = fOrC == false
                ? "${input.toStringAsFixed(2)} °F : ${output.toStringAsFixed(2)} °C"
                : "${input.toStringAsFixed(2)} °C : ${output.toStringAsFixed(2)} °F";

            calculationHistory.insert(0, calculation);
          });
          AlertDialog dialog = AlertDialog(
            content: fOrC == false
                ? Text(
                    "${input.toStringAsFixed(2)} °F : ${output.toStringAsFixed(2)} °C")
                : Text(
                    "${input.toStringAsFixed(2)} °C : ${output.toStringAsFixed(2)} °F"),
          );
          showDialog(
              context: context, builder: (BuildContext context) => dialog);
        },
      ),
    );

    Widget historyList = Container(
      height: 200,
      child: ListView.builder(
        itemCount: calculationHistory.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(calculationHistory[index]),
          );
        },
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              inputField,
              tempSwitch,
              calcBtn,
              SizedBox(height: 20),
              Text("Calculation History",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              historyList,
            ],
          ),
        ),
      ),
    );
  }
}
