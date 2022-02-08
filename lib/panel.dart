import 'package:flutter/material.dart';
import 'dart:math';

class GameAreaWidget extends StatelessWidget {
  const GameAreaWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: FrameWidget()),
          // Expanded(child: MenuWidget()),
        ],
      ),
    );
  }
}

class FrameWidget extends StatefulWidget {
  const FrameWidget({Key? key}) : super(key: key);
  @override
  State<FrameWidget> createState() => _FrameWidgetState();
}

class _FrameWidgetState extends State<FrameWidget> {
  List<int> inputNumber = List.generate(81, (_) => 0);
  List<int> correctNumber = List.generate(81, (_) => 0);
  List<int> status = List.generate(81, (_) => 0);
  List<PanelWidget> panelList = List.generate(
      81, (_) => PanelWidget(inputNumber: 0, status: 0, correctNumber: 0));

  void setNumber(var num) {
    // 選択中のパネルに数字を入れる
    setState(() {
      for (var i = 0; i < 81; i += 1) {
        if ((status[i] % 2 == 1) & (status[i] ~/ 2 != 1)) {
          inputNumber[i] = num;
        }
      }
    });
  }

  void selectPanel(var j) {
    // パネルを選択する
    // i == j : 選択中。 X | 1 で bit1 をHiにする
    // i != j : 未選択。 X & 2 で bit1 をLoにする
    setState(() {
      for (var i = 0; i < 81; i += 1) {
        status[i] = (i == j) ? (status[i] | 1) : (status[i] & 2);
      }
    });
  }

  void resetGame() {
    setState(() {
      for (var i = 0; i < 81; i += 1) {
        correctNumber[i] = Random().nextInt(9) + 1;
        inputNumber[i] = 0;
        status[i] = i > 40 ? 2 : 0;
      }
    });
  }

  void checkAnswer() {
    List<int> row;
    List<int> col;
    List<int> square;
    List<int> numbers = List.generate(9, (i) => i + 1);
    setState(() {
      bool correctAnswer = true;
      if (inputNumber.contains(0)) {
        correctAnswer = false;
      } else {
        for (var i = 0; i < 9; i += 1) {
          // 列、行、マスに数字を入れる
          row = [for (var j = i * 9; j < (i + 1) * 9; j += 1) inputNumber[j]];
          col = [for (var j = i; j < 81; j += 9) inputNumber[j]];
          square = inputNumber.sublist(i, i + 3) +
              inputNumber.sublist(i + 9, i + 12) +
              inputNumber.sublist(i + 18, i + 21);
          // 1..9までの数字をすべて含むならばtrue
          correctAnswer = correctAnswer &
              row
                  .map((x) => numbers.contains(x))
                  .toList()
                  .reduce((a, b) => a & b);
          correctAnswer = correctAnswer &
              col
                  .map((x) => numbers.contains(x))
                  .toList()
                  .reduce((a, b) => a & b);
          correctAnswer = correctAnswer &
              square
                  .map((x) => numbers.contains(x))
                  .toList()
                  .reduce((a, b) => a & b);
          if (!correctAnswer) {
            break;
          }
        }
      }
      if (correctAnswer) {
        // showDialog(
        //   context: context,
        //   builder: (context) {
        //     return SimpleDialog(
        //       title: Text("ゲームクリア！"),
        //       children: <Widget>[
        //         SimpleDialogOption(
        //           onPressed: () => ({}),
        //           child: Text("OK"),
        //         ),
        //       ],
        //     );
        //   },
        // );
        resetGame();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    List<Positioned> _positionList = [];
    // Panel
    for (var i = 0; i < 81; i += 1) {
      panelList[i] = PanelWidget(
        inputNumber: inputNumber[i],
        correctNumber: correctNumber[i],
        status: status[i],
      );
      _positionList.add(Positioned(
        top: width / 9 * (i ~/ 9),
        left: width / 9 * (i % 9),
        width: width / 9,
        height: width / 9,
        child: GestureDetector(
          onTap: () {
            selectPanel(i);
          },
          child: panelList[i],
        ),
      ));
    }
    // Button
    for (var i = 0; i < 9; i += 1) {
      _positionList.add(Positioned(
        top: width,
        left: width / 9 * (i % 9),
        width: width / 9,
        height: width / 9,
        child: GestureDetector(
          onTap: () {
            setNumber(i + 1);
          },
          child: PanelWidget(
            correctNumber: 0,
            inputNumber: (i + 1),
            status: 4,
          ),
        ),
      ));
    }
    _positionList.add(Positioned(
      top: width * (1 + 1 / 9),
      left: 0,
      width: width,
      height: width / 10,
      child: GestureDetector(
        onTap: () {
          setNumber(0);
        },
        child: PanelWidget(
          correctNumber: 0,
          inputNumber: 0,
          status: 4,
        ),
      ),
    ));

    return Stack(
      fit: StackFit.expand,
      children: _positionList,
    );
  }
}

class PanelWidget extends StatelessWidget {
  const PanelWidget(
      {Key? key,
      required this.inputNumber,
      required this.status,
      required this.correctNumber})
      : super(key: key);

  final int inputNumber;
  final int correctNumber;
  final int status;

  @override
  Widget build(BuildContext context) {
    Color color;
    String number;
    var style;
    if (status == 0) {
      // 入力可能、未選択
      color = Colors.white70;
      number = (inputNumber != 0) ? '$inputNumber' : '';
      style = TextStyle(fontWeight: FontWeight.normal);
    } else if (status == 1) {
      // 入力可能、選択中
      color = Colors.black12;
      number = (inputNumber != 0) ? '$inputNumber' : '';
      style = TextStyle(fontWeight: FontWeight.normal);
    } else if ((status & 2) == 2) {
      // 入力不可
      color = Colors.white12;
      number = (correctNumber != 0) ? '$correctNumber' : '';
      style = TextStyle(fontWeight: FontWeight.bold);
    } else {
      // Buttonパネル
      color = Colors.black12;
      number = (inputNumber != 0) ? '$inputNumber' : 'CLEAR';
      style = TextStyle(fontWeight: FontWeight.bold);
    }
    return Container(
      alignment: Alignment(0.0, 0.0),
      color: color,
      child: Text(number, style: style),
    );
  }
}
