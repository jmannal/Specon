import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

final storage = FirebaseStorage.instance;
final storageRef = FirebaseStorage.instance.ref();

final documentsRef = storageRef.child("documents");

PlatformFile? pickedFile;

Future<bool> selectFile() async{
  final result = await FilePicker.platform.pickFiles(type: FileType.any, allowMultiple: false);
  if(result == null){
    return false;
  }
  pickedFile = result.files.first;
  print(pickedFile!.name);
  return true;
}

UploadTask uploadFile(int requestID) {
  final ref = documentsRef.child("${requestID.toString()}/${pickedFile!.name}");
  final fileBytes = pickedFile!.bytes; // on web app this is necessary
  return ref.putData(fileBytes!);
  uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
    switch (taskSnapshot.state) {
      case TaskState.running:
        final progress =
            100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
        print("Upload is $progress% complete.");
        break;
      case TaskState.paused:
        print("Upload is paused.");
        break;
      case TaskState.canceled:
        print("Upload was canceled");
        break;
      case TaskState.error:
      // Handle unsuccessful uploads
        break;
      case TaskState.success:
      // Handle successful uploads on complete
      // ...
        break;
    }
  });
}
