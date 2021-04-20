
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat/socket.dart';
import 'package:hive/hive.dart';
import 'models.dart';
import 'dart:async';
import 'dart:convert';
import 'chat/listscreen.dart';


class JustForTest extends StatelessWidget {

  // final NotificationController controller = NotificationController();

  @override
  Widget build(BuildContext context) {
    return Renderer();
  
}
}


class Renderer extends StatefulWidget {



  Renderer({Key key}) : super(key:key);

  @override
  _RendererState createState() => _RendererState();
}

class _RendererState extends State<Renderer> {
   
  SharedPreferences prefs;

  //Creating a list of the existing threads in the hive 'Threads' box
  List threadList = Hive.box('Threads').values.toList();
  Stream stream;
  
  

  @override
  void initState(){
    super.initState();
    _setPrefs();
    
   
  }

  //Initializing shared_preference instance and setting the user name for current user.
  //To access the username throughout the project.
  void _setPrefs() async{
    prefs = await SharedPreferences.getInstance();
    prefs.setString('user', 'romal');
    print(prefs.getString('user'));
    
  }

  
 _chicanery(threadName,thread,data,) async{
    var box = Hive.box("Threads");
    await box.put(threadName,thread);
    thread.addChat(
    ChatMessage(
      message:data['message']['message'],
      senderName:data['message']['from'],
      time:DateTime.now(),
      id:data['message']['id'],
      ));
    thread.save();
  }

  Future _createThread(data) async{

    if(data=="None"){
      return null;
    }
    var threadBox = Hive.box('Threads');
    var me = prefs.getString('user');

    //Creating thread with the given data
    var thread = Thread(first:User(name:me),second:User(name:data['message']['from']));

    //Thread is named in the format "self_sender" eg:anna_deepika
    var threadName = me + '_' + data['message']['from'];

    //Checking if thread already exists in box, if exists, the new chat messaeg if added else new thread is created and saved to box.
    if(!threadBox.containsKey(threadName)){
      print("new_thread");
      print(data['message']['id']);

      await _chicanery(threadName,thread,data);
    }
    else{
      print("existing thread");
      print(data['message']['id']);
      var existingThread = threadBox.get(threadName);
      existingThread.addChat(
        ChatMessage(message:data['message']['message'],
        senderName:data['message']['from'],
        time:DateTime.now(),
        id:data['message']['id'],
        ));  
      existingThread.save();
    }

      List list = threadBox.values.toList();
      return list;
  }



_chicaneryForMe(threadName,thread,data,) async{
  var me = prefs.getString('user');
    var box = Hive.box("Threads");
    await box.put(threadName,thread);
    thread.addChat(
    ChatMessage(
      message:data['message']['message'],
      senderName:me,
      id:data['message']['id'],
      time:DateTime.now())
      );
    thread.save();
  }




  Future _createThreadForMe(data) async{
     if(data=="None"){
      return null;
    }
    var threadBox = Hive.box('Threads');
    var me = prefs.getString('user');

    //Creating thread with the given data
    var thread = Thread(first:User(name:me),second:User(name:data['message']['from']));

    //Thread is named in the format "self_sender" eg:anna_deepika
    var threadName = me + '_' + data['message']['to'];

    //Checking if thread already exists in box, if exists, the new chat messaeg if added else new thread is created and saved to box.
    if(!threadBox.containsKey(threadName)){
      print("new_thread");
      await _chicaneryForMe(threadName,thread,data);
    }
    else{
      print("existing thread");
      var existingThread = threadBox.get(threadName);
      existingThread.addChat(
        ChatMessage(message:data['message']['message'],
        senderName:me,
        id:data['message']['id'],
        time:DateTime.now())
        );  
      existingThread.save();
    }

      List list = threadBox.values.toList();
      return list;
  }
  
  //Function for putting the new thread into the database. Since it requires an async function. It returns nothing.
  //So that _createThread is not interrupted
//   _chicanery(threadName,thread,data,) async{
//     var box = Hive.box("Threads");
//     await box.put(threadName,thread);
//     thread.addChat(
//     ChatMessage(
//       message:data['message']['message'],
//       senderName:data['message']['from'],
//       id:int.parse(data['message']['id']),
//       time:DateTime.now())
//       );
//     thread.save();
//   }

//   Future _createThread(data) async{

//     if(data=="None"){
//       return null;
//     }
//     var threadBox = Hive.box('Threads');
//     var me = prefs.getString('user');

//     //Creating thread with the given data
//     var thread = Thread(first:User(name:me),second:User(name:data['message']['from']));

//     //Thread is named in the format "self_sender" eg:anna_deepika
//     var threadName = me + '_' + data['message']['from'];

//     //Checking if thread already exists in box, if exists, the new chat messaeg if added else new thread is created and saved to box.
//     if(!threadBox.containsKey(threadName)){
//       print("new_thread");
//       await _chicanery(threadName,thread,data);
//     }
//     else{
//       print("existing thread");
//       var existingThread = threadBox.get(threadName);
//       existingThread.addChat(
//         ChatMessage(message:data['message']['message'],
//         senderName:data['message']['from'],
//         id:int.parse(data['message']['id']),
//         time:DateTime.now())
//         );  
//       existingThread.save();
//     }

//       List list = threadBox.values.toList();
//       print(list);
//       return list;
//   }



// _chicaneryForMe(threadName,thread,data,) async{
//   var me = prefs.getString('user');
//     var box = Hive.box("Threads");
//     await box.put(threadName,thread);
//     thread.addChat(
//     ChatMessage(
//       message:data['message']['message'],
//       senderName:me,
//       time:DateTime.now())
//       );
//     thread.save();
//   }




//   Future _createThreadForMe(data) async{
//      if(data=="None"){
//       return null;
//     }
//     var threadBox = Hive.box('Threads');
//     var me = prefs.getString('user');

//     //Creating thread with the given data
//     var thread = Thread(first:User(name:me),second:User(name:data['message']['from']));

//     //Thread is named in the format "self_sender" eg:anna_deepika
//     var threadName = me + '_' + data['message']['to'];

//     //Checking if thread already exists in box, if exists, the new chat messaeg if added else new thread is created and saved to box.
//     if(!threadBox.containsKey(threadName)){
//       print("new_thread");
//       await _chicaneryForMe(threadName,thread,data);
//     }
//     else{
//       print("existing thread");
//       var existingThread = threadBox.get(threadName);
//       existingThread.addChat(
//         ChatMessage(message:data['message']['message'],
//         senderName:me,
//         id:int.parse(data['message']['id']),
//         time:DateTime.now())
//         );  
//       existingThread.save();
//     }

//       List list = threadBox.values.toList();
//       return list;
//   }
  

