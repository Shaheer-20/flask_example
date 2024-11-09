import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MouseControllerApp());
}

class MouseControllerApp extends StatelessWidget {
  const MouseControllerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mouse Controller',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MouseControllerScreen(),
    );
  }
}

class MouseControllerScreen extends StatefulWidget {
  const MouseControllerScreen({super.key});

  @override
  MouseControllerScreenState createState() => MouseControllerScreenState();
}

class MouseControllerScreenState extends State<MouseControllerScreen> {
  String ipAddress = "192.168.xxxxxx"; // Replace with your laptop's IP address
  double xOffset = 0.0;
  double yOffset = 0.0;
  bool isLoading = false;

  // Method to send move command
  void moveMouse(double dx, double dy) async {
    setState(() {
      isLoading = true;
    });

    try {
      var url = Uri.parse('http://$ipAddress:5000/move');
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"x": dx, "y": dy}),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("Mouse moved successfully.");
        }
      } else {
        if (kDebugMode) {
          print('Failed to move mouse. Status Code: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error moving mouse: $e');
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Method to send click command
  void clickMouse() async {
    setState(() {
      isLoading = true;
    });

    try {
      var url = Uri.parse('http://$ipAddress:5000/click');
      var response = await http.post(url);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("Mouse clicked successfully.");
        }
      } else {
        if (kDebugMode) {
          print('Failed to click mouse. Status Code: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clicking mouse: $e');
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mouse Controller'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                xOffset += details.localPosition.dx;
                yOffset += details.localPosition.dy;
              });
              moveMouse(details.localPosition.dx, details.localPosition.dy);
            },
            child: Container(
              width: 300,
              height: 300,
              color: Colors.blue[100],
              child: const Center(
                child: Text('Move Mouse Here'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isLoading ? null : clickMouse,
            child: isLoading
                ? const CircularProgressIndicator()
                : const Text('Click'),
          ),
          const SizedBox(height: 20),
          Text('Current Position: x: $xOffset, y: $yOffset'),
        ],
      ),
    );
  }
}
