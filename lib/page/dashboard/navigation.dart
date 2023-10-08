/// The navigation part of the [Dashboard] page.
///
/// Allows viewing [Requests] based on the selected subject, as well as
/// filtering by [RequestFilter].

import 'package:flutter/material.dart';
import 'package:specon/models/user_model.dart';
import 'package:specon/page/db.dart';
import 'package:specon/user_type.dart';
import 'package:specon/page/asm_mana.dart';
import 'package:specon/models/subject_model.dart';

class Navigation extends StatefulWidget {
  final void Function() openNewRequestForm;
  final void Function(SubjectModel) setCurrentSubject;
  final void Function(List<SubjectModel>) setSubjectList;
  final UserModel currentUser;
  final SubjectModel currentSubject;
  final void Function(String) getSelectedAssessment;


  const Navigation({
    Key? key,
    required this.openNewRequestForm,
    required this.setCurrentSubject,
    required this.setSubjectList,
    required this.currentUser,
    required this.currentSubject,
  }) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  bool isPressed = false;
  SubjectModel? selectedSubject;
  static final _db = DataBase();
  List<SubjectModel> subjectList = [];
  bool fetchingFromDB = true;

  void selectSubject(SubjectModel subject) {
    setState(() {
      selectedSubject = subject;
    });
  }

  List<Widget> _buildSubjectsColumn(List<SubjectModel> subjectList) {
    final List<Widget> subjectWidgets = [];

    // Create buttons for each subject
    for (final subject in subjectList) {
      bool isSelected = subject == selectedSubject;

      subjectWidgets.add(
        Container(
          color: Theme.of(context).colorScheme.background,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ClipRRect(
              borderRadius:  BorderRadius.circular(5),//isSelected
                 // ? BorderRadius.circular(5)
                 // : BorderRadius.zero, // Set radius only if selected
              child: MaterialButton(
                elevation: 0.0,
                onPressed: () {
                  setState(() {
                    if (subject.assessments.isEmpty &&
                        widget.currentUser.role ==
                            UserType.subjectCoordinator) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AsmManager(
                            subject: subject,
                            refreshFn: setState,
                          ),
                        ),
                      );
                    } else {
                      selectSubject(subject);
                      widget.setCurrentSubject(subject);
                    }
                  });
                },
                child: Container(
                  width: double.infinity, // Added this line
                  color: isSelected
                      ? Theme.of(context).colorScheme.onBackground
                      : Theme.of(context).colorScheme.background,
                  child: Text(
                    subject.code,
                    style: TextStyle(
                      color: isSelected
                          ? Theme.of(context).colorScheme.background
                          : Theme.of(context).colorScheme.onBackground,
// =======
//         Padding(
//           padding: const EdgeInsets.only(top: 10.0),
//           child: MaterialButton(
//             elevation: 0.0,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//             color: subject == selectedSubject
//                 ? Theme.of(context).colorScheme.surface
//                 : Theme.of(context).colorScheme.background,
//             //color: const Color(0x000000)
//             textColor: subject == selectedSubject
//                 ? Theme.of(context).colorScheme.onSurface
//                 : Theme.of(context).colorScheme.onBackground,

//             onPressed: () {
//               setState(() {
//                 isPressed = !isPressed;
//                 if (subject.assessments.isEmpty &&
//                     widget.currentUser.role == UserType.subjectCoordinator) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => AsmManager(
//                         subject: subject,
//                         refreshFn: setState,
//                       ),
// >>>>>>> main
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      if (subject.assessments.isNotEmpty && subject == selectedSubject) {
        // Add "All Assessments" option at the top
        subjectWidgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 45.0, top: 5.0),
            child: Align(
              alignment: Alignment.centerLeft, // Align text to the left
              child: InkWell(
                onTap: () {
                  widget.getSelectedAssessment("All");
                },
                child: Text(
                  "All",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        );

        // Add a list of assessments for this subject
        for (final assessment in subject.assessments) {
          subjectWidgets.add(
            Padding(
              padding: const EdgeInsets.only(left: 45.0, top: 5.0),
              child: Align(
                alignment: Alignment.centerLeft, // Align text to the left
                child: InkWell(
                  onTap: () {
                    widget.getSelectedAssessment(assessment.name);
                  },
                  child: Text(
                    assessment.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      }
    }

    return subjectWidgets;
  }

  @override
  void initState() {
    _db.getEnrolledSubjects().then((subjects) {
      subjectList = subjects;
      fetchingFromDB = false;
      widget.setSubjectList(subjects);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!fetchingFromDB) {
      if (widget.currentSubject != selectedSubject) {
        selectedSubject = widget.currentSubject;
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Display new request button only if user is a student
          if (widget.currentUser.role == UserType.student)
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
              child: OutlinedButton(
                style: ButtonStyle(
                    side: MaterialStateProperty.all(BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 1.0,
                        style: BorderStyle.solid)),
                    //backgroundColor: MaterialStateProperty.all(
                    //    Theme.of(context).colorScheme.secondary),
                    foregroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.secondary),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    )),
                onPressed: () {
                  setState(() {
                    widget.openNewRequestForm();
                  });
                },
                child: Text(
                  'New Request',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontSize: 14),
                ),
              ),
            ),
          ..._buildSubjectsColumn(subjectList),
        ],
      );
    } else {
      return const SizedBox(
        height: 100.0,
        width: 100.0,
        child: Center(child: CircularProgressIndicator()),
      );
    }
  }
}
