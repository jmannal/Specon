/// This class has all the functions relating to the database, this includes
/// adding data from the database, removing and fetching data from the database
///
/// Author: Jeremy Annal, Zhi Xiang Chan (Lucas)

import "package:cloud_firestore/cloud_firestore.dart";
import 'package:specon/models/request_type.dart';
import 'package:specon/models/subject_model.dart';
import 'package:specon/models/user_model.dart';
import 'package:specon/models/request_model.dart';

class DataBase {

  final _db = FirebaseFirestore.instance;

  static UserModel? user;

  /// Function that queries the users collection with an email and returns an user model
  Future<UserModel> getUserFromEmail(String emailToMatch) async {
    final usersRef = _db.collection("users");
    final query =
        await usersRef.where('email', isEqualTo: emailToMatch).get();

    final fetchedUser = query.docs[0];

    final userModel = UserModel(
      id: fetchedUser["id"],
      email: fetchedUser["email"],
      name: fetchedUser["name"],
      subjects: fetchedUser["subjects"],
      aapPath: fetchedUser["aap_path"],
      studentID: fetchedUser["student_id"]
    );

    user = userModel;
    return userModel;
  }

  /// Function that sets the student id on a student's document
  Future<void> setStudentID(String studentID) async {

    final usersRef = _db.collection("users");
    final query =
    await usersRef.where('email', isEqualTo: user!.email).get();

    final fetchedUser = query.docs[0];

    await fetchedUser.reference.update({'student_id': studentID});
    
  }

  /// Function that fetches the requests for a subject based on a user's role
  Future<List<RequestModel>> getRequests(UserModel user, SubjectModel subject) async {

    List<RequestModel> requests = [];

    if (subject.databasePath.isEmpty){
      return [];
    }

    // Subject Coordinator
    if (subject.roles[user.id] == 'subject_coordinator') {

      // Get subject's reference
      final requestsRef = await _db.doc(subject.databasePath).collection('requests').get();

      final requestsFromDB = requestsRef.docs;

      for(final request in requestsFromDB) {

        final assessmentRef = _db.doc(request['assessment'].path);
        late final RequestType assessmentFromDB;

        await assessmentRef.get().then((DocumentSnapshot documentSnapshot) {
          assessmentFromDB = RequestType(
            name: documentSnapshot['name'],
            type: '',
            id: request['assessment'].path
          );
        });

        final timeSubmitted = (request['time_submitted'] as Timestamp).toDate();

        requests.add(
          RequestModel(
            requestedBy: request['requested_by'],
            requestedByStudentID: request['requested_by_student_id'],
            reason: request['reason'],
            additionalInfo: request['additional_info'],
            assessedBy: request['assessed_by'],
            assessment: assessmentFromDB,
            state: request['state'],
            databasePath: request.reference.path,
            timeSubmitted: timeSubmitted
          )
        );
      }
    }

    // Student
    else if (subject.roles[user.id] == 'student') {

      // Query for student's requests from the subject
      final requestListFromDB = await _db
          .doc(subject.databasePath)
          .collection('requests')
          .where('requested_by_student_id', isEqualTo: user.studentID) // TODO:
          .get();


      for(final request in requestListFromDB.docs){

        final assessmentRef = _db.doc(request['assessment'].path);
        late final RequestType assessmentFromDB;

        await assessmentRef.get().then((DocumentSnapshot documentSnapshot) {
          assessmentFromDB = RequestType(
            name: documentSnapshot['name'],
            type: '',
            id: request['assessment'].path
          );
        });

        final timeSubmitted = (request['time_submitted'] as Timestamp).toDate();

        requests.add(
          RequestModel(
            requestedBy: request['requested_by'],
            reason: request['reason'],
            additionalInfo: request['additional_info'],
            assessedBy: request['assessed_by'],
            assessment: assessmentFromDB,
            state: request['state'],
            requestedByStudentID: request['requested_by_student_id'],
            databasePath: request.reference.path,
            timeSubmitted: timeSubmitted
          )
        );
      }
    }

    // TODO: for permission (Tutor, etc)
    else {
      return [];
    }

    // Sort by oldest requests on the top
    requests.sort((a, b) => a.timeSubmitted.compareTo(b.timeSubmitted));

    return requests;
  }

