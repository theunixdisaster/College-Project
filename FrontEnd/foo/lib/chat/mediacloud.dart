import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foo/models.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart' as intl;

class MediaCloud extends StatelessWidget {
  final ChatMessage msgObj;
  final bool needDate;

  MediaCloud({this.msgObj, this.needDate});

  FutureOr convertEncodedString() async {
    var ext = msgObj.ext;
    var img64 = msgObj.base64string;
    Directory appDir = await getApplicationDocumentsDirectory();
    String path = appDir.path + '/images/' + msgObj.id.toString() + '.$ext';
    bool isPresent = await File(path).exists();
    if (!isPresent) {
      if (ext == null) {
        return;
      }

      print(ext);
      var bytes = base64Decode(img64);
      print(bytes);

      File(appDir.path + '/images/' + msgObj.id.toString() + '.$ext')
          .createSync(recursive: true);
      print(appDir.path + '/images/' + msgObj.id.toString() + '.$ext');

      File fle = File(path);
      await fle.writeAsBytes(bytes);
      print("writing done successfully to " + fle.path);
      return fle;
    }
    print("already exists");
    return File(path);
  }

  BoxDecoration _getDecoration() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [
              .3,
              1
            ],
            colors: [
              Color.fromRGBO(255, 143, 187, 1),
              Color.fromRGBO(255, 117, 116, 1)
            ]));
  }

  Row dateCloud() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding:EdgeInsets.symmetric(vertical:6,horizontal: 9),
          margin:EdgeInsets.symmetric(vertical:7),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            intl.DateFormat("d MMMM y").format(this.msgObj.time),
            style:GoogleFonts.openSans(color: Colors.white,fontSize: 11,fontWeight:FontWeight.w600)
            ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (this.needDate == true) ? dateCloud() : Container(),
        Row(
          mainAxisAlignment: (this.msgObj.isMe == true)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            FutureBuilder(
              future: convertEncodedString(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  print('snapshot data is here ');
                  print(snapshot.data);
                  return Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    width: 250,
                    height: 250,
                    decoration: _getDecoration(),
                    child: Image.file(
                      snapshot.data,
                      // color:Colors.white.withOpacity(.2),
                      fit: BoxFit.contain,
                    ),
                  );
                }
                return Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  height: 250,
                  width: 250,
                  decoration: _getDecoration(),
                  child: Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Colors.black,
                  )),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}