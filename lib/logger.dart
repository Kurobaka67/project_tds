import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class FileOutput extends LogOutput {
  late File logFile;

  FileOutput() {
    _initLogFile();
  }

  void _initLogFile() {
    var downloadDirectory;
    //final externalStorageFolder = await getExternalStorageDirectory();
    //if (externalStorageFolder != null) {
      downloadDirectory = p.join('/storage/emulated/0', "Download");
    //}
    logFile = File('${downloadDirectory}/app.log');
  }

  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      logFile.writeAsStringSync('${DateTime.now()}: $line\n', mode: FileMode.append);
    }
  }
}

var logger = Logger(
  printer: PrettyPrinter(),
  output: FileOutput(),
);