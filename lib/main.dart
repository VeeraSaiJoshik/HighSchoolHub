import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:highschoolhub/firebase_options.dart';
import 'package:highschoolhub/models/school.dart';
import 'package:highschoolhub/models/user.dart';
import 'package:highschoolhub/pages/AuthenticationPage.dart';
import 'package:highschoolhub/pages/SignUp.dart';
import 'package:highschoolhub/pages/SignUpScreen/createSchoolSpecificClass.dart';
import 'package:highschoolhub/pages/homeScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:postgres/postgres.dart';

late PostgreSQLConnection databaseConnection;

Future<PostgreSQLConnection> createConnection() async {
  final connection = PostgreSQLConnection(
    'db.sadyzgmrtuzafigiufny.supabase.co', // replace with your Supabase endpoint
    5432, // default PostgreSQL port
    'postgres', // replace with your Supabase database name
    username: "postgres",
    password: 'Rahgav_Vinu', // replace with your Supabase service role password
  );

  await connection.open();
  return connection;
}

Map<String, AppUser> allUsers = {};
Map<String, Map<String, schoolUserList>> schoolData = {};

Future<void> main() async {
  print("started");
  databaseConnection = await createConnection();
  print(databaseConnection);
  await Supabase.initialize(
    url : "https://sadyzgmrtuzafigiufny.supabase.co", 
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNhZHl6Z21ydHV6YWZpZ2l1Zm55Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODkxODI2ODYsImV4cCI6MjAwNDc1ODY4Nn0.LuBK4FQs6umjhu_cAiV7AR2JgP6hiTgq1MrFXEXG65k",
  );
  print("supabase intitialized");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  List<Map> data = await supaBase.from("user_auth_table").select();
  for(Map user in data){
    AppUser temp = AppUser();
    temp.fromJson(user);
    await temp.updateNetworkParameters();
    print("this is the network");
    print(temp.email);
    print(temp.network);
    allUsers[temp.email] = temp;
    print(allUsers[temp.email]!.network);
  }
  PostgreSQLResult schoolTables = await databaseConnection.query("SELECT table_name FROM information_schema.tables WHERE table_schema='public'");
  List<String> sqlQuery = [];
  for(int i = 0; i < schoolTables.length; i++) {
    if(["Classes", "Clubs", "Skills", "user_auth_table", "MentorPosts", "chats", "Posts"].contains(schoolTables[i][0]) == false){
      sqlQuery.add(schoolTables[i][0]);
    }
  }
  for(String query in sqlQuery){
    data = await supaBase.from(query).select();
    Map<String, schoolUserList> templist = {};
    for(Map schoolUser in data){
      print(schoolUser);
      schoolUserList tempUser = schoolUserList(studentGmail: schoolUser["student_gmail"], year : schoolUser["year"], grade : schoolUser["grade"]);
      templist[schoolUser["student_gmail"] as String] = tempUser;
    }
    schoolData[query] = templist;
  }
  runApp(MyApp());
}

final supaBase = Supabase.instance.client;
 
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        
      ),
      home: AuthenticationScreen(), 
      routes: {
        "SignUpScreen" : (context) => SignUpScreen(),
        "authenticationScreen" : (ctx) => AuthenticationScreen(), 
        "CreateSchoolSpecificClass" : (ctx) => CreateSchoolSpecificClass(), 
        "HomeScreen" : (context) => HomeScreen(),
      },
    );
  }
}
