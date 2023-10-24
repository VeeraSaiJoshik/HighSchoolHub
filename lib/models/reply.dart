

class comment{
  String content;
  String email;
  DateTime? sentTime;
  comment({this.content="", this.email="", this.sentTime});
  Map toJson(){
    return {
      "content": this.content, 
      "email": this.email, 
      "sentTime": this.sentTime!.toString()
    };
  }
  void fromJson(Map data){
    content = data["content"];
    email = data["email"];
    sentTime = DateTime.parse(data["sentTime"]);
  }
}

class commentThread{
  comment? mainComment;
  List<comment> replies;
  List likes;
  commentThread({this.mainComment,this.replies = const [], this.likes = const []}){
    if(replies.length == 0) replies = [];
    if(likes.length == 0) likes = [];
    if(mainComment == null) mainComment = comment();
  }
  Map toJson(){
    List<Map> tempReplies = [];
    for(comment c in replies){
      tempReplies.add(c.toJson());
    }
    return {
      "mainComment": mainComment, 
      "likes": likes, 
      "replies": tempReplies
    };
  }
  void fromJson(Map data){
    print("we be getting the JSON data");
    print(data["replies"]);
    mainComment = comment();
    mainComment!.fromJson(data["mainComment"]);
    likes = data["likes"];
    List tempReplies = data["replies"];
    replies = [];
    for(Map dataTemp in tempReplies){
      comment tempComment = comment();
      tempComment.fromJson(dataTemp);
      replies.add(tempComment);
    }
  }
}