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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Roboto', // Default flutter font, but good to be explicit
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

  String bmiValue = "";
  String bmiCategory = "";
  String bmiMessage = "";
  Color resultColor = Colors.transparent;

  void calculateBMI() {
    var wt = weightController.text.trim();
    var ft = feetController.text.trim();
    var inh = inchesController.text.trim();

    if (wt.isNotEmpty && ft.isNotEmpty && inh.isNotEmpty) {
      try {
        var iwt = int.parse(wt);
        var ift = int.parse(ft);
        var inch = int.parse(inh);

        var totalinch = (ift * 12) + inch;
        var totalcm = totalinch * 2.54;
        var totalm = totalcm / 100;
        var bmi = iwt / (pow(totalm, 2));
        var output = bmi.toStringAsFixed(1);

        String category = "";
        String msg = ""; // Can be used for extra motivation
        Color color;

        if (bmi < 18.5) {
          category = "Underweight";
          msg = "Time to grab a bite!";
          color = Colors.orangeAccent;
        } else if (bmi < 25) {
          category = "Normal";
          msg = "Great Job!";
          color = Colors.greenAccent;
        } else if (bmi < 30) {
          category = "Overweight";
          msg = "Time to run!";
          color = Colors.orange;
        } else {
          category = "Obese";
          msg = "Consult a doctor.";
          color = Colors.redAccent;
        }

        setState(() {
          bmiValue = output;
          bmiCategory = category;
          bmiMessage = msg;
          resultColor = color;
          FocusManager.instance.primaryFocus?.unfocus(); // Hide keyboard
        });
      } catch (e) {
        _showErrorSnackBar("Please enter valid numbers");
      }
    } else {
      _showErrorSnackBar("Please fill all the fields");
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void resetFields() {
    weightController.clear();
    feetController.clear();
    inchesController.clear();
    setState(() {
      bmiValue = "";
      bmiCategory = "";
      bmiMessage = "";
      resultColor = Colors.transparent;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Gradient Background
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2E3192), // Deep Indigo
              Color(0xFF1BFFFF), // Light Cyan/Blue accent
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  const Text(
                    "BMI Calculator",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Check your health status",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Input Card
                  Card(
                    elevation: 10,
                    shadowColor: Colors.black45,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    color: Colors.white.withOpacity(0.95),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: weightController,
                            label: "Weight",
                            suffix: "kg",
                            icon: Icons.monitor_weight_rounded,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  controller: feetController,
                                  label: "Height",
                                  suffix: "ft",
                                  icon: Icons.height,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  controller: inchesController,
                                  label: "Height",
                                  suffix: "in",
                                  icon: Icons.height,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: calculateBMI,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E3192),
                                foregroundColor: Colors.white,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                "CALCULATE",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton.icon(
                            onPressed: resetFields,
                            icon:
                                const Icon(Icons.refresh, color: Colors.grey),
                            label: const Text(
                              "Reset",
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  // Result Container (conditionally shown)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.only(top: 30),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: bmiValue.isEmpty
                          ? Colors.transparent
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: bmiValue.isEmpty
                          ? []
                          : [
                              const BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              )
                            ],
                    ),
                    child: bmiValue.isEmpty
                        ? const SizedBox()
                        : Column(
                            children: [
                              Text(
                                "Your BMI",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                bmiValue,
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                bmiCategory,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: resultColor, // Dynamic color
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                bmiMessage,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for TextFields to keep code clean
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String suffix,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        prefixIcon: Icon(icon, color: const Color(0xFF2E3192)),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E3192), width: 2),
        ),
      ),
    );
  }
}
