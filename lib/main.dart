import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Splashscreen.dart';

void main() {
  runApp(MaterialApp(
    home: SplashScreen(),
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
      brightness: Brightness.light,
    ),
    darkTheme: ThemeData(
      primarySwatch: Colors.deepPurple,
      brightness: Brightness.dark,
    ),
    themeMode: ThemeMode.system,
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

class TempState extends State<TempApp> with SingleTickerProviderStateMixin {
  late double input;
  double output = 0.0;
  bool? fOrC = true;
  List<String> calculationHistory = [];
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    input = 0.0;
    output = 0.0;
    fOrC = true;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _convertTemperature() {
    setState(() {
      if (fOrC == false) {
        output = (input - 32) * (5 / 9);
      } else {
        output = (input * 9 / 5) + 32;
      }
      String calculation = fOrC == false
          ? "${input.toStringAsFixed(2)} °F : ${output.toStringAsFixed(2)} °C"
          : "${input.toStringAsFixed(2)} °C : ${output.toStringAsFixed(2)} °F";
      calculationHistory.insert(0, calculation);
    });
    _controller.forward(from: 0.0);
    HapticFeedback.mediumImpact();
  }

  String _getTemperatureFact(double temp) {
    if (temp < 0) {
      return "Did you know? Water freezes at 0°C (32°F).";
    } else if (temp < 20) {
      return "Fun fact: The average room temperature is around 20°C (68°F).";
    } else if (temp < 37) {
      return "Interesting: The normal human body temperature is about 37°C (98.6°F).";
    } else {
      return "Hot fact: The highest temperature ever recorded on Earth was 56.7°C (134°F) in Death Valley, California.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Temperature Calculator"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepPurple.shade200, Colors.deepPurple.shade400],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextField(
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
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("°F"),
                    Radio<bool>(
                      groupValue: fOrC,
                      value: false,
                      onChanged: (v) {
                        setState(() {
                          fOrC = v;
                        });
                      },
                    ),
                    const Text("°C"),
                    Radio<bool>(
                      groupValue: fOrC,
                      value: true,
                      onChanged: (v) {
                        setState(() {
                          fOrC = v;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: const Text("Convert"),
                  onPressed: () {
                    _convertTemperature();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              fOrC == false
                                  ? "${input.toStringAsFixed(2)} °F : ${output.toStringAsFixed(2)} °C"
                                  : "${input.toStringAsFixed(2)} °C : ${output.toStringAsFixed(2)} °F",
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 10),
                            Text(
                              _getTemperatureFact(
                                  fOrC == true ? input : output),
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                Text("Calculation History",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Container(
                  height: 200,
                  child: ListView.builder(
                    itemCount: calculationHistory.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(calculationHistory[index]),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              calculationHistory.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                ScaleTransition(
                  scale: _animation,
                  child: Container(
                    width: 100,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: constraints.maxHeight * (output / 100),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
