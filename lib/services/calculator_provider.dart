import 'package:calculator/models/keys.dart';
import 'package:calculator/models/keysymbol.dart';
import 'package:flutter/cupertino.dart';

////// calculator cases //////
/*
 1. 5/0 = Infinity -> cannot divide by zero
 2. 0/0 = NaN -> cannot divide by zero

 3. . = 0. // 5 + . = 5 + 0. -> and we need to assign numbers after . to calculate

 4. +, -, x, / = 0 +,-,x,/
 5. 0 +,-,x,/ and click on =, then 0 +,-,x,/ 0 = 0 -> assign _valA to _valB
 6. num, then click on = -> num

 7. +/- || % but _val='' || _val='0' || _val='0.0' and so on if _val has only zeros -> return nothing

 9. num% = num/100
 10. num1 +,-,x,/ num2 then click on % -> num2/100=res -> num1 +,-,x,/ res

 11. num +/- -> -num, -num +/- -> num
 12. num1 +,-,x,/ num2 then click on +/- -> -num2 -> num1 +,-,x,/ -num2, and if click on +/- agian -> num1 +,-,x,/ num2

 13. num1 +,-,x,/ num2, then click on +,-,x,/ -> calculate res, then assigned to num1 -> res/num1 +,-,x,/ 'back to case 5 if click on = or assign value to num2'
    but if res is case 1 or 2, then return nothing
*/

class CalculatorProvider extends ChangeNotifier {
  static KeySymbol _operator;
  static String _valA = '';
  static String _valB = '';
  static String _result;
  // check if we click on operator for the first time or not
  static bool _isFirstTimeClickedOperator = true;

  String desplayedResult;
  TextEditingController calculationController = new TextEditingController();

  refresh() {
    // equation will be like : 2 + 4
    calculationController.text = (_valA != '' ? _valA : '') +
        (_operator != null ? ' ' + _operator.value : '') +
        (_valB != '' ? ' ' + _valB : '');
  }

  handleInteger(KeySymbol symbol) {
    //calculationController.text += symbol.value;
    String val = symbol.value;
    // if operator is null, then we operate with _valA, else then we operate with _valB
    if (_operator == null) {
      _valA = (_valA == '') ? val : _valA + val;
      //print(_valA);
    } else {
      //print('result is ' + _result.toString());
      // if user calculate result, then result!=null, then click on any operation to calulate new result, then result=null
      // and add new numbers in _valB, cause last result added to _valA
      if (_result == null) {
        _valB = (_valB == '') ? val : _valB + val;
      }
      // but if user after calculating result click on any number and result!=null, then clear everything and call this function again
      else {
        _clear();
        handleInteger(symbol);
      }
      //print(_valB);
    }

    refresh();
  }

  handleOperator(KeySymbol symbol) {
    // if click on operator return without do anything
    //print("a " + _valA.toString());

    if (_valA == '0.') {
      return;
    } else {
      // if we click on operator but _valB=0., then not calculateResult
      if (_valB == '0.' && _operator != null) {
        return;
      }

      // if click on equal operator
      if (symbol == Keys.equals) {
        // in case of click = to calculate +/- of _valA, then need to display result
        // e.g. 2=2, but if 2+ then click on =, then move to next if
        if (_valA != '' && _operator == null) {
          desplayedResult = _valA;
          notifyListeners();
        }
        // if equation is 5+ and click on =, then _valB=_valA to be 5+5=10
        else if (_valB == '' && _operator != null) {
          _valB = _valA;
        }
        // make operator variable true to calculate result from beginning
        _isFirstTimeClickedOperator = true;
        // if click on equal operator but _valB is 0 do nothing else calculate result
        return _valB == '' ? null : _calculateResult();
      }
      // if click on equal operator and click again on another operator then put old result to _valA and calculate new result on old
      // this called only if we click on equal operator not click on another new operator
      // cause if we click on new operator make new operation on result
      // then, we called _condense(), so _result will be null and condition not true
      if (_result != null) {
        _condense();
      }

      print(_operator);

      // if we make operation for the first time or click on clear operator
      if (_isFirstTimeClickedOperator == true) {
        // if we click on operator and _valA = '', then assign '0' to _valA
        if (_valA == '') {
          _valA = '0';
        }

        // assign symbol "operator" to _operator variable
        _operator = symbol;
        // make the variable false to go out from this condition
        _isFirstTimeClickedOperator = false;
        // call refresh() to show equation
        refresh();
        // return to go out from this function
        return;
      }
      // if we don't make operation for first time
      // _valB != '' cause user can click on + then + then + and so on, so we don't need to calculate result untill _valB != '0'
      if ((_isFirstTimeClickedOperator == false) && _valB != '') {
        // if we click on 1+1 then click on any operator agian, then firstly calculate result of first equation
        _calculateResult();
        // secondly cal _condense to put result in _valA and calculate (new number with new operator) on _valA "old result"
        _condense();
        // thirdly, we need _operator!= null, so we assign symbol "new operator" to _operator variable
        _operator = symbol;

        refresh();
        return;
      }

      // if we click on operator and click again on another operator but _valB=''
      // if _valB!='' then calculate equation and put result in _valA and _operator=newOperator to make a new calculation
      if ((_isFirstTimeClickedOperator == false) && _valB == '') {
        // assign symbol "new operator" to _operator variable
        _operator = symbol;

        refresh();
        return;
      }
    }
  }

