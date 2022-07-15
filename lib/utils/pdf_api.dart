
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart';

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    String dir = "";
    if(Platform.isAndroid) {
      dir = (await getExternalStorageDirectory())!.path;
    } else if(Platform.isIOS) {
      dir = (await getApplicationDocumentsDirectory()).path;
    }

    final file = File('$dir/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }

  static Future deleteFile(File file) async {
    await file.delete();
  }
}