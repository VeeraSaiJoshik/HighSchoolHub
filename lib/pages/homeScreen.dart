import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/pages/AuthenticationPage.dart';
import 'package:highschoolhub/pages/home/homeScreen.dart';
import 'package:highschoolhub/pages/home/settingScreen.dart';
import 'package:highschoolhub/pages/sideBarWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Screen currentScreen = Screen.Home;
  void changeCurrentScreen(Screen newScreen){
    setState(() {
      currentScreen = newScreen;
    });
  }
  Widget getScreen(Screen cs){
    if(cs == Screen.Home){
      return HomeScreenWidget();
    }else{
      return SettingScreen();
    }
  }
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: SideBarWidget(currentScreen, changeCurrentScreen),
      body: Container(
        height: height,
        width: width,
        color: backgroundColor,
        child: Stack(
          children: [
            Opacity(
              opacity: 0.35,
              child: SizedBox(
                height: height,
                width: width,
                child: Image.asset(
                  "assets/images/backdrop.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            getScreen(currentScreen)
          ],
        ),
      ),
    );
  }
}
class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer();
}