  handleFunction(KeySymbol symbol) {
    Map<KeySymbol, dynamic> table = {
      Keys.clear: () => _clear(),
      Keys.sign: () => _sign(),
      Keys.percent: () => _percent(),
      Keys.decimal: () => _decimal(),
    };

    table[symbol]();

    symbol != Keys.clear
        ? refresh()
        : null; // to don't show clear symbol in equation
  }

  _calculateResult() {
    // if we click on equal operator or we need to calculate result but operator is null or _valB is '0', then return without do anything
    if (_operator == null || _valB == '') {
      print("non");
      return;
    }

    // table to map first number, operator and second number to one of these operations
    Map<KeySymbol, dynamic> table = {
      Keys.divide: (a, b) => (a / b),
      Keys.multiply: (a, b) => (a * b),
      Keys.subtract: (a, b) => (a - b),
      Keys.add: (a, b) => (a + b)
    };
    // calculate equation from table, then back result to tempResult, it will be like 2.0
    double tempResult =
        table[_operator](double.parse(_valA), double.parse(_valB));

    // we need to make desplayedResult has 2 decimal to be 0.0000
    // round number of precision after the decimal point to accept only 4 digits, -> 0.0000
    String str = tempResult.toStringAsFixed(4);
    // convert tempResult to string
    //String str = tempResult.toString();

    print("temp res : " + str);

    // print(_valA);
    // print(_operator);
    // print(_valB);

    // to remove dot and 0 after it e.g. "15.0" -> "15" || "15." -> "15"
    while ((str.contains('.') && str.endsWith('0')) || str.endsWith('.')) {
      str = str.substring(0, str.length - 1);
    }

    // desplayedResult : this will be desplayed on screen
    // _result : we operate with this
    // assign str after remove '.' to desplayedResult and _result
    desplayedResult = _result = str;

    // we need to set desplayedResult='Cannot divide by zero' instead of 'Infinity' || 'NaN'
    if (desplayedResult == 'Infinity' ||
        desplayedResult == 'NaN' ||
        desplayedResult == '-0') {
      // if we have 0 x -6 -> -0, but there is no negative zero, so we check if result='-0'
      desplayedResult = desplayedResult == "-0" ? "0" : "Cannot divide by zero";
    }

    //print(_result);
    // check if we divide 0/0=NaN or 5/0=Infinity, and after that click on operator, then assign '0' to _valA
    // and if  0 x -6 = -0, then assign 0 to _result cause if we need to make a new operation, then assign 0 to _valA
    if (_result == 'Infinity' || _result == 'NaN' || _result == '-0') {
      _result = '0';
    }

    refresh();
    // to notify desplayedResult that the value was changed
    notifyListeners();
  }

  _sign() {
    // check if we click on '+/-' but _result is Infinity || NaN, then don't make anything
    if (_result == 'Infinity' || _result == 'NaN') {
      return;
    }
    // if we click on '+/-' operator but _result is null
    if (_result == null) {
      // if we click on _valB but it doesn't equal '0' cause there is no "negative 0"
      // and also check if _valB!=anyNumber, then cannot add +/- cause we cannot add +/- to 0
      if ((_valB != '' && _valB != '0.') &&
          _valB != '0' &&
          _checkIfHasNumber(_valB)) {
        // if _valB has - e.g. -2 and click on '-' operator again, then remove '-' from _valB
        // else add '-' to _valB
        _valB = (_valB.contains('-') ? _valB.substring(1) : '-' + _valB);
        //calculationController.text = _valB;
      } else if ((_valA != '' && _valA != '0.') &&
          _valA != '0' &&
          _checkIfHasNumber(_valA) &&
          _operator == null) {
        // if _valA has - e.g. -2 and click on '-' operator again, then remove '-' from _valA
        // else add '-' to _valA
        _valA = (_valA.contains('-') ? _valA.substring(1) : '-' + _valA);
        //calculationController.text = _valA;
      }
    } else {
      // if _result != null, and click on '-' operator, then add '-' to _result
      _result = (_result.contains('-') ? _result.substring(1) : '-' + _result);
      // assign _result to desplayedResult to show new value on screen
      desplayedResult = _result;
      // call _condense2() to make new operation on converted result but without make _result=null to don't go on first condition
      _condense2();

      notifyListeners();
    }

    refresh();
  }

