import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../size_config.dart';
import '../../style/style.dart';
import 'step_2.dart';

class StressLevelChecker extends StatefulWidget {
  @override
  _StressLevelCheckerState createState() => _StressLevelCheckerState();
}

class _StressLevelCheckerState extends State<StressLevelChecker> {
  String stressLevel = "";
  String mainCauses = "";
  String impactOnDailyLife = "";
  String copingMechanisms = "";

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal! * 17,
            ),
            child: Column(
              children: [
                Header(),
                Questionnaire(
                  onStressLevelChanged: (value) {
                    setState(() {
                      stressLevel = value;
                    });
                  },
                  onMainCausesChanged: (value) {
                    setState(() {
                      mainCauses = value;
                    });
                  },
                  onImpactOnDailyLifeChanged: (value) {
                    setState(() {
                      impactOnDailyLife = value;
                    });
                  },
                  onCopingMechanismsChanged: (value) {
                    setState(() {
                      copingMechanisms = value;
                    });
                  },
                ),
                NextButton(
                  stressLevel: stressLevel,
                  mainCauses: mainCauses,
                  impactOnDailyLife: impactOnDailyLife,
                  copingMechanisms: copingMechanisms,
                  onSaveButtonPressed: () {
                    _saveDataToFirestore(
                      stressLevel: stressLevel,
                      mainCauses: mainCauses,
                      impactOnDailyLife: impactOnDailyLife,
                      copingMechanisms: copingMechanisms,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _saveDataToFirestore({
    required String stressLevel,
    required String mainCauses,
    required String impactOnDailyLife,
    required String copingMechanisms,
  }) {
    _firestore.collection('stressData').add({
      'stressLevel': stressLevel,
      'mainCauses': mainCauses,
      'impactOnDailyLife': impactOnDailyLife,
      'copingMechanisms': copingMechanisms,
    }).then((value) {
      print('Data saved to Firestore!');
    }).catchError((error) {
      print('Failed to save data to Firestore: $error');
    });
  }
}

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(
        top: SizeConfig.blockSizeVertical! * 3,
        bottom: 16.0,
      ),
      subtitle: const Padding(
        padding: EdgeInsets.only(
          bottom: 7,
          top: 7,
        ),
        child: Text(
          "Stress Level Checker",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 27,
            color: Color(0xff0e1012),
          ),
        ),
      ),
      trailing: SizedBox(
        height: 30,
        width: 30,
        child: SvgPicture.asset(
          AppStyle.checkListIcon,
        ),
      ),
    );
  }
}

class Questionnaire extends StatelessWidget {
  final Function(String) onStressLevelChanged;
  final Function(String) onMainCausesChanged;
  final Function(String) onImpactOnDailyLifeChanged;
  final Function(String) onCopingMechanismsChanged;

  const Questionnaire({
    Key? key,
    required this.onStressLevelChanged,
    required this.onMainCausesChanged,
    required this.onImpactOnDailyLifeChanged,
    required this.onCopingMechanismsChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Question(
          question: "How often do you feel stressed?",
          choices: ["Rarely", "Sometimes", "Often", "Always"],
          onChanged: onStressLevelChanged,
        ),
        Question(
          question: "What are the main causes of your stress?",
          choices: ["Work", "Relationships", "Health", "Finances"],
          onChanged: onMainCausesChanged,
        ),
        Question(
          question: "How does stress affect your daily life?",
          choices: [
            "Difficulty sleeping",
            "Loss of appetite",
            "Mood swings",
            "Difficulty concentrating"
          ],
          onChanged: onImpactOnDailyLifeChanged,
        ),
        Question(
          question: "What coping mechanisms do you use to manage stress?",
          choices: [
            "Exercise",
            "Meditation",
            "Talking to friends/family",
            "Listening to music"
          ],
          onChanged: onCopingMechanismsChanged,
        ),
      ],
    );
  }
}

class Question extends StatefulWidget {
  final String question;
  final List<String> choices;
  final Function(String) onChanged;

  const Question({
    Key? key,
    required this.question,
    required this.choices,
    required this.onChanged,
  }) : super(key: key);

  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  String? selectedChoice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.question,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.0),
          Column(
            children: widget.choices.map((choice) {
              return RadioListTile<String>(
                title: Text(choice),
                value: choice,
                groupValue: selectedChoice,
                onChanged: (value) {
                  setState(() {
                    selectedChoice = value;
                  });
                  widget.onChanged(value!);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  final String stressLevel;
  final String mainCauses;
  final String impactOnDailyLife;
  final String copingMechanisms;
  final VoidCallback onSaveButtonPressed;

  const NextButton({
    Key? key,
    required this.stressLevel,
    required this.mainCauses,
    required this.impactOnDailyLife,
    required this.copingMechanisms,
    required this.onSaveButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          onSaveButtonPressed();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StressLevelCheckerResult(
                stressLevel: stressLevel,
                mainCauses: mainCauses,
                impactOnDailyLife: impactOnDailyLife,
                copingMechanisms: copingMechanisms,
              ),
            ),
          );
        },
        child: const Text("Next"),
      ),
    );
  }
}
