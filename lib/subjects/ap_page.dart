import 'package:flutter/material.dart';
import '../screens/calculate_page.dart';

class APPage extends StatefulWidget {
  final Map<String, int> submittedScores;
  final Function(Map<String, int>) onSubmit; // ✅ Add onSubmit callback

  const APPage({Key? key, required this.submittedScores, required this.onSubmit}) : super(key: key);

  @override
  _APPageState createState() => _APPageState();
}

class _APPageState extends State<APPage> {
  final List<String> subjects = [
    "AP Capstone Diploma",
    "AP Arts",
    "AP English",
    "AP History & Social Sciences",
    "AP Math & Computer Science",
    "AP Sciences",
    "AP World Language & Cultures"
  ];

  final Map<String, List<String>> subCategories = {
    "AP Capstone Diploma": ["AP Research", "AP Seminar"],
    "AP Arts": ["AP 2-D Art and Design", "AP 3-D Art and Design", "AP Drawing", "AP Art History", "AP Music Theory"],
    "AP English": ["AP English Language and Composition", "AP English Literature and Composition"],
    "AP History & Social Sciences": [
      "AP African American Studies",
      "AP Comparative Government and Politics",
      "AP European History",
      "AP Human Geography",
      "AP Macroeconomics",
      "AP Microeconomics",
      "AP Psychology",
      "AP United States Government and Politics",
      "AP United States History",
      "AP World History: Modern"
    ],
    "AP Math & Computer Science": ["AP Calculus AB", "AP Calculus BC", "AP Computer Science A", "AP Computer Science Principles", "AP Precalculus", "AP Statistics"],
    "AP Sciences": ["AP Biology", "AP Chemistry", "AP Environmental Science", "AP Physics 1: Algebra-Based", "AP Physics 2: Algebra-Based", "AP Physics C: Electricity and Magnetism", "AP Physics C: Mechanics"],
    "AP World Language & Cultures": ["AP Chinese Language and Culture", "AP French Language and Culture", "AP German Language and Culture", "AP Italian Language and Culture", "AP Japanese Language and Culture", "AP Latin", "AP Spanish Language and Culture", "AP Spanish Literature and Culture"],
  };

  List<Map<String, dynamic>> selectedSubjects = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B090B), // 🌙 Night Background
      appBar: AppBar(
        title: const Text("AP Page", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "AP Courses",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6DEEC7), // ✅ Aquamarine
              ),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: selectedSubjects.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        _showSubCategoryDialog(context, index);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4E1B8), // ✅ Wheat
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          selectedSubjects[index]["subSubject"] != null &&
                              selectedSubjects[index]["score"] != null
                              ? "${selectedSubjects[index]["subSubject"]} - Score: ${selectedSubjects[index]["score"]}"
                              : "Select Subject",
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            _buildButton(
              text: "Add Another Subject",
              color: const Color(0xFFAF95C6), // ✅ African Violet
              textColor: Colors.black,
              onTap: () {
                setState(() {
                  selectedSubjects.add({"subSubject": null, "score": null});
                });
              },
            ),

            const SizedBox(height: 10),

            _buildButton(
              text: "Submit",
              color: const Color(0xFFE38C96), // ✅ Salmon Pink
              textColor: Colors.white,
              onTap: () {
                _submitScores(context);
              },
            ),
          ],
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

  void _showSubCategoryDialog(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Select a Course",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6DEEC7), // ✅ Aquamarine
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: subCategories.entries.map((entry) {
                    return ExpansionTile(
                      title: Text(
                        entry.key,
                        style: const TextStyle(color: Color(0xFFAF95C6)), // ✅ African Violet
                      ),
                      children: entry.value.map((sub) {
                        return ListTile(
                          title: Text(sub, style: const TextStyle(color: Colors.black)),
                          onTap: () {
                            _showScoreDialog(context, index, sub);
                          },
                        );
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showScoreDialog(BuildContext context, int index, String selectedSub) {
    List<int> scores = [1, 2, 3, 4, 5];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Select a Score",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6DEEC7), // ✅ Aquamarine
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: scores.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      title: Text("Score: ${scores[i]}", style: const TextStyle(color: Colors.black)),
                      onTap: () {
                        setState(() {
                          selectedSubjects[index]["subSubject"] = selectedSub;
                          selectedSubjects[index]["score"] = scores[i];
                        });
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
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
}
