class RequestType {
  String name; // not final because we can change name
  final String type;
  final String id;

  RequestType({
    required this.name,
    required this.type,
    required this.id,
  });

  // ...

  // fake request types
  static List<RequestType> importTypes() {
    return [
      RequestType(id: '01', name: 'Project 1', type: 'assignment extension'),
      RequestType(id: '02', name: 'Project 2', type: 'participation waiver'),
      RequestType(id: '03', name: 'Project 3', type: 'assignment extension'),
      RequestType(id: '04', name: 'Waiver', type: 'participation waiver'),
      RequestType(id: '05', name: 'Project 4', type: 'assignment extension'),
      RequestType(id: '06', name: 'Assignment 2', type: 'assignment extension'),
    ];
  }
}
