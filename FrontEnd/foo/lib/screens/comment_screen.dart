import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foo/profile/profile_test.dart';
import 'package:foo/screens/feed_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../colour_palette.dart';

class CommentScreen extends StatefulWidget {
  final String postUrl;
  final int postId;
  final int heroIndex;
  CommentScreen({this.postUrl, this.postId, this.heroIndex});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen>
    with TickerProviderStateMixin {
  double positionedTopVal = 430;
  double containerHeight = 1000;
  AnimationController _controller;
  bool hasExpanded = false;
  bool isExpanded = false;
  GlobalKey _txtKey = GlobalKey();
  bool overflow = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    // detectHeight();
  }

  resizeContainer() {
    // _controller.isDismissed ? _controller.forward() : _controller.reverse();
    if (!hasExpanded) {
      print("not expanded");
      _controller.forward().whenComplete(() {
        setState(() {
          hasExpanded = true;
        });
      });
    } else {
      _controller.reverse().whenComplete(() => setState(() {
            hasExpanded = false;
          }));
    }
  }

  Container _commentField() => Container(
        width: MediaQuery.of(context).size.width,
        height: 71,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
            padding: EdgeInsets.fromLTRB(15, 12, 15, 10),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.fromRGBO(226, 235, 243, .7),
              ),
              child: Row(children: [
                Container(
                  width: 30,
                  height: 30,
                  margin: EdgeInsets.only(left: 5),
                  // padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      image: DecorationImage(
                        image: AssetImage("assets/images/user4.png"),
                        fit: BoxFit.cover,
                      )),
                ),
                Expanded(
                  child: TextField(
                    // controller: _commentController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: "Add a comment",
                      hintStyle: GoogleFonts.raleway(fontSize: 12),
                      contentPadding: EdgeInsets.fromLTRB(10, 5, 5, 15),
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                      suffix: InkWell(
                        child: Text("@",
                            style:
                                TextStyle(color: Colors.black, fontSize: 25)),
                        onTap: () {
                          // var cursor = _commentController.selection;
                          // start = cursor.start;
                          // end = cursor.end;
                          // showOverlay(context);
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(5),
                    // decoration: BoxDecoration(
                    //   color: Colors.white,
                    //   shape: BoxShape.circle,
                    // ),
                    child: IconButton(
                        icon: Icon(Ionicons.send, size: 16), onPressed: () {})),
              ]),
            )),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, 50),
          child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded, size: 16),
                    onPressed: () {
                      Navigator.pop(context, 4);
                    },
                  ),
                  IconButton(
                    icon: Icon(Feed.colon, size: 20),
                    onPressed: () {},
                  ),
                ],
              ))),
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height - 50,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 440,
              width: double.infinity,
              // margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(widget.postUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Profile(userId: 5),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      child: ClipOval(
                        child: Image(
                          height: 50.0,
                          width: 50.0,
                          image: AssetImage("assets/images/user3.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    // color: Colors.black.withOpacity(.3),
                    decoration: BoxDecoration(
                        // color: Colors.black.withOpacity(.3),
                        // borderRadius: BorderRadius.circular(20),
                        ),
                    child: Text(
                      "john_doe",
                      style: GoogleFonts.raleway(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height - 490,
              left: 0,
              child: Container(
                width: MediaQuery.of(context).size.width - 10,
                padding: EdgeInsets.fromLTRB(20, 0, 0, 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  // color: Colors.black.withOpacity(.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 69),
                          color: Colors.red.shade700,
                          height: 37,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Ionicons.heart,
                                    color: Colors.white, size: 22),
                                SizedBox(width: 5),
                                // SizedBox(width: 25),
                                Text(
                                  "342",
                                  style: TextStyle(
                                    fontSize: 11.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        // width: 75,
                        height: 45,
                        decoration: BoxDecoration(
                          // color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Ionicons.chatbox, color: Colors.white),
                              iconSize: 22.0,
                              onPressed: () {},
                            ),
                            Text(
                              "2342",
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                    Container(
                      // decoration: BoxDecoration(
                      //   color: Colors.black.withOpacity(.3),
                      //   borderRadius: BorderRadius.circular(15),
                      // ),
                      // height: 30,
                      child: Row(
                        children: [
                          Expanded(
                            child: AnimatedSize(
                                vsync: this,
                                duration: const Duration(milliseconds: 100),
                                child: GestureDetector(
                                  onTap: isExpanded
                                      ? () => setState(() {
                                            isExpanded = false;
                                          })
                                      : () {},
                                  child: new Container(
                                      constraints: isExpanded
                                          ? new BoxConstraints()
                                          : new BoxConstraints(
                                              maxHeight: 20.0,
                                            ),
                                      child: new Text(
                                        "It is good to love god sake of loving, but it is more important to liv ",
                                        softWrap: true,
                                        key: _txtKey,
                                        style: TextStyle(color: Colors.white),
                                        overflow: isExpanded
                                            ? TextOverflow.visible
                                            : TextOverflow.fade,
                                      )),
                                )),
                            // child: ExpandableText(
                            //   "It is good to love god for the sake of loving, but it is more important to liv ",
                            // ),
                          ),
                          !isExpanded
                              ? overflow
                                  ? GestureDetector(
                                      onTap: () {
                                        final RenderBox renderBoxRed = _txtKey
                                            .currentContext
                                            .findRenderObject();
                                        final sizeRed = renderBoxRed.size;
                                        print("SIZE of Red: $sizeRed");
                                        // setState(() => isExpanded = !isExpanded);
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text("More",
                                            style: GoogleFonts.lato(
                                              color: Colors.black,
                                              fontSize: 11,
                                            )),
                                      ),
                                    )
                                  : Container()
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedBuilder(
                animation: _controller,
                builder: (context, widget) {
                  var val;

                  val = _controller.value;

                  print(val);
                  return Positioned(
                    top: 440 - (408 * val),
                    // top: val == 1
                    //     ? hasExpanded
                    //         ? 30
                    //         : 430
                    //     : 430 - (400 * val),
                    child: Container(
                      height: MediaQuery.of(context).size.height * .9,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Color.fromRGBO(226, 235, 243, 1)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(val * 30),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                            child: Align(
                              heightFactor: .4,
                              alignment: Alignment.topCenter,
                              child: IconButton(
                                icon: Icon(hasExpanded
                                    ? Icons.arrow_drop_down_rounded
                                    : Icons.arrow_drop_up_rounded),
                                onPressed: resizeContainer,
                              ),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  CommentTile(),
                                  CommentTile(),
                                  CommentTile(),
                                  CommentTile(),
                                  CommentTile(),
                                  CommentTile(),
                                  CommentTile(),
                                  CommentTile(),
                                  CommentTile(),
                                  CommentTile(),
                                  CommentTile(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            Positioned(bottom: 0, child: _commentField()),
          ],
        ),
      ),
    );
  }
}

class CommentTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: ListTile(
        // tileColor: Colors.green,
        leading: Container(
          width: 41.0,
          height: 41.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                offset: Offset(0, 2),
                blurRadius: 6.0,
              ),
            ],
            image: DecorationImage(
              image: AssetImage("assets/images/user4.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          "John_doe",
          style: GoogleFonts.raleway(
              color: Color.fromRGBO(91, 75, 95, .7),
              fontWeight: FontWeight.w600,
              fontSize: 12),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text("Superb!",
              style: GoogleFonts.raleway(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              )),
        ),

        trailing: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(15)),
          child: IconButton(
            icon: Icon(
              Ionicons.heart_outline,
              size: 23,
            ),
            color: Colors.grey,
            onPressed: () => print('Like comment'),
          ),
        ),
      ),
    );
  }
}

class ExpandableText extends StatefulWidget {
  ExpandableText(this.text);

  final String text;
  bool isExpanded = false;

  @override
  _ExpandableTextState createState() => new _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText>
    with TickerProviderStateMixin<ExpandableText> {
  @override
  Widget build(BuildContext context) {
    return new Stack(children: <Widget>[
      Positioned(
          right: 5,
          top: -14,
          child: Container(
            height: 30,
            width: 50,
            alignment: Alignment.center,
            color: Colors.white,
            child: Text("More"),
          )),
      new AnimatedSize(
          vsync: this,
          duration: const Duration(milliseconds: 100),
          child: GestureDetector(
            onTap: () => setState(() => widget.isExpanded = !widget.isExpanded),
            child: new Container(
                constraints: widget.isExpanded
                    ? new BoxConstraints()
                    : new BoxConstraints(
                        maxHeight: 20.0,
                      ),
                child: new Text(
                  widget.text,
                  softWrap: true,
                  style: TextStyle(color: Colors.white),
                  overflow: widget.isExpanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                )),
          )),
    ]);
  }
}