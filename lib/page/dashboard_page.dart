/// The main page for an authenticated user.
///
/// Content changes based on the [UserType] that is authenticated.

import 'package:flutter/material.dart';
import 'package:specon/form.dart';
import 'package:specon/page/dashboard/navigation.dart';
import 'package:specon/page/dashboard/requests.dart';
import 'package:specon/page/dashboard/discussion.dart';
import 'package:specon/user_type.dart';

class Dashboard extends StatefulWidget {
  final UserType userType;

  const Dashboard(
    {
      Key? key,
      required this.userType
    }
  ) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  final topBarColor = const Color(0xFF385F71);
  final avatarBackgroundColor = const Color(0xFFD78521);
  final mainBodyColor = const Color(0xFF333333);
  final menuColor = const Color(0xFFD4D4D4);
  final dividerColor = Colors.white;
  final stopwatch = Stopwatch();
  Map<String, String> currentSubject = {'code': '', 'name': ''};
  Map currentRequest = {};
  bool avatarIsPressed = false;
  bool newRequest = false;
  bool showSubmittedRequest = false;
  Map currentUser = {'userID': 2, 'name': 'Harry', 'userType': UserType.subjectCoordinator}; // TODO: Should get from landing_page
  String studentName = '';
  Widget? requestWidget;
  Widget? discussionWidget;

  void openSubmittedRequest(Map currentRequest) {
    setState(() {
      showSubmittedRequest = true;
      newRequest = false;
      this.currentRequest = currentRequest;
    });
  }

  String getCurrentSubjectCode() {
    return currentSubject['code']!;
  }

  void openNewRequestForm() {
    setState(() {
      newRequest = true;
      showSubmittedRequest = false;
    });
  }

  Map getCurrentRequest() {
    return currentRequest;
  }

  void closeNewRequestForm() {
    setState(() {
      newRequest = false;
    });
  }

  void setCurrentSubject(Map<String, String> subject) {
    setState(() {
      currentSubject = subject;
      requestWidget;
      showSubmittedRequest = false;
      newRequest = false;
    });
  }

  Widget displayThirdColumn() {

    if (newRequest) {
      return SpeconForm(closeNewRequestForm: closeNewRequestForm); // TODO

    } else if (showSubmittedRequest) {
        return Center(
          child: discussionWidget = Discussion(
            getCurrentRequest: getCurrentRequest,
            currentUser: currentUser,
          ),
        );

    } else {
      return const Center(
          child: Text(
            'Select a request',
            style: TextStyle(color: Colors.white, fontSize: 25)
          ),
        );

    }
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      appBar: AppBar(
        backgroundColor: topBarColor,
        elevation: 0.0,

        // Logo
        leading: InkWell(
          onTap: () {},
          child: const Center(
            child: Text(
              'Specon',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            )
          )
        ),

        leadingWidth: 110.0,

        title: Text(
                '${currentSubject['code']!} - ${currentSubject['name']!}',
                style: const TextStyle(color: Colors.white,fontSize: 20.0)
                ),
        centerTitle: true,

        actions: [

          // Home Button
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: InkWell(
              onTap: () {},
              child: const Icon(Icons.home, size: 30.0,),
            ),
          ),

          // Switch between student and subject coordinator view Button : TODO: to be removed
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: InkWell(
                onTap: () {
                  if (currentUser['userType'] == UserType.subjectCoordinator){
                    setState(() {
                      currentUser['userType'] = UserType.student;
                    });
                  } else {
                    setState(() {
                      currentUser['userType'] = UserType.subjectCoordinator;
                    });
                  }
                },
                child: const Icon(Icons.sync_outlined, size: 30.0,),
              ),
            ),

          // Permission Settings Button
          if(currentUser['userType'] == UserType.subjectCoordinator)
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: InkWell(
              onTap: () {},
              child: const Icon(Icons.admin_panel_settings, size: 30.0,),
            ),
          ),

          // Notification Button
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: InkWell(
              onTap: () {},
              child: const Icon(Icons.notifications, size: 30.0,),
            ),
          ),

          // Avatar Button
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              onTap: () {
                setState(() {

                  if (stopwatch.isRunning && stopwatch.elapsedMilliseconds < 200) {
                    stopwatch.stop();
                  } else {
                    avatarIsPressed = true;
                  }
                });
              },
              child: CircleAvatar(
                backgroundColor: avatarBackgroundColor,
                child: const Text('LC', style: TextStyle(color: Colors.white)), // TODO: Make LC a variable, so that it changes depending on user's name
              ),
            ),
          ),
        ],

      ),

      body: Stack(
        children: [

          Row(
          children: [

            // Dashboard column 1
            SizedBox(
              width: 150.0,
              child: Navigation(
                openNewRequestForm: openNewRequestForm,
                setCurrentSubject: setCurrentSubject,
                currentUser: currentUser
              ),
            ),

            VerticalDivider(
              color: dividerColor,
              thickness: 3,
              width: 3,
            ),

            // Dashboard column 2
            SizedBox(
                width: 300.0,
                child: requestWidget = Requests(
                  getCurrentSubject: getCurrentSubjectCode,
                  openSubmittedRequest: openSubmittedRequest,
                  currentUser: currentUser,
                ),
            ),

            VerticalDivider(
              color: dividerColor,
              thickness: 3,
              width: 3,
            ),

            // Dashboard column 3
            Expanded(
              child: displayThirdColumn(),
              ),
            ],
          ),

          // Menu displayed when avatar is pressed
          if (avatarIsPressed)
          TapRegion(
            onTapOutside: (tap) {
              setState(() {
                avatarIsPressed = false;
                stopwatch.reset();
                stopwatch.start();
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, right: 15.0),
                child: Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Container(
                    width: 200,
                    height: 200,
                    color: menuColor,
                  ),
                ),
              ),
          ),
        ]
      ),
    );
  }
}