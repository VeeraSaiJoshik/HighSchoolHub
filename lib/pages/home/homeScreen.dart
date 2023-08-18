import 'package:flutter/material.dart';

import '../../globalInfo.dart';
import '../AuthenticationPage.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({super.key});

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
                top: true,
                bottom: false,
                child: Container(
                  width: width,
                  child: Column(
                    children: [
                      Container(
                        height: height * 0.06,
                        width: width,
                        child: Row(
                          children: [
                            SizedBox(
                              width: width * 0.065,
                            ),
                            Builder(
                              builder: (context) {
                                return InkWell(
                                  onTap: (){
                                     Scaffold.of(context).openDrawer();
                                  },
                                  child: Container(
                                    height: height * 0.052,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: ImageIcon(
                                        AssetImage(
                                          "assets/images/menus.png",
                                        ),
                                        color: blue,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            ),
                            Expanded(child: SizedBox()),
                            Container(
                              height: height * 0.053, 
                              width: height * 0.053, 
                              decoration: BoxDecoration(
                                color: blue, 
                                border: Border.all(
                                  color: blue, 
                                  width: width * 0.01,
                                ),
                                 borderRadius: BorderRadius.all(
                                  Radius.circular(8)
                                 ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: Image.network(
                                  currentUser.image, 
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.065,
                            ),
                          ],
                        ),
                      ), 
                    ],
                  ),
                ));
  }
}