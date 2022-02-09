import 'package:flutter/material.dart';
import 'dart:math';
import 'calc.dart' as calc;

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

  void _resetNumber() {
    bool check = true;
    List inputs = List.generate(9, (_) => [0, 1, 2, 3, 4, 5, 6, 7, 8]);

    // 前半：ランダムに数字を入れていって、列・行・マスにダブりがあればやり直す
    for (var num in [1, 2, 3, 4]) {
      do {
        check = true;
        correctNumber.asMap().forEach((i, val) {
          if (val == num) correctNumber[i] = 0;
        });
        for (var i = 0; i < 9; i += 1) {
          inputs[i].shuffle();
          correctNumber[inputs[i].first + i * 9] = num;
        }
        for (var i = 0; i < 9; i += 1) {
          check = (check & calc.checkRow(correctNumber, num, i));
          check = (check & calc.checkCol(correctNumber, num, i));
          check = (check & calc.checkSquare(correctNumber, num, i));
        }
      } while (!check);
      for (var i = 0; i < 9; i += 1) {
        inputs[i].removeAt(0);
      }
    }
    // 後半：数字を入れていく
  }

  void resetGame() {
    setState(() {
      for (var i = 0; i < 81; i += 1) {
        inputNumber[i] = 0;
        // status[i] = i > 40 ? 2 : 0;
        status[i] = 2;
      }
      _resetNumber();
    });
  }

  void checkAnswer() {
    bool check;
    setState(() {
      if (inputNumber.contains(0)) {
        check = false;
      } else {
        check = true;
        for (var i = 0; i < 9; i += 1) {
          for (var j = 0; j < 9; j += 1) {
            check = check & calc.checkRow(inputNumber, i, j);
            check = check & calc.checkCol(inputNumber, i, j);
            check = check & calc.checkSquare(inputNumber, i, j);
          }
        }
      }
      if (check) {
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
    // ここにリセットボタン等を追加する

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
