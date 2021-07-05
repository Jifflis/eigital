
import 'package:bloc/bloc.dart';
import 'package:eigital_exam/cubit/calculator_state.dart';
import 'package:flutter/cupertino.dart';

class CalculatorCubit extends Cubit<CalculatorState> {
  CalculatorCubit() : super(CalculatorResponse());

  TextEditingController controller = TextEditingController();

  /// It will compute the PMDAS
  /// and emit the state to notify the listeners
  ///
  void compute(String data){
    try{
      print(_calculatePmdas(data));
      emit(CalculatorResponse(result:_calculatePmdas(data)));
    }catch(_){
      emit(CalculatorResponse(result:'',error:'Invalid data'));
    }
  }

  void clearResult(){
    emit(CalculatorResponse(result:_calculatePmdas('')));
  }

  /// Calcualte the PMDAS
  ///
  String _calculatePmdas(String val) {
    while (val.contains('(')) {
      val = _calculatePerenthesis(val);
    }
    return _calculateMdas(val);
  }

  /// Calculate the MDAS
  ///
  String _calculateMdas(String val) {
    while (val.contains('*')) {
      val = _calculate(val, '*');
    }
    while (val.contains('/')) {
      val = _calculate(val, '/');
    }
    while (val.contains('+')) {
      val = _calculate(val, '+');
    }
    while (val.contains('-')) {
      val = _calculate(val, '-');
    }
    return val;
  }

  /// This will calculate the data inside the most inner parenthesis
  ///
  String _calculatePerenthesis(String val) {
    int indexFrom = 0;
    int indexTo = 0;
    String answer = '';

    for (int i = 0; i < val.length; i++) {
      if (val[i] == '(') {
        indexFrom = i;
      }
      if (val[i] == ')') {
        indexTo = i;
        break;
      }
    }

    final String calculation = _calculateMdas(val.substring(indexFrom + 1, indexTo));
    answer = indexFrom == 0
        ? ''
        : '${val.substring(0, indexFrom)}${_getSymbol(val[indexFrom - 1])}';
    answer = answer += calculation;
    answer += (indexTo + 1) == val.length
        ? ''
        : '${_getSymbol(val[indexTo + 1])}${val.substring(indexTo + 1)}';

    return answer;
  }

  /// Return the symbol before and after the parenthesis
  ///
  String _getSymbol(String value) {
    if (RegExp('[*,/,+,-,(,)]').hasMatch(value))
      return '';
    return '*';
  }

  
  /// This will calculate the first value pair 
  /// found in the data parameter depending of what operator
  /// pass in the symbol parameter
  ///
  String _calculate(String data, String symbol) {
    int indexLeft = 0;
    int indexRight = 0;

    String answer = '';

    String valueLeft = '';
    String valueRight = '';
    bool isStarFound = false;

    for (int i = 0; i < data.length; i++) {
      if (!isStarFound) {
        if (RegExp('[0-9.]').hasMatch(data[i])) {
          valueLeft += data[i];
        } else if (data[i] != symbol) {
          indexLeft = i + 1;
          valueLeft = '';
        }
      }
      if (isStarFound) {
        if (RegExp('[0-9.]').hasMatch(data[i])) {
          valueRight += data[i];
          if (i == data.length - 1)
            indexRight = i;
        } else {
          indexRight = i - 1;
          break;
        }
      }
      if (data[i] == symbol) {
        isStarFound = true;
      }
    }

    final double result = _getResult(valueLeft, valueRight, symbol);

    answer = indexLeft == 0 ? '' : data.substring(0, indexLeft);
    answer += '$result';
    answer += data.substring(indexRight + 1);

    return answer;
  }

  /// Calculate the [valueLeft] and [valueRight] 
  /// 
  /// It will return a result depending on what operator pass in the 
  /// [symbol] parameter
  /// 
  double _getResult(String valueLeft, String valueRight, String symbol) {
    double result = 0;
    switch (symbol) {
      case '*':
        result = double.parse(valueLeft) * double.parse(valueRight);
        break;
      case '/':
        result = double.parse(valueLeft) / double.parse(valueRight);
        break;
      case '+':
        result = double.parse(valueLeft) + double.parse(valueRight);
        break;
      default:
        result = double.parse(valueLeft) - double.parse(valueRight);
        break;
    }
    return result;
  }
}