  void _updateChatStatus(int id,String name){
      String me = prefs.getString('user');
      String  threadName = me + '_' + name;
      var threadBox = Hive.box('Threads');
      var existingThread = threadBox.get(threadName);
      existingThread.updateChatStatus(id);
      existingThread.save();

  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: NotificationController.streamController.stream,
      builder: (context,snapshot){
      if(snapshot.hasData){
        print(snapshot.data);
        if(snapshot.connectionState==ConnectionState.active){
        var data = jsonDecode(snapshot.data);
            FutureOr threads;
             if(data.containsKey('received')){
                print(data);
                  _updateChatStatus(data['received'],data['name']);
                   return ChatListScreen(threads:threadList);
              }
              else if(data['message']['to']==prefs.getString('user')){
               
                print(data['message']['id']);
              threads = _createThread(data);
               NotificationController.sendToChannel(jsonEncode({'message': {
                    'received':data['message']['id']
                }})); 
                }
              else if(data['message']['from']==prefs.getString('user')){
               
                threads = _createThreadForMe(data);

              }
              return FutureBuilder(
                future: threads,
                builder: (context, snapshot) {
                  if(snapshot.connectionState==ConnectionState.done){
                      List threadList = snapshot.data;
                      print(threadList);
                      threadList.sort((a,b){
                                  return b.lastAccessed.compareTo(a.lastAccessed);
                                });
                    return ChatListScreen(
                        // controller: widget.controller,
                        threads:threadList
                      );
                  }
                  return ChatListScreen(
                    //  controller: widget.controller,
                    threads:threadList
                  );
                }
              );
        
      
        }
      }
      if(threadList.length>0){
        threadList.sort((a,b){
          return b.lastAccessed.compareTo(a.lastAccessed);
        });
      }
      return ChatListScreen(
            // controller: widget.controller,
            threads:threadList
          );
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return StreamBuilder(
  //     stream: NotificationController.streamController.stream,
  //     builder: (context,snapshot){
  //     if(snapshot.hasData){
  //       print(snapshot.data);
  //       if(snapshot.connectionState==ConnectionState.done){
  //         print("data" + snapshot.data);
  //       }
  //       if(snapshot.connectionState==ConnectionState.active){
  //       var data = jsonDecode(snapshot.data);
  //             FutureOr threads;
  //             if(data.containsKey('received')){
  //               print(data);
  //                 _updateChatStatus(data['received'],data['name']);
  //                  return ChatListScreen(threads:threadList);
  //             }
  //             else if(data['message']['to']==prefs.getString('user')){
  //              print(data['message']['id']);
  //             NotificationController.sendToChannel(jsonEncode({'message': {
  //                   'received':data['message']['id']
  //               }})); 
  //             threads = _createThread(data);
  //             print(threads);
  //               }
  //             else if(data['message']['from']==prefs.getString('user')){
               
  //               threads = _createThreadForMe(data);

  //             }
  //             return FutureBuilder(
  //               future: threads,
  //               builder: (context, snapshot) {
  //                 if(snapshot.connectionState==ConnectionState.active){
  //                   print(snapshot.data);
  //                 }
  //                 if(snapshot.connectionState==ConnectionState.done){
  //                     List threadlist = snapshot.data;
  //                     print(threadlist);
  //                     if(threadlist != null){
  //                       threadlist.sort((a,b){
  //                                 return b.lastAccessed.compareTo(a.lastAccessed);
  //                               });
  //                   return ChatListScreen(
  //                       // controller: widget.controller,
  //                       threads:threadList
  //                     );
  //                 }}
  //                 return ChatListScreen(
  //                   //  controller:Notification,
  //                   threads:threadList
  //                 );
  //               }
  //             );
        
      
  //       }
  //     }
  //     if(threadList.length>0){
  //       threadList.sort((a,b){
  //         return b.lastAccessed.compareTo(a.lastAccessed);
  //       });
  //     }
  //     return ChatListScreen(
  //           // controller: widget.controller,
  //           threads:threadList
  //         );
  //   });
  // }
}


















