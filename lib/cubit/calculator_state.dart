abstract class CalculatorState {}

class CalculatorError extends CalculatorState {
  CalculatorError(this.message);

  final String message;
}

class CalculatorResponse extends CalculatorState {
  CalculatorResponse({this.result ='',this.error=''});
  final String result;
  final String error;

}

class CalculatorInitial extends CalculatorState{}
