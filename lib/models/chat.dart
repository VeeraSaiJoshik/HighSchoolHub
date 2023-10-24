
import 'package:highschoolhub/main.dart';
import 'package:highschoolhub/pages/AuthenticationPage.dart';

class Chat{
  String user1Email;
  String user2Email;
  // are they typing right now
  bool user1Live;
  bool user2Live;
  List<chatInstance> allChats;
  Chat({this.user1Email = "", this.user2Email = "", this.allChats = const [], this.user1Live = false, this.user2Live = false}){
    if(allChats.isEmpty) allChats = [];
  }
  void turnAllViewed(){
    for(chatInstance ci in allChats){
      if(ci.fromEmail != currentUser.email) ci.viewed = true;
    }
  }
  String getOtherPersonImage(){
    if(user1Email == currentUser.email){
      return allUsers[user2Email]!.image;
    }
    return allUsers[user1Email]!.image;
  }
  bool oppositeUserTyping(){
    if(user1Email == currentUser.email) return user2Live;
    return user1Live;
  }
  String getOtherPersonName(){
    if(user1Email == currentUser.email){
      return allUsers[user2Email]!.firstName + " " + allUsers[user2Email]!.lastName;
    }
    return allUsers[user1Email]!.firstName + " " + allUsers[user1Email]!.lastName;
  }
  Map toJson(){
    List<Map> tempAllChats = [];
    for(chatInstance c in allChats) tempAllChats.add(c.toJson());
    return {
      "user1Email" : user1Email, 
      "user2Email" : user2Email, 
      "allChats" : tempAllChats, 
      "user1Live" : user1Live, 
      "user2Live" : user2Live
    };
  }
  void fromJson(Map data){
    user1Email = data["user1Email"];
    user2Email = data["user2Email"];
    user1Live = data["user1Live"];
    user2Live = data["user2Live"];
    allChats = [];
    for(Map tempData in data["allChats"]){
      chatInstance temp = chatInstance();
      temp.fromJson(tempData);
      allChats.add(temp);
    }
  }
}

class chatInstance{
  String fromEmail;
  String content;
  DateTime? dateSent;
  bool viewed = false;
  chatInstance({this.fromEmail = "", this.content = "", this.dateSent}){
    if(dateSent == null) dateSent = DateTime.now();
  }
  Map toJson(){
    return {
      "fromEmail": fromEmail,
      "content": content, 
      "dateSent": dateSent.toString()
    };
  }
  void fromJson(Map data){
    fromEmail = data["fromEmail"];
    content = data["content"];
    dateSent = DateTime.tryParse((data["dateSent"]));
  }
}