  /// Function that fetches a user's enrolled subjects
  Future<List<SubjectModel>> getEnrolledSubjects() async {
    List<SubjectModel> subjects = [];

    for (final subject in user!.subjects){

      DocumentReference docRef = FirebaseFirestore.instance.doc(subject.path);

      final assessments = await getAssessments(subject.path);

      await docRef.get().then((DocumentSnapshot documentSnapshot) {
        subjects.add(
          SubjectModel(
            name: documentSnapshot['name'],
            code: documentSnapshot['code'],
            roles: documentSnapshot['roles'],
            assessments: assessments,
            semester: documentSnapshot['semester'],
            year: documentSnapshot['year'],
            databasePath: subject.path
          )
        );
      });
    }
    return subjects;
  }

  /// Function that fetches the assessments of a subject
  Future<List<RequestType>> getAssessments(String subjectPath) async {
    List<RequestType> assessments = [];

    CollectionReference assessmentsRef = FirebaseFirestore.instance.doc(
        subjectPath).collection('assessments');

    QuerySnapshot querySnapshot = await assessmentsRef.get();

    for (final assessment in querySnapshot.docs){
      assessments.add(
        RequestType(
          name: assessment['name'],
          type: '', // TODO:
          id: assessment.reference.path
        )
      );
    }

    return assessments;
  }

  /// Function that adds a request onto the database
  Future<DocumentReference> submitRequest(UserModel user, SubjectModel subject, RequestModel request) async {

    // Get subject's reference
    final DocumentReference subjectRef = _db.doc(subject.databasePath);

    // Add request to subject's collection
    final DocumentReference requestRef = await subjectRef.collection('requests').add(request.toJson());
    
    await requestRef.update({'time_submitted': Timestamp.now()});

    return requestRef;
  }

  ///
  Future<List<Map<String, String>>> getDiscussionThreads(RequestModel request) async {

    DocumentReference docRef = FirebaseFirestore.instance.doc(request.databasePath);
    List<Map<String, String>> allDiscussions = [];

    // use it after deleting all past discussion
    final discussions = await docRef.collection('discussions').orderBy("timestamp").get();
    //final discussions = await docRef.collection('discussions').get();

    for (final discussion in discussions.docs) {
      allDiscussions.add(
        {//'assessment': discussion['assessment'],
          'text': discussion['text'],
          //'subject': discussion['subject'],
          'submittedBy': discussion['submittedBy'],
          'submittedByUserID': discussion['submittedByUserID'],
          'type': discussion['type'],
        }
      );
    }
    return allDiscussions;
  }

  ///
  Future<void> addNewDiscussion(RequestModel request, Map<String, String> newDiscussion) async {

    DocumentReference docRef = FirebaseFirestore.instance.doc(request.databasePath);
    newDiscussion['timestamp'] = DateTime.now().toString();
    await docRef.collection('discussions').add(newDiscussion);
  }

  /// Function that deletes a request from the database
  Future<void> deleteOpenRequest(RequestModel request) async {

    await FirebaseFirestore.instance.doc(request.databasePath).delete();
  }

}

///
Future<void> acceptRequest(RequestModel request) async {

  DocumentReference docRef = FirebaseFirestore.instance.doc(request.databasePath);

  await docRef.update({'state': 'Approved'});
}

///
Future<void> declineRequest(RequestModel request) async {

  DocumentReference docRef = FirebaseFirestore.instance.doc(request.databasePath);

  await docRef.update({'state': 'Declined'});
}

///
Future<void> flagRequest(RequestModel request) async {

  DocumentReference docRef = FirebaseFirestore.instance.doc(request.databasePath);

  await docRef.update({'state': 'Flagged'});
}
