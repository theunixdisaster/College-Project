import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'chat/listscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'models.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
// import 'models.g.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  

  //Registering the hive model adapters. Will change this to register the adapters for corresponding boxes only.
  //Eg:"Threads" box is the only box which uses ThreadAdpater
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ChatMessageAdapter());
  Hive.registerAdapter(ThreadAdapter());
  await Hive.openBox('Threads');
  runApp(MyApp());

}

class MyApp extends StatelessWidget {


  //Only one subscriber is allowed for a stream at a time. So it is initialized here.
  final Stream stream = IOWebSocketChannel.connect("ws://10.0.2.2:8000/ws/chat/").stream.asBroadcastStream();

  @override
  Widget build(BuildContext context) {
    final title = 'WebSocket Demo';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: Renderer(stream:stream)
    );
  }
}

class Renderer extends StatefulWidget {
  final Stream stream;

  Renderer({Key key,this.stream}) : super(key:key);

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
    stream = widget.stream;
  }

  //Initializing shared_preference instance and setting the user name for current user.
  //To access the username throughout the project.
  void _setPrefs() async{
    prefs = await SharedPreferences.getInstance();
    prefs.setString('user', 'romal');
    print(prefs.getString('user'));
    stream = widget.stream;
  }

  //Function for putting the new thread into the database. Since it requires an async function. It returns nothing.
  //So that _createThread is not interrupted
  _chicanery(threadName,thread,data) async{
    var box = Hive.box("Threads");
    await box.put(threadName,thread);
    thread.addChat(
    ChatMessage(message:data['message']['message'],
    senderName:data['message']['from'],
    time:DateTime.now()));
    thread.save();
  }

  _createThread(data){

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
      _chicanery(threadName,thread,data);
    }
    else{
      print("existing thread");
      var existingThread = threadBox.get(threadName);
      existingThread.addChat(
        ChatMessage(message:data['message']['message'],
        senderName:data['message']['from'],
        time:DateTime.now())
        );  
      existingThread.save();
    }

 
      return threadBox.values.toList();
    
   
    
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context,snapshot){
      if(snapshot.hasData){

        if(snapshot.connectionState==ConnectionState.active){
        var data = jsonDecode(snapshot.data);

        //Checking if the message is addressed to the user
        if(data['message']['user']==prefs.getString('user')){
          List threads;
          
        threads = _createThread(data);
        return ChatListScreen(
            stream:widget.stream,
            threads:threads
          );
        }
      
        }
      }
      return ChatListScreen(
            stream:widget.stream,
            threads:threadList
          );
    });
  }
}


// import 'package:flutter/foundation.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'dart:convert';
// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final title = 'WebSocket Demo';
//     return MaterialApp(
//       title: title,
//       home: MyHomePage(
//         title: title,
//         channel: IOWebSocketChannel.connect('ws://10.0.2.2:8000/ws/chat/lobby/'),
//       ),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   final String title;
//   final WebSocketChannel channel;

//   MyHomePage({Key key, @required this.title, @required this.channel})
//       : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   TextEditingController _controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Form(
//               child: TextFormField(
//                 controller: _controller,
//                 decoration: InputDecoration(labelText: 'Send a message'),
//               ),
//             ),
//             StreamBuilder(
//               stream: widget.channel.stream,
//               builder: (context, snapshot) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 24.0),
//                   child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
//                 );
//               },
//             )
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _sendMessage,
//         tooltip: 'Send message',
//         child: Icon(Icons.send),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }

//   void _sendMessage() {
//     print(widget.channel.protocol);
//     var data = jsonEncode({
//       'message':_controller.text
//     });
//     if (_controller.text.isNotEmpty) {
//       widget.channel.sink.add(data);
//     }
//   }

//   @override
//   void dispose() {
//     widget.channel.sink.close();
//     super.dispose();
//   }
// }