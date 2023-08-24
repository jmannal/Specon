/// The requests part of the [Dashboard] page.
///
/// Shows all requests in a list. These are submitted requests for students
/// and received requests for tutors and subject coordinators.

import 'package:flutter/material.dart';

import '../dashboard_page.dart';

class Requests extends StatefulWidget {
  const Requests({Key? key}) : super(key: key);

  @override
  State<Requests> createState() => _RequestsState();
}

enum FilterType {subject, assignment}
List<String> filterSelections = [
  "All",
  "Project 1",
  "Project 2",
  "Final Exam",
  "Mid Semester Exam",
];

class _RequestsState extends State<Requests> {

  final topBarColor = const Color(0xFF385F71);
  final filterContainerColor = Colors.white10;
  final dividerColor = Colors.white30;
  final mainBodyColor = const Color(0xFF333333);
  final requestColor = const Color(0xFFD4D4D4);
  final ScrollController _scrollController = ScrollController();

  // for testing
  List<Map<String, dynamic>> allRequests = [
    {"ID": 1, "name": 'Aden', "subject": "COMP30023", "type": "Project 1"},
    {"ID": 2, "name": 'Brian', "subject": "COMP30024", "type": "Project 1"},
    {"ID": 3, "name": 'Charlie', "subject": "COMP30024", "type": "Project 1"},
    {"ID": 4, "name": 'Drey', "subject": "COMP30024", "type": "Project 1"},
    {"ID": 5, "name": 'Eve', "subject": "COMP30024", "type": "Project 1"},
    {"ID": 6, "name": 'Fred', "subject": "COMP30024", "type": "Project 1"},
    {"ID": 7, "name": 'Gigi', "subject": "COMP30024", "type": "Project 1"},
    {"ID": 8, "name": 'Helen', "subject": "COMP30024", "type": "Project 1"},
    {"ID": 9, "name": 'Ivan', "subject": "COMP30024", "type": "Project 1"},
    {"ID": 10, "name": 'Jeremy', "subject": "COMP30024", "type": "Project 1"},
  ];

  // should get information from canvas
  // List<DropdownMenuItem<String>> filterSelections = [
  //   DropdownMenuItem<String>(child: Text("All"), value: "All",),
  //   DropdownMenuItem<String>(child: Text("Project 1"), value: "Project 1",),
  //   DropdownMenuItem<String>(child: Text("Project 2"), value: "Project 2",),
  //   DropdownMenuItem<String>(child: Text("Final Exam"), value: "Final Exam",),
  //   DropdownMenuItem<String>(child: Text("Mid Semester Exam"), value: "Mid Semester Exam",),
  // ];

  List<Map<String, dynamic>> _foundRequests = [];
  List<Map<String, dynamic>> _filtered_S_Requests = [];
  List<Map<String, dynamic>> _filtered_A_Requests = [];

  @override
  void initState() {
    _foundRequests = allRequests;
    _filtered_S_Requests = allRequests; // 1st layer filter, Subject
    _filtered_A_Requests = allRequests; // 2nd layer filter, Assignment
    super.initState();
  }
  // function that updates _foundRequests when search, search in 2nd layer filter
  void _searchRequest(String searchString){
    List<Map<String, dynamic>> result = [];
    if(searchString.isEmpty) {
      result = _filtered_A_Requests;
    }else{
      // apply search logic, should change later or not?
      result = _filtered_A_Requests.where((request) =>
          request['name'].toLowerCase().contains(searchString.toLowerCase())).toList();
    }
    setState(() {
      _foundRequests = result;
    });
  }
  // filter out requests whenever we change filter type
  void filterCallback(String value, FilterType type){
    List<Map<String, dynamic>> result = [];

    if (value != "All") {
      if(type == FilterType.assignment){
        result = _filtered_S_Requests.where((request) =>
            request['type'].contains(value)).toList();
        _filtered_A_Requests = result;
      }
      if(type == FilterType.subject){
        // should get called in dashboard (selection is in first column)
      }
    }else{
      if(type == FilterType.assignment){
        result = _filtered_S_Requests.where((request) =>
            request['type'].contains("")).toList();
        _filtered_A_Requests = result;
      }
      if(type == FilterType.subject){
        result = allRequests.where((request) =>
            request['subject'].contains("")).toList();
        _filtered_S_Requests = result;
      }
    }
    setState(() {
      _foundRequests = result;
    });
  }

  String dropdownValue = filterSelections.first;
  @override
  Widget build(BuildContext context) {

      return Scaffold(
        body: Column(
          children: [
            // search bar is here
            Padding(

              padding: const EdgeInsets.only(top: 7.0, bottom: 5.0),
              child: SizedBox(

                height: 45.0,
                child: TextField(

                  onChanged: (value) => _searchRequest(value),

                  decoration: InputDecoration(

                    labelText: 'Search',
                    labelStyle: const TextStyle(color: Colors.white),
                    suffixIcon: const Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: mainBodyColor,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: mainBodyColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: topBarColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Divider(
              color: dividerColor,
              thickness: 3,
              height: 1,
            ),

            Container(
              decoration: BoxDecoration(color: filterContainerColor),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text(
                      'Filter',
                      style: TextStyle(
                      color: Colors.deepOrange,
                      ),
                    ),
                    onPressed: () {/* ... */},
                  ),
                ],
              )
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Divider(
                color: dividerColor,
                thickness: 3,
                height: 1,
              ),
            ),

            Expanded(
              // viewing all request
              child: RawScrollbar(
                controller: _scrollController,
                thumbColor: Colors.white38,
                radius: const Radius.circular(20),
                thickness: 5,
                child: ListView.builder(
                  itemCount: _foundRequests.length,
                  controller: _scrollController,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: InkWell(
                      onTap: () async {
                        // TODO: Get request from database
                      },
                      child: Card(
                        // color: requestColor,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(top: 10),
                              margin: const EdgeInsets.only(top: 10),
                              // request first row
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const SizedBox(width: 4),
                                  const Icon(Icons.album, size: 20.0),
                                  const SizedBox(width: 12),
                                  Text(_foundRequests[index]["name"]),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10, bottom: 10),
                              // bottom row
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 const SizedBox(width: 8),
                                 Text(_foundRequests[index]["type"]),
                                  const SizedBox(width: 8),
                                  const Text('4h'),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
}