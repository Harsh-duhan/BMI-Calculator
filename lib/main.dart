import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController feetController = TextEditingController();
  final TextEditingController inchesController = TextEditingController();

  String result = "";
  Color resultColor = Colors.transparent;
  String bmiValue = "";
  String bmiCategory = "";

  void calculateBMI() {
    var wt = weightController.text.toString();
    var ft = feetController.text.toString();
    var inh = inchesController.text.toString();

    if (wt != "" && ft != "" && inh != "") {
      try {
        var iwt = int.parse(wt);
        var ift = int.parse(ft);
        var inch = int.parse(inh);

        var totalinch = (ift * 12) + inch;
        var totalcm = totalinch * 2.54;
        var totalm = totalcm / 100;
        var bmi = iwt / (pow(totalm, 2));
        var output = bmi.toStringAsFixed(2);

        String msg = "";
        Color color = Colors.transparent;

        if (bmi > 25) {
          msg = "Overweight";
          color = Colors.orange.shade100;
        } else if (bmi < 18) {
          msg = "Underweight";
          color = Colors.red.shade100;
        } else {
          msg = "Normal";
          color = Colors.green.shade100;
        }

        setState(() {
          bmiValue = output;
          bmiCategory = msg;
          resultColor = color;
          result = ""; // Clear error message
        });
      } catch (e) {
        setState(() {
          result = "Please enter valid numbers";
          bmiValue = "";
          bmiCategory = "";
          resultColor = Colors.transparent;
        });
      }
    } else {
      setState(() {
        result = "Please fill all the values";
        bmiValue = "";
        bmiCategory = "";
        resultColor = Colors.transparent;
      });
    }
  }

  void resetFields() {
    weightController.clear();
    feetController.clear();
    inchesController.clear();
    setState(() {
      result = "";
      bmiValue = "";
      bmiCategory = "";
      resultColor = Colors.transparent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BMI Calculator"),
        actions: [
          IconButton(
            onPressed: resetFields,
            icon: const Icon(Icons.refresh),
            tooltip: "Reset",
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Instruction Text
              const Text(
                "Check your Body Mass Index",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 24),

              // Inputs Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: weightController,
                        decoration: const InputDecoration(
                          labelText: "Weight (kg)",
                          prefixIcon: Icon(Icons.monitor_weight_outlined),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: feetController,
                              decoration: const InputDecoration(
                                labelText: "Feet",
                                prefixIcon: Icon(Icons.height),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: inchesController,
                              decoration: const InputDecoration(
                                labelText: "Inches",
                                prefixIcon: Icon(Icons.height),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Calculate Button
              ElevatedButton(
                onPressed: calculateBMI,
                child: const Text("CALCULATE"),
              ),

              const SizedBox(height: 32),

              // Result Area
              if (bmiValue.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: resultColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.black12,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Your BMI",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        bmiValue,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        bmiCategory,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),

              // Error Message
              if (result.isNotEmpty && bmiValue.isEmpty)
                Text(
                  result,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
