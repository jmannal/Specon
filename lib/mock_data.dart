import 'package:specon/user_type.dart';

const Map<String, dynamic> database = {
  'COMP30022': {
    'requests': [
      {'requestID': 1, 'submittedBy': 1, 'name': 'Alex', 'assessment': 'Project 1', 'status': 'approved'},
      {'requestID': 2, 'submittedBy': 1, 'name': 'Bob', 'assessment': 'Project 2', 'status': 'pending'},
      {'requestID': 3, 'submittedBy': 2, 'name': 'Aren', 'assessment': 'Final Exam', 'status': 'pending'},
    ],
    'typesOfRequest': {
      'Participation Waiver': {'fields': ['Class', 'Reason'], 'allowedToView': ['Tutor']},
      'Due date extension': {'fields': ['How long', 'Reason'], 'allowedToView': ['Tutor']},
      'Change tutorial': {'fields': ['From Class', 'To Class', 'Reason'], 'allowedToView': []},
      'Others': {'fields': ['What', 'Why'], 'allowedToView': []},
    },
    'assessments': [
      'All',
      'Project 1',
      'Project 2',
      'Final Exam',
      'Mid Semester Exam',
    ]
  }
};

List<Map<String, dynamic>> allRequests = [
  {'requestID': 1, 'submittedBy': 1, 'name': 'Alex', 'subject': 'COMP30023', 'assessment': 'Project 1', 'state': 'Un-assessed'},
  {'requestID': 2, 'submittedBy': 1, 'name': 'Bob', 'subject': 'COMP30019', 'assessment': 'Project 2', 'state': 'Un-assessed'},
  {'requestID': 3, 'submittedBy': 2, 'name': 'Aren', 'subject': 'COMP30022', 'assessment': 'Final Exam', 'state': 'Un-assessed'},
  {'requestID': 4, 'submittedBy': 1, 'name': 'Aden', 'subject': 'COMP30023', 'assessment': 'Mid Semester Exam', 'state': 'Un-assessed'},
  {'requestID': 5, 'submittedBy': 1, 'name': 'Lo', 'subject': 'COMP30020', 'assessment': 'Project 1', 'state': 'Un-assessed'},
  {'requestID': 6, 'submittedBy': 1, 'name': 'Harry', 'subject': 'COMP30019', 'assessment': 'Project 2', 'state': 'Un-assessed'},
  {'requestID': 7, 'submittedBy': 1, 'name': 'Drey', 'subject': 'COMP30022', 'assessment': 'Project 2', 'state': 'Un-assessed'},
  {'requestID': 8, 'submittedBy': 1, 'name': 'Brian', 'subject': 'COMP30023', 'assessment': 'Final Exam', 'state': 'Un-assessed'},
  {'requestID': 9, 'submittedBy': 1, 'name': 'David', 'subject': 'COMP30019', 'assessment': 'Project 1', 'state': 'Un-assessed'},
  {'requestID': 10, 'submittedBy': 1, 'name': 'Po', 'subject': 'COMP30022', 'assessment': 'Project 1', 'state': 'Un-assessed'},
  {'requestID': 10, 'submittedBy': 1, 'name': 'Po', 'subject': 'COMP30022', 'assessment': 'Project 1', 'state': 'Un-assessed'},
  {'requestID': 10, 'submittedBy': 1, 'name': 'Po', 'subject': 'COMP30022', 'assessment': 'Project 1', 'state': 'Un-assessed'},
];

const List<Map<String, String>> subjectList = [
  {'code': 'COMP10001', 'name': 'Foundations of Computing'},
  {'code': 'COMP10002', 'name': 'Foundations of Algorithms'},
  {'code': 'COMP20003', 'name': 'Algorithms and Data Structures'},
  {'code': 'COMP20005', 'name': 'Intro. to Numerical Computation in C'},
  {'code': 'COMP20007', 'name': 'Design of Algorithms'},
  {'code': 'COMP20008', 'name': 'Elements of Data Processing'},
  {'code': 'SWEN20003', 'name': 'Object Oriented Software Development'},
  {'code': 'COMP30013', 'name': 'Advanced Studies in Computing'},
  {'code': 'COMP30019', 'name': 'Graphics and Interaction'},
  {'code': 'COMP30020', 'name': 'Declarative Programming'},
  {'code': 'COMP30022', 'name': 'IT Project'},
  {'code': 'COMP30023', 'name': 'Computer Systems'},
  {'code': 'COMP30024', 'name': 'Artificial Intelligence'},
  {'code': 'COMP30026', 'name': 'Models of Computation'},
  {'code': 'COMP30027', 'name': 'Machine Learning'},
  {'code': 'SWEN30006', 'name': 'Software Modelling and Design'},
];

