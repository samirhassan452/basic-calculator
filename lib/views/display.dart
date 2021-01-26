import 'package:calculator/const.dart';
import 'package:calculator/services/calculator_provider.dart';
import 'package:calculator/services/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Display extends StatelessWidget {
  //final bool isDark;
  //final String result;
  //final TextEditingController calculatorController;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final theme = Provider.of<ThemeChanger>(context);
    final calculations = Provider.of<CalculatorProvider>(context);
    return Column(
      children: [
        TextField(
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 2,
          textAlign: TextAlign.end,
          style: TextStyle(
              color: secondaryDarkButtonColor, fontSize: width * 0.054),
          decoration: InputDecoration(
              border: InputBorder.none,
              //hintText: "1250/5+9",
              contentPadding: EdgeInsets.symmetric(
                  vertical: height * 0.03, horizontal: width * 0.04)),
          controller: calculations.calculationController,
          readOnly: true,
        ),
        Container(
          padding: EdgeInsets.only(
              bottom: width * 0.1, left: height * 0.035, right: height * 0.035),
          width: width,
          child: SizedBox(
            height: 30,
            child: Text(
              // if desplayedResult is null, then put ""
              calculations.desplayedResult ?? "",
              textAlign: TextAlign.end,
              style: TextStyle(
                  fontSize: width * 0.07,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.7,
                  color: theme.isDark
                      ? primaryLightButtonColor
                      : primaryDarkButtonColor),
            ),
          ),
        )
      ],
    );
  }
}
