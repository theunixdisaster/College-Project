import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foo/screens/feed_icons.dart';
import 'package:foo/screens/models/post_model.dart';
import 'package:ionicons/ionicons.dart';
import 'dart:io';

class ImageUploadScreen extends StatelessWidget {
  final File mediaInserted;
  //mediaInserted is for uploaded image(Video)
  ImageUploadScreen({this.mediaInserted});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: EdgeInsets.only(top: 10.0),
                          width: double.infinity,
                          height: 465.0,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25),bottomRight: Radius.circular(25)),
                              image: DecorationImage(
                                //image: AssetImage(posts[0].imageUrl),
                                image: FileImage(mediaInserted),
                                fit: BoxFit.cover,
                              )),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10.0),
                      width: double.infinity,
                      height: 471.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.arrow_back),
                                      iconSize: 20.0,
                                      color: Colors.white,
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    Container(
                                      width: 30.0,
                                      height: 30.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black45,
                                            offset: Offset(0, 2),
                                            blurRadius: 6.0,
                                          ),
                                        ],
                                      ),
                                      child: CircleAvatar(
                                        child: ClipOval(
                                          child: Image(
                                            height: 50.0,
                                            width: 50.0,
                                            image: AssetImage(
                                                posts[0].authorImageUrl),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Feed.colon),
                                      color: Colors.white,
                                      onPressed: () => print('More'),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onDoubleTap: () => print('Like post'),
                                  child: Container(
                                    height: 330,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(.2),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    width: double.infinity,
                                    margin: EdgeInsets.fromLTRB(18, 10, 18, 5),
                                    child: AspectRatio(
                                      aspectRatio: 4 / 5,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black45,
                                              offset: Offset(0, 3),
                                              blurRadius: 8.0,
                                            ),
                                          ],
                                          image: DecorationImage(
                                            image: FileImage(mediaInserted),
                                            //AssetImage(posts[0].imageUrl),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    maxLength: 30,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    decoration: InputDecoration(
                      hintText: "Caption",
                      contentPadding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}