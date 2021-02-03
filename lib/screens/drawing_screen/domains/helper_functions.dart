import 'dart:io';

import 'dart:typed_data';


Future<void> writeToFile(ByteData data, String path) {
  final buffer = data.buffer;
  return File(path).writeAsBytes(
      buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}


String eliminateFileDuplicate(path,scribbleDir,filename){

  final originalName = filename;
  bool exists =
      FileSystemEntity.typeSync(path) != FileSystemEntityType.notFound;
  int tag = 1;

  while (exists) {
    filename = '${originalName}_$tag';
    path = '$scribbleDir$filename.png';
    exists = FileSystemEntity.typeSync(path) != FileSystemEntityType.notFound;
    tag++;
  }

  return filename;
}

Future<String> createDir(path,dirName) async {
  final scribbleDir = Directory('$path/$dirName/');
  if (await scribbleDir.exists() == false) {
    await scribbleDir.create(recursive: true);
  }
  return scribbleDir.path;
}