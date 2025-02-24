import 'package:flutter/material.dart';

class CalculatePage extends StatelessWidget {
  final Map<String, int> scores; // ✅ Store scores from subjects

  const CalculatePage({Key? key, required this.scores}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B090B), // Night background
      appBar: AppBar(
        title: const Text("Submitted Scores", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Scores",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6DEEC7), // ✅ Aquamarine text
              ),
            ),
            const SizedBox(height: 10),

            // ✅ Dynamically display all scores
            Expanded(
              child: scores.isEmpty
                  ? const Center(
                child: Text(
                  "No scores submitted yet!",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              )
                  : ListView(
                children: scores.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4E1B8), // ✅ Wheat color
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "${entry.key}: ${entry.value}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE38C96), // ✅ Salmon Pink
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text("Back to Home", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
