import 'package:flutter/material.dart';
import '../screens/calculate_page.dart';

class IBPage extends StatefulWidget {
  final Map<String, int> submittedScores;
  final Function(Map<String, int>) onSubmit; // ✅ Added onSubmit callback

  const IBPage({Key? key, required this.submittedScores, required this.onSubmit}) : super(key: key);

  @override
  _IBPageState createState() => _IBPageState();
}

class _IBPageState extends State<IBPage> {
  List<String> areas = [
    "Studies in Language and Literature",
    "Language Acquisition",
    "Individuals & Societies",
    "Sciences",
    "Mathematics",
    "The Arts"
  ];

  Map<String, List<String>> subjectsByArea = {
    "Studies in Language and Literature": ["English A Literature", "English A Language and Literature", "Literature and Performance"],
    "Language Acquisition": ["French B", "Spanish B", "German B", "Mandarin B", "Ab Initio Languages"],
    "Individuals & Societies": ["History", "Geography", "Economics", "Psychology", "Philosophy", "Global Politics", "Business Management", "World Religions"],
    "Sciences": ["Biology", "Chemistry", "Physics", "Computer Science", "Environmental Systems and Societies", "Sports, Exercise, and Health Science"],
    "Mathematics": ["Mathematics: Analysis & Approaches", "Mathematics: Applications & Interpretation"],
    "The Arts": ["Visual Arts", "Music", "Theatre", "Dance", "Film", "Literary Arts"]
  };

  List<int> scores = [1, 2, 3, 4, 5, 6, 7];
  List<Map<String, dynamic>> selectedSubjects = [];
  int eeTokPoints = 0;
  int totalScore = 0;

  void _calculateTotalScore() {
    int subjectTotal = selectedSubjects
        .where((s) => s["score"] != null)
        .fold(0, (int sum, s) => sum + (s["score"] as int));

    setState(() {
      totalScore = subjectTotal + eeTokPoints;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B090B), // 🌙 Night Background
      appBar: AppBar(
        title: const Text("IB Page", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4E1B8), // ✅ Wheat
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Text("Your IB Total Score", style: TextStyle(color: Colors.black, fontSize: 18)),
                    Text(
                      "$totalScore / 45",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              for (int i = 0; i < 6; i++) ...[
                Text("Subject ${i + 1}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6DEEC7))), // ✅ Aquamarine text
                _buildDropdown("Select Area", null, areas, (value) {}),
                _buildDropdown("Select Subject", null, subjectsByArea[areas.first] ?? [], (value) {}),
                _buildDropdown("Enter Score (1-7)", null, scores.map((e) => e.toString()).toList(), (value) {}),
                const SizedBox(height: 10),
              ],

              const Text("EE & TOK Points", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6DEEC7))), // ✅ Aquamarine text
              _buildDropdown("Select EE/TOK Points", eeTokPoints.toString(), ["0", "1", "2", "3"], (value) {
                setState(() {
                  eeTokPoints = int.parse(value!);
                  _calculateTotalScore();
                });
              }),

              const SizedBox(height: 20),

              _buildButton(
                text: "Submit Scores",
                color: const Color(0xFFE38C96), // ✅ Salmon Pink
                textColor: Colors.white,
                onTap: () {
                  _submitScores(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitScores(BuildContext context) {
    Map<String, int> updatedScores = {...widget.submittedScores};

    for (var subject in selectedSubjects) {
      if (subject["subSubject"] != null && subject["score"] != null) {
        updatedScores[subject["subSubject"]] = subject["score"];
      }
    }

    widget.onSubmit(updatedScores); // ✅ Call onSubmit to update scores

    // ✅ Navigate to `CalculatePage` with submitted scores
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalculatePage(scores: updatedScores),
      ),
    );
  }

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

  Widget _buildDropdown(String hint, String? selectedValue, List<String> options, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        dropdownColor: const Color(0xFF0B090B), // 🌙 Night Background
        items: options
            .map((e) => DropdownMenuItem(
          value: e,
          child: Text(e, style: const TextStyle(color: Color(0xFFAF95C6))), // ✅ African Violet text
        ))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: hint,
          labelStyle: const TextStyle(color: Color(0xFFAF95C6)), // ✅ African Violet text
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