const Map<String, Map<String, List<String>>> typesOfRequest = {
  'Participation Waiver': {
    'fields': ['Class', 'Reason'],
    'allowedToView': ['Tutor']
  },
  'Due date extension': {
    'fields': ['How long', 'Reason'],
    'allowedToView': ['Tutor']
  },
  'Change tutorial': {
    'fields': ['From Class', 'To Class', 'Reason'],
    'allowedToView': []
  },
  'Others': {
    'fields': ['What', 'Why'],
    'allowedToView': []
  },
};

const List<String> basicFieldTitles = [
  'Given Name',
  'Last Name',
  'Email',
  'Student ID',
  'Subject'
];

const List<String> assessments = [
  'All assessment',
  'Project 1',
  'Project 2',
  'Final Exam',
  'Mid Semester Exam',
];

const List<String> requestStates = [
  'Un-assessed',
  'Approved',
  'Flagged',
  'Declined',
  'All state',
];

List<Map<String, dynamic>> allDiscussion = [
  {"discussionID": 1, "submittedBy": 1234, "name": 'Alex', "subject": "COMP30023", "assessment": "Project 1", "reason": "Pls I beg u", "type": "request"},
  {"discussionID": 2, "submittedBy": 23423, "name": 'Bob', "subject": "COMP30019", "assessment": "Project 2", "reason": "Plssssssss", "type": "request"},
  {"discussionID": 3, "submittedBy": 34232, "name": 'Aren', "subject": "COMP30022", "assessment": "Final Exam", "reason": "I dumb", "type": "request"},
  {"discussionID": 4, "submittedBy": 44234, "name": 'Aden', "subject": "COMP30023", "assessment": "Mid Semester Exam", "reason": "Pls I beg u asd;lfknalksdnfka;sdlkfn;alkdsnfka;sdlkfna;lksdnf;aldkfn;aldknf;alskdnf;alksdnf;alkdsnfa;lkdsfna;l", "type": "request"},
  {"discussionID": 5, "submittedBy": 5432, "name": 'Lo', "subject": "COMP30020", "assessment": "Project 1", "reason": "Pls I beg u", "type": "request"},
  {"discussionID": 6, "submittedBy": 6423, "name": 'Harry', "subject": "COMP30019", "assessment": "Project 2", "reason": "Pls I beeeeg u", "type": "request"},
  {"discussionID": 7, "submittedBy": 7432, "name": 'Drey', "subject": "COMP30022", "assessment": "Project 2", "reason": "Pls I beg u", "type": "request"},
  {"discussionID": 8, "submittedBy": 84234, "name": 'Brian', "subject": "COMP30023", "assessment": "Final Exam", "reason": "uwu", "type": "request"},
  {"discussionID": 9, "submittedBy": 9234, "name": 'David', "subject": "COMP30019", "assessment": "Project 1", "reason": "Pls I beg u", "type": "request"},
  {"discussionID": 10, "submittedBy": 10234, "name": 'Po', "subject": "COMP30022", "assessment": "Project 1", "reason": "Pls uuuu beg u", "type": "request"},
];

const Map<String, int> currentRequest = {'requestID': 1};

// permission.dart
const List<Map<String, dynamic>> users = [
  {'userID': 1, 'name': 'Alex', 'userType': UserType.subjectCoordinator},
  {'userID': 2, 'name': 'Tawfiq', 'userType': UserType.subjectCoordinator},
  {'userID': 3, 'name': 'Aden', 'userType': UserType.tutor},
  {'userID': 4, 'name': 'Brian', 'userType': UserType.tutor},
  {'userID': 5, 'name': 'Drey', 'userType': UserType.tutor},
  {'userID': 6, 'name': 'Jeremy', 'userType': UserType.tutor},
  {'userID': 7, 'name': 'Lucas', 'userType': UserType.tutor},
  {'userID': 8, 'name': 'Maddie', 'userType': UserType.student},
  {'userID': 9, 'name': 'Nathan', 'userType': UserType.student},
  {'userID': 10, 'name': 'Ollie', 'userType': UserType.student},
];

List<Map<String, dynamic>> permissionGroups = [
  {'group': 'Head Tutor', 'users': ['Alex'], 'permissions': ['Final Exam']},
  {'group': 'Tutor', 'users': ['Lucas'], 'permissions': ['Participation Waiver']},
  {'group': 'Lecturer', 'users': ['Tawfiq'], 'permissions': ['Due date extension']},
];

const List<String> typesOfPermissions = [
  "Project 1",
  "Project 2",
  "Final Exam",
  "Mid Semester Exam",
  "Participation Waiver",
  "Due date extension",
  "Change tutorial",
  "Others",
];

Map<String, dynamic> currentUser = {
  'userID': 2,
  'name': 'Harry',
  'userType': UserType.subjectCoordinator
};

const Map<String, dynamic> permGroup = {
  'group': 'Lecturer',
  'users': ['Tawfiq'],
  'permissions': ['Extension']
};