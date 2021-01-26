import 'package:calculator/models/keys.dart';
import 'package:calculator/models/keysymbol.dart';
import 'package:calculator/services/calculator_provider.dart';

class Processor {
  static KeySymbol _operator;
  static String _valA = '0';
  static String _valB = '0';
  static String _result;
  static String _equation;
  static bool _isFirstTime = true;

  refresh() {
    _equation = _valA +
        (_operator != null ? ' ' + _operator.value : '') +
        (_valB != '0' ? ' ' + _valB : '');
  }

  handleInteger(KeySymbol symbol) {
    //calculationController.text += symbol.value;
    String val = symbol.value;
    if (_operator == null) {
      _valA = (_valA == '0') ? val : _valA + val;
      print(_valA);
    } else {
      _valB = (_valB == '0') ? val : _valB + val;
      print(_valB);
    }

    refresh();
  }

  handleOperator(KeySymbol symbol) {
    if (symbol == Keys.equals) {
      _isFirstTime = true;
      return _calculateResult();
    }
    if (_result != null) {
      _condense();
    }
    if (_valA == '0') {
      return;
    }

    if (_isFirstTime == true) {
      print("h");
      _operator = symbol;
      _isFirstTime = false;

      refresh();
      return;
    }
    if (_isFirstTime == false) {
      print("hh");
      _calculateResult();
      _condense();
      _operator = symbol;

      refresh();
      return;
    }

    //calculationController.text += symbol.value;
  }

  handleFunction(KeySymbol symbol) {
    Map<KeySymbol, dynamic> table = {
      Keys.clear: () => _clear(),
      Keys.sign: () => _sign(),
      Keys.percent: () => _percent(),
      Keys.decimal: () => _decimal(),
    };

    table[symbol]();

    symbol != Keys.clear ? refresh() : null;
  }

  _calculateResult() {
    if (_operator == null || _valB == '0') {
      print("non");
      return;
    }

    Map<KeySymbol, dynamic> table = {
      Keys.divide: (a, b) => (a / b),
      Keys.multiply: (a, b) => (a * b),
      Keys.subtract: (a, b) => (a - b),
      Keys.add: (a, b) => (a + b)
    };
    double result2 = table[_operator](double.parse(_valA), double.parse(_valB));
    String str = result2.toString();

    // print(_valA);
    // print(_operator);
    // print(_valB);

    // to remove dot and 0 after it e.g. "15.0" -> "15"
    while ((str.contains('.') && str.endsWith('0')) || str.endsWith('.')) {
      str = str.substring(0, str.length - 1);
    }

    _result = str;

    print(_result);

    refresh();
    //notifyListeners();
  }

  _sign() {
    if (_valB != '0') {
      _valB = (_valB.contains('-') ? _valB.substring(1) : '-' + _valB);
      //calculationController.text = _valB;
    } else if (_valA != '0') {
      _valA = (_valA.contains('-') ? _valA.substring(1) : '-' + _valA);
      //calculationController.text = _valA;
    }
    refresh();
  }

  String calcPercent(String x) => (double.parse(x) / 100).toString();

  _percent() {
    if (_valB != '0' && !_valB.contains('.')) {
      _valB = calcPercent(_valB);
    } else if (_valA != '0' && !_valA.contains('.')) {
      _valA = calcPercent(_valA);
    }
  }

  _decimal() {
    if ((_valB != '0' && !_valB.contains('.')) ||
        (_valB == '0' && _valA != '0')) {
      _valB = _valB + '.';
      //calculationController.text = _valB;
    } else if ((_valA != '0' && !_valA.contains('.')) ||
        (_valA == '0' && _valB == '0')) {
      _valA = _valA + '.';
      //calculationController.text = _valA;
    }
    refresh();
  }

  // to put old result in first operand and add next calculation to last result
  _condense() {
    _valA = _result;
    _valB = '0';
    _result = _operator = null;
  }

  _clear() {
    _result = _operator = null;
    _valA = _valB = "0";
    _isFirstTime = true;
    //calculationController.clear();

    //notifyListeners();
  }
}
