import 'package:calculator/const.dart';
import 'package:calculator/services/theme_provider.dart';
import 'package:calculator/views/display.dart';
import 'package:calculator/views/keypad.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //TextEditingController calculatorController;
  //bool isDark;
  //String result;
  @override
  void initState() {
    //calculatorController = TextEditingController();
    //isDark = false;
    //result = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return Scaffold(
        appBar: buildAppBar(theme),
        backgroundColor:
            theme.isDark ? primaryDarkThemeColor : primaryLightThemeColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Display(),
            KeyPad(),
          ],
        ));
  }

  AppBar buildAppBar(ThemeChanger theme) {
    return AppBar(
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          // setState(() {
          //   isDark = !isDark;
          // });
          theme.changeTheme();
        },
        child: Transform.rotate(
          angle: 135,
          child: Icon(
            theme.isDark ? Icons.wb_sunny : Icons.brightness_3_outlined,
            color: theme.isDark ? Colors.amber : primaryTextButtonColor,
          ),
        ),
      ),
      backgroundColor:
          theme.isDark ? primaryDarkThemeColor : primaryLightThemeColor,
    );
  }
}

/*
Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.amber)),
              padding: EdgeInsets.symmetric(
                vertical: 40,
              ),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Result",
                    contentPadding: EdgeInsets.only(right: 20)),
                controller: calculatorController,
                readOnly: true,
              ),
            ),
            
RaisedButton(
              onPressed: () {
                print(width);
                print(height);
                //calculatorController.text = "1" + calculatorController.text;
              },
              child: Text("1"),
            ),


StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        itemCount: 19,
        itemBuilder: (BuildContext context, int index) => new Container(
            color: primaryLightDarkButton,
            child: new Center(
              child: new CircleAvatar(
                backgroundColor: Colors.white,
                child: new Text('$index'),
              ),
            )),
        staggeredTileBuilder: (int index) =>
            new StaggeredTile.count(index == 18 ? 2 : 1, 1),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),

  bool checkIndex(int index) {
    if (index == 0 || index == 19)
      return true;
    else
      return false;
  }
*/
