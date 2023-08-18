import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:highschoolhub/firebase_options.dart';
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


Future<void> main() async {
  databaseConnection = await createConnection();
  print(databaseConnection);
  await Supabase.initialize(
    url : "https://sadyzgmrtuzafigiufny.supabase.co", 
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNhZHl6Z21ydHV6YWZpZ2l1Zm55Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODkxODI2ODYsImV4cCI6MjAwNDc1ODY4Nn0.LuBK4FQs6umjhu_cAiV7AR2JgP6hiTgq1MrFXEXG65k",
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        useMaterial3: true,
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
