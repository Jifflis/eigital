import 'package:eigital_exam/cubit/calculator_cubit.dart';
import 'package:eigital_exam/cubit/calculator_state.dart';
import 'package:eigital_exam/widgets/calculator_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktoast/oktoast.dart';

class CalculatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calc'),
      ),
      body: BlocConsumer<CalculatorCubit, CalculatorState>(
        listener: (BuildContext context, CalculatorState state) {
          if (state is CalculatorResponse) {
            if (state.error.isNotEmpty) {
              showToast(state.error);
            }
          }
        },
        builder: (BuildContext context, CalculatorState state) {
          final CalculatorCubit cubit = BlocProvider.of(context);
          if (state is CalculatorResponse) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildResult(state),
                  _buildInput(cubit),
                  _buildKeypad(cubit),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  /// Build result section
  ///
  Widget _buildResult(CalculatorResponse state) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 30),
        child: Column(
          children: <Widget>[
            Text(
              state.result.isEmpty ? state.error : state.result,
              style: const TextStyle(
                fontSize: 48,
              ),
            ),
            const Divider()
          ],
        ),
      );

  /// Build input section
  ///
  Widget _buildInput(CalculatorCubit cubit) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: cubit.controller,
              showCursor: true,
              readOnly: true,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
            const Divider()
          ],
        ),
      );

  /// Build keypad section
  ///
  Widget _buildKeypad(CalculatorCubit cubit) => Container(
        height: 500,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: GridView.count(
          padding: const EdgeInsets.all(5),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 4,
          children: <Widget>[
            CalculatorButton('1', () {
              cubit.controller.text += '1';
            }),
            CalculatorButton('2', () {
              cubit.controller.text += '2';
            }),
            CalculatorButton('3', () {
              cubit.controller.text += '3';
            }),
            CalculatorButton('x', () {
              cubit.controller.text += '*';
            }),
            CalculatorButton('4', () {
              cubit.controller.text += '4';
            }),
            CalculatorButton('5', () {
              cubit.controller.text += '5';
            }),
            CalculatorButton('6', () {
              cubit.controller.text += '6';
            }),
            CalculatorButton('/', () {
              cubit.controller.text += '/';
            }),
            CalculatorButton('7', () {
              cubit.controller.text += '7';
            }),
            CalculatorButton('8', () {
              cubit.controller.text += '8';
            }),
            CalculatorButton('9', () {
              cubit.controller.text += '9';
            }),
            CalculatorButton('+', () {
              cubit.controller.text += '+';
            }),
            CalculatorButton('(', () {
              cubit.controller.text += '(';
            }),
            CalculatorButton('0', () {
              cubit.controller.text += '0';
            }),
            CalculatorButton(')', () {
              cubit.controller.text += ')';
            }),
            CalculatorButton('-', () {
              cubit.controller.text += '-';
            }),
            CalculatorButton('.', () {
              cubit.controller.text += '.';
            }),
            CalculatorButton('c', () {
              final String text = cubit.controller.text;
              cubit.controller.text = text.substring(0, text.length - 1);
            }),
            CalculatorButton('ca', () {
              cubit.clearResult();
              cubit.controller.clear();
            }),
            CalculatorButton('=', () {
              cubit.compute(cubit.controller.text);
            }),
          ],
        ),
      );
}
