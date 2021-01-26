import 'package:calculator/const.dart';
import 'package:calculator/logic/processor.dart';
import 'package:calculator/models/keys.dart';
import 'package:calculator/models/keysymbol.dart';
import 'package:calculator/services/calculator_provider.dart';
import 'package:calculator/services/theme_provider.dart';
import 'package:calculator/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalculatorKey extends StatelessWidget {
  final KeySymbol symbol;
  //final bool isDark;
  CalculatorKey({this.symbol});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final theme = Provider.of<ThemeChanger>(context);
    final calculations = Provider.of<CalculatorProvider>(context);
    return Expanded(
      flex: symbol == Keys.equals ? 2 : 1,
      child: GestureDetector(
        onTap: () {
          //MakeOperations operations = new MakeOperations(symbol);
          //Processor processor = new Processor();
          switch (symbol.type) {
            case KeyType.FUNCTION:
              //operations.calculateResult();
              calculations.handleFunction(symbol);
              break;
            case KeyType.INTEGER:
              //operations.numberPressed(symbol);
              calculations.handleInteger(symbol);
              break;
            case KeyType.OPERATOR:
              //operations.operatorPressed(symbol);
              calculations.handleOperator(symbol);
              break;
          }
        },
        child: CustomButton(
          height: height,
          btnText: symbol.value,
          btnColor: symbol == Keys.equals
              ? sharedColor
              : theme.isDark
                  ? checkSymbol(symbol)
                      ? secondaryDarkButtonColor
                      : primaryDarkButtonColor
                  : checkSymbol(symbol)
                      ? secondaryLightButtonColor
                      : primaryLightButtonColor,
          isFontBold: symbol.isInteger ? false : true,
          textColor: symbol == Keys.equals
              ? primaryLightButtonColor
              : theme.isDark
                  ? primaryLightButtonColor
                  : primaryTextButtonColor,
          borderColor: theme.isDark ? primaryDarkThemeColor : Colors.grey[300],
        ),
      ),
    );
  }

  bool checkSymbol(KeySymbol symbol) {
    if (symbol == Keys.add ||
        symbol == Keys.subtract ||
        symbol == Keys.multiply ||
        symbol == Keys.divide ||
        symbol == Keys.equals)
      return true;
    else
      return false;
  }
}