  // calculate percentage of number if we click on '%' operator
  String calcPercent(String x) => (double.parse(x) / 100).toString();

  _percent() {
    // check if we click on '%' but _result is Infinity || NaN, then don't make anything
    if (_result == 'Infinity' || _result == 'NaN') {
      return;
    }
    // if we click on '%' operator but _result=null
    if (_result == null) {
      // if we click on '%' operator to make percentage on _valB
      // and if _valB get it's percent one time, it will not get it's percent again, so we add contains('.') method
      if (_valB != '' && !_valB.contains('.')) {
        _valB = calcPercent(_valB);
      }
      // if we click on '%' operator to make percentage on _valA
      else if (_valA != '' && !_valA.contains('.') && _operator == null) {
        _valA = calcPercent(_valA);
        // if (_operator == null) {
        //   desplayedResult = _valA;
        // }
      }
    }
    // if we click on '%' operator but _result != null
    else {
      // then perform percentage operator on _result
      _result = calcPercent(_result);
      // show the new result on desplayed screen
      desplayedResult = _result;

      // put new result on _valA, make _valB='0', operator=null and don't make _result=null to don't go on first condition
      _condense2();
    }
    notifyListeners();
  }

  _decimal() {
    // if we calculate result, then result is not null, but if we click on any operator to calculate new operation, then result=null
    if (_result == null) {
      // if we click on '.' we have 2 cases
      // first : if _operator == null, then we are in left operand which is _valA
      // second : if _operator != null, then we are in right operand which is _valB
      if (_operator == null) {
        // user can click on decimal sign many times, so we need to check if _valA not contains this sign, then add it, otherwise not add
        // in case of _valA == '0' or any value, then _valA = 0/value
        if (!_valA.contains('.')) {
          _valA = _valA == '' ? '0' + '.' : _valA + '.';
        }
      } else {
        //print("not null");
        if (!_valB.contains('.')) {
          _valB = _valB == '' ? '0' + '.' : _valB + '.';
        }
      }
      // but if we calculate result, then user click on decimal sign, then result!=null, then clear everything and call this function again
    } else {
      _clear();
      _decimal();
    }

    /*
              // if we click on '.' we have 2 cases
              // first : if _valB='0', and click on '.', and click on 2 then _valB will be '0.2'
              // second : if _valB=2 and click on '.' and click on 2, then _valB will be '2.2'
              if ((_valB != '0' && !_valB.contains('.') && _operator != null)) {
                print("enterered");
                _valB = _valB + '.';
          
                //calculationController.text = _valB;
              } else if ((_valA != '0' && !_valA.contains('.'))) {
                print("enterered2");
                if (_operator == null) {
                  _valA = _valA + '.';
                } else {
                  _valB = _valB + '.';
                }
          
                //calculationController.text = _valA;
              }
            
               else if ((_valB == '0' && _valA == '0')) {
                _valA = _valA + '.';
              }
              else if ((_valB == '0' && _valA != '0')) {
                _valA = _valA + '.';
              }
               */
    refresh();
  }

  // to put old result in first operand and add next calculation to last result
  _condense() {
    _valA = _result;
    _valB = '';
    _result = _operator = null;
  }

  // like the _condense without _result
  _condense2() {
    _valA = _result;
    _valB = '';
    _operator = null;
  }

  _clear() {
    _result = desplayedResult = _operator = null;
    _valA = _valB = '';
    _isFirstTimeClickedOperator = true;
    calculationController.clear();

    notifyListeners();
  }

  bool _checkIfHasNumber(String val) {
    int flag = 0;
    if (val.contains('1') ||
        val.contains('2') ||
        val.contains('3') ||
        val.contains('4') ||
        val.contains('5') ||
        val.contains('6') ||
        val.contains('7') ||
        val.contains('8') ||
        val.contains('9')) {
      flag++;
    }

    return flag > 0 ? true : false;
  }
}
