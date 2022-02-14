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
        children: const [
          Expanded(child: FrameWidget()),
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
      81,
      (_) => const PanelWidget(
            input: 0,
            status: 0,
            correct: 0,
            text: '',
            border: '',
          ));

  void setNumber(var nums) {
    // 選択中のパネルに数字を入れる
    setState(() {
      for (var i = 0; i < 81; i += 1) {
        if ((status[i] % 2 == 1) & (status[i] ~/ 2 != 1)) {
          inputNumber[i] = nums;
        }
      }
      if (calc.checkAnswer(inputNumber)) {
        showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: const Text("ゲームクリア！"),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                    resetGame();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
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
    void _reset(num blank) {
      do {
        correctNumber = List.generate(81, (_) => 0);
        // calc.setRandomNumber(correctNumber, [1, 2, 3, 4, 5, 6, 7]);
        calc.setRandomNumber(correctNumber, []);
        calc.setBlankNumber(correctNumber);
      } while (!calc.checkAnswer(correctNumber));
      List<int> nums = List.generate(81, (i) => i);
      nums.shuffle();
      for (var i = 0; i < 81; i += 1) {
        if (i >= blank) {
          status[nums[i]] = 2;
          inputNumber[nums[i]] = correctNumber[nums[i]];
        } else {
          status[nums[i]] = 0;
          inputNumber[nums[i]] = 0;
        }
        status[nums[i]] = i >= blank ? 2 : 0;
      }
    }

    setState(() {
      showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("ゲームスタート"),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  _reset(10);
                  Navigator.pop(context);
                },
                child: const Text("かんたん"),
              ),
              SimpleDialogOption(
                onPressed: () {
                  _reset(30);
                  Navigator.pop(context);
                },
                child: const Text("ふつう"),
              ),
              SimpleDialogOption(
                onPressed: () {
                  _reset(50);
                  Navigator.pop(context);
                },
                child: const Text("むずかしい"),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    // resetGame();
  }

  @override
  Widget build(BuildContext context) {
    var margin = 10.0;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    String border = '';
    if (width > height * 9 / 14) {
      width = height * 9 / 14;
    } else {
      width = width - 2 * margin;
    }
    List<Positioned> _positionList = [];
    // Panel
    for (var i = 0; i < 81; i += 1) {
      border = '';
      border += (i ~/ 9 == 0) ? 't' : '';
      border += (i ~/ 9 == 8) ? 'b' : '';
      border += (i % 9 == 0) ? 'l' : '';
      border += (i % 9 == 8) ? 'r' : '';
      panelList[i] = PanelWidget(
        input: inputNumber[i],
        correct: correctNumber[i],
        status: status[i],
        text: '',
        border: border,
      );
      _positionList.add(Positioned(
        top: margin + width / 9 * (i ~/ 9),
        left: margin + width / 9 * (i % 9),
        width: width / 9,
        height: width / 9,
        child: GestureDetector(
          onTap: () => selectPanel(i),
          child: panelList[i],
        ),
      ));
    }

    // Button
    for (var i = 0; i < 9; i += 1) {
      border = '';
      // border += (i ~/ 9 == 0) ? 't' : '';
      // border += (i ~/ 9 == 8) ? 'b' : '';
      border += (i % 9 == 0) ? 'l' : '';
      border += (i % 9 == 8) ? 'r' : '';
      _positionList.add(Positioned(
        top: margin + width,
        left: margin + width / 9 * (i % 9),
        width: width / 9,
        height: width / 9,
        child: GestureDetector(
          onTap: () => setNumber(i + 1),
          child: PanelWidget(
              correct: 0,
              input: 0,
              status: 4,
              text: '${(i + 1)}',
              border: border),
        ),
      ));
    }
    _positionList.add(Positioned(
      top: margin + width * (1 + 1 / 9),
      left: margin,
      width: width,
      height: width / 9,
      child: GestureDetector(
        onTap: () => setNumber(0),
        child: const PanelWidget(
            correct: 0, input: 0, status: 4, text: 'Clear', border: 'blr'),
      ),
    ));
    _positionList.add(Positioned(
      top: margin + width * (1 + 3 / 9),
      left: margin,
      width: width,
      height: width / 9,
      child: GestureDetector(
        onTap: () => resetGame(),
        child: const PanelWidget(
            correct: 0, input: 0, status: 4, text: 'ゲームスタート', border: 'tblr'),
      ),
    ));

    return Stack(
      fit: StackFit.expand,
      children: _positionList,
    );
  }
}

class PanelWidget extends StatelessWidget {
  const PanelWidget({
    Key? key,
    required this.input,
    required this.status,
    required this.correct,
    required this.text,
    required this.border,
  }) : super(key: key);

  final int input;
  final int correct;
  final int status;
  final String text;
  final String border;

  @override
  Widget build(BuildContext context) {
    Color color;
    String content;
    var style;
    // 0：入力可能、未選択／1：入力可能、選択中／2,3：入力不可／その他：Button
    if (status == 0) {
      color = Colors.white70;
      content = (input != 0) ? '$input' : '';
      style = const TextStyle(fontWeight: FontWeight.normal);
    } else if (status == 1) {
      color = Colors.black12;
      content = (input != 0) ? '$input' : '';
      style = const TextStyle(fontWeight: FontWeight.normal);
    } else if ((status & 2) == 2) {
      color = Colors.white12;
      content = (correct != 0) ? '$correct' : '';
      style = const TextStyle(fontWeight: FontWeight.bold);
    } else {
      color = Colors.black12;
      content = text;
      style = const TextStyle(fontWeight: FontWeight.bold);
    }
    return Container(
      alignment: const Alignment(0.0, 0.0),
      child: Text(content, style: style),
      decoration: BoxDecoration(
        color: color,
        // border: Border.all(color: Colors.black),
        border: Border(
          top: BorderSide(
            color: (border.contains('t') ? Colors.black87 : Colors.black87),
            width: (border.contains('t') ? 2.0 : 0.5),
          ),
          bottom: BorderSide(
            color: (border.contains('t') ? Colors.black87 : Colors.black87),
            width: (border.contains('b') ? 2.0 : 0.5),
          ),
          left: BorderSide(
            color: (border.contains('t') ? Colors.black87 : Colors.black87),
            width: (border.contains('l') ? 2.0 : 0.5),
          ),
          right: BorderSide(
            color: (border.contains('t') ? Colors.black87 : Colors.black87),
            width: (border.contains('r') ? 2.0 : 0.5),
          ),
        ),
      ),
    );
  }
}
