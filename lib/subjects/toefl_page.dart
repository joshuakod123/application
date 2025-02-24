import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TOEFLPage extends StatefulWidget {
  const TOEFLPage({Key? key}) : super(key: key);

  @override
  _TOEFLPageState createState() => _TOEFLPageState();
}

class _TOEFLPageState extends State<TOEFLPage> {
  final TextEditingController readingController = TextEditingController();
  final TextEditingController listeningController = TextEditingController();
  final TextEditingController speakingController = TextEditingController();
  final TextEditingController writingController = TextEditingController();

  int totalScore = 0;
  String errorMessage = "";
  bool showErrorMessage = false;

  @override
  void dispose() {
    readingController.dispose();
    listeningController.dispose();
    speakingController.dispose();
    writingController.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    int r = int.tryParse(readingController.text) ?? 0;
    int l = int.tryParse(listeningController.text) ?? 0;
    int s = int.tryParse(speakingController.text) ?? 0;
    int w = int.tryParse(writingController.text) ?? 0;
    int newTotal = r + l + s + w;

    if ([r, l, s, w].any((score) => score < 1 || score > 30)) {
      setState(() {
        errorMessage = "Invalid score! Enter between 1 and 30.";
        showErrorMessage = true;
      });
      return;
    }

    setState(() {
      totalScore = newTotal;
      showErrorMessage = false;
    });

    if (newTotal < 1 || newTotal > 120) {
      _showInvalidScorePopup();
    } else {
      print("✅ TOEFL Score submitted: Total Score = $totalScore");
    }
  }

  void _showInvalidScorePopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0B090B),
          title: const Text("Invalid Score", style: TextStyle(color: Color(0xFF6DEEC7))),
          content: const Text(
            "TOEFL total score must be between 1 and 120.",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK", style: TextStyle(color: Color(0xFFE788A0))),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B090B), // 🌙 Night Background
      appBar: AppBar(
        title: const Text("TOEFL Page", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // **Total Score Display**
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFAADABA), // ✅ Celadon
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                children: [
                  const Text(
                    "Your Total Score",
                    style: TextStyle(
                      color: Color(0xFF6DEEC7), // ✅ Aquamarine
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    totalScore.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "1 to 120",
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // **Score Input Fields**
            _buildScoreInput("Reading", readingController, Icons.menu_book),
            _buildScoreInput("Listening", listeningController, Icons.headphones),
            _buildScoreInput("Speaking", speakingController, Icons.mic),
            _buildScoreInput("Writing", writingController, Icons.edit),

            // **Error Message**
            if (showErrorMessage)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),

            // **Submit Button**
            _buildButton(
              text: "Submit Scores",
              color: const Color(0xFFF8AC8B), // ✅ Atomic Tangerine
              textColor: Colors.black,
              onTap: _validateAndSubmit,
            ),
          ],
        ),
      ),
    );
  }

  // **Reusable Score Input Field**
  Widget _buildScoreInput(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "$label (1-30)",
          labelStyle: const TextStyle(color: Color(0xFFE788A0)), // ✅ Rose Pompadour
          prefixIcon: Icon(icon, color: const Color(0xFF6DEEC7)), // ✅ Aquamarine
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFE788A0)), // ✅ Rose Pompadour
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF6DEEC7)), // ✅ Aquamarine
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  // **Reusable Button Widget**
  Widget _buildButton({required String text, required Color color, required Color textColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
        child: Center(child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor))),
      ),
    );
  }
}
