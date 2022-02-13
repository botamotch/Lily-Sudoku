import 'dart:math';

/* Help function*/
// List _toRowList(list)
//   [[0,  1,  2,  3,  4,  5,  6,  7,  8],
//   [ 9, 10, 11, 12, 13, 14, 15, 16, 17],
//   [18, 19, 20, 21, 22, 23, 24, 25, 26],
//   [27, 28, 29, 30, 31, 32, 33, 34, 35],
//   [36, 37, 38, 39, 40, 41, 42, 43, 44],
//   [45, 46, 47, 48, 49, 50, 51, 52, 53],
//   [54, 55, 56, 57, 58, 59, 60, 61, 62],
//   [63, 64, 65, 66, 67, 68, 69, 70, 71],
//   [72, 73, 74, 75, 76, 77, 78, 79, 80]]
// List _toColList(list)
//   [[0, 9, 18, 27, 36, 45, 54, 63, 72],
//   [1, 10, 19, 28, 37, 46, 55, 64, 73],
//   [2, 11, 20, 29, 38, 47, 56, 65, 74],
//   [3, 12, 21, 30, 39, 48, 57, 66, 75],
//   [4, 13, 22, 31, 40, 49, 58, 67, 76],
//   [5, 14, 23, 32, 41, 50, 59, 68, 77],
//   [6, 15, 24, 33, 42, 51, 60, 69, 78],
//   [7, 16, 25, 34, 43, 52, 61, 70, 79],
//   [8, 17, 26, 35, 44, 53, 62, 71, 80]]
// List squareList = [
//   [0, 1, 2, 9, 10, 11, 18, 19, 20],
//   [3, 4, 5, 12, 13, 14, 21, 22, 23],
//   [6, 7, 8, 15, 16, 17, 24, 25, 26],
//   [27, 28, 29, 36, 37, 38, 45, 46, 47],
//   [30, 31, 32, 39, 40, 41, 48, 49, 50],
//   [33, 34, 35, 42, 43, 44, 51, 52, 53],
//   [54, 55, 56, 63, 64, 65, 72, 73, 74],
//   [57, 58, 59, 66, 67, 68, 75, 76, 77],
//   [60, 61, 62, 69, 70, 71, 78, 79, 80]
// ];

final List<int> elements = [0, 1, 2, 9, 10, 11, 18, 19, 20];
final List<int> squares = [0, 3, 6, 27, 30, 33, 54, 57, 60];

List toRowList(list) {
  return [
    for (var i = 0; i < 9; i += 1)
      [for (var j = 0; j < 9; j += 1) list[j + i * 9]]
  ];
}

List toColList(list) {
  return [
    for (var i = 0; i < 9; i += 1)
      [for (var j = 0; j < 9; j += 1) list[j * 9 + i]]
  ];
}

List toSquareList(list) {
  return [
    for (var i in squares) [for (var j in elements) list[j + i]]
  ];
}

bool checkRow(list, n, nrow) {
  return toRowList(list)[nrow].contains(n);
}

bool checkCol(list, n, ncol) {
  return toColList(list)[ncol].contains(n);
}

bool checkSquare(list, n, nsqu) {
  return toSquareList(list)[nsqu].contains(n);
}

bool checkAnswer(list) {
  bool check = true;
  for (var i = 0; i < 9; i += 1) {
    for (var j = 0; j < 9; j += 1) {
      check = check & checkRow(list, i + 1, j);
      check = check & checkCol(list, i + 1, j);
      check = check & checkSquare(list, i + 1, j);
    }
  }
  return check;
}

int getRowNum(n) {
  return n ~/ 9;
}

int getColNum(n) {
  return n % 9;
}

int getSquareNum(n) {
  if ([0, 1, 2, 9, 10, 11, 18, 19, 20].contains(n)) {
    return 0;
  } else if ([3, 4, 5, 12, 13, 14, 21, 22, 23].contains(n)) {
    return 1;
  } else if ([6, 7, 8, 15, 16, 17, 24, 25, 26].contains(n)) {
    return 2;
  } else if ([27, 28, 29, 36, 37, 38, 45, 46, 47].contains(n)) {
    return 3;
  } else if ([30, 31, 32, 39, 40, 41, 48, 49, 50].contains(n)) {
    return 4;
  } else if ([33, 34, 35, 42, 43, 44, 51, 52, 53].contains(n)) {
    return 5;
  } else if ([54, 55, 56, 63, 64, 65, 72, 73, 74].contains(n)) {
    return 6;
  } else if ([57, 58, 59, 66, 67, 68, 75, 76, 77].contains(n)) {
    return 7;
  } else if ([60, 61, 62, 69, 70, 71, 78, 79, 80].contains(n)) {
    return 8;
  } else {
    return 0;
  }
}

List<int> availableNums(list, n) {
  List<int> nums = List.generate(9, (i) => i + 1);
  List l = toColList(list)[getColNum(n)] +
      toRowList(list)[getRowNum(n)] +
      toSquareList(list)[getSquareNum(n)];
  for (var i in l) {
    nums.remove(i);
  }
  return nums;
}

void setRandomNumber(list, nums) {
  if (nums.length == 0) {
    List tmpList = [];
    tmpList += [4, 9, 3, 1, 5, 8, 2, 6, 7];
    tmpList += [2, 5, 6, 3, 9, 7, 1, 8, 4];
    tmpList += [1, 7, 8, 6, 2, 4, 5, 9, 3];
    tmpList += [6, 4, 9, 2, 3, 1, 7, 5, 8];
    tmpList += [7, 2, 1, 9, 8, 5, 3, 4, 6];
    tmpList += [8, 3, 5, 7, 4, 6, 9, 1, 2];
    tmpList += [5, 8, 2, 4, 7, 9, 6, 3, 1];
    tmpList += [3, 1, 4, 5, 6, 2, 8, 7, 9];
    tmpList += [9, 6, 7, 8, 1, 3, 4, 2, 5];
    for (var i = 0; i < 81; i += 1) {
      list[i] = tmpList[i];
    }
    return;
  }
  bool check = true;
  List inputs = List.generate(9, (_) => [0, 1, 2, 3, 4, 5, 6, 7, 8]);
  for (var n in nums) {
    do {
      check = true;
      list.asMap().forEach((i, val) {
        if (val == n) list[i] = 0;
      });
      for (var i = 0; i < 9; i += 1) {
        inputs[i].shuffle();
        list[inputs[i].first + i * 9] = n;
      }
      for (var i = 0; i < 9; i += 1) {
        check = (check & checkRow(list, n, i));
        check = (check & checkCol(list, n, i));
        check = (check & checkSquare(list, n, i));
      }
    } while (!check);
    for (var i = 0; i < 9; i += 1) {
      inputs[i].removeAt(0);
    }
  }
}

void setBlankNumber(list) {
  List num_table = [];
  void _getBackTrack(n) {
    if (n == num_table.length) {
      return;
    } else {
      for (var x in num_table[n]['nums']) {
        if (!availableNums(list, num_table[n]['index']).contains(x)) {
          continue;
        }
        list[num_table[n]['index']] = x;
        _getBackTrack(n + 1);
        if (checkAnswer(list)) {
          return;
        }
      }
    }
  }

  list.asMap().forEach((i, val) {
    if (val == 0) {
      num_table.add({'index': i, 'nums': availableNums(list, i)});
    }
  });
  _getBackTrack(0);
}

void printNumber(list) {
  for (var i = 0; i < 9; i += 1) {
    print("  ${list.sublist(i * 9, (i + 1) * 9)}");
  }
}

// -----------------------------------------------------------------------------

void main() {
  List<int> correctNumber = [];

  // correctNumber += [4, 9, 3, 1, 0, 8, 2, 6, 0]; //  [4, 9, 3, 1, 5, 8, 2, 6, 7]
  // correctNumber += [2, 5, 6, 3, 0, 7, 1, 8, 0]; //  [2, 5, 6, 3, 9, 7, 1, 8, 4]
  // correctNumber += [1, 7, 8, 6, 0, 4, 5, 9, 0]; //  [1, 7, 8, 6, 2, 4, 5, 9, 3]
  // correctNumber += [6, 4, 9, 2, 0, 1, 7, 5, 0]; //  [6, 4, 9, 2, 3, 1, 7, 5, 8]
  // correctNumber += [7, 2, 1, 9, 0, 5, 3, 4, 0]; //  [7, 2, 1, 9, 8, 5, 3, 4, 6]
  // correctNumber += [8, 3, 5, 7, 0, 6, 9, 1, 0]; //  [8, 3, 5, 7, 4, 6, 9, 1, 2]
  // correctNumber += [5, 8, 2, 4, 0, 9, 6, 3, 0]; //  [5, 8, 2, 4, 7, 9, 6, 3, 1]
  // correctNumber += [3, 1, 4, 5, 0, 2, 8, 7, 0]; //  [3, 1, 4, 5, 6, 2, 8, 7, 9]
  // correctNumber += [9, 6, 7, 8, 0, 3, 4, 2, 0]; //  [9, 6, 7, 8, 1, 3, 4, 2, 5]
  // setBlankNumber(correctNumber);
  // printNumber(correctNumber);
  // print(checkAnswer(correctNumber));

  DateTime start, end;
  var average = 0.0;
  var times = 20.0;
  for (var i = 0; i < times; i += 1) {
    start = DateTime.now();
    do {
      correctNumber = List.generate(81, (_) => 0);
      setRandomNumber(correctNumber, [1, 2, 3, 4, 5, 6, 7]);
      setBlankNumber(correctNumber);
    } while (!checkAnswer(correctNumber));
    end = DateTime.now();
    average += end.difference(start).inMilliseconds;
    // print("### Start : ${start}");
    // print("### End   : ${end} (${end.difference(start)})");
    print(
        "### Check : ${checkAnswer(correctNumber)} (${end.difference(start).inMilliseconds / 1000})");
    // printNumber(correctNumber);
  }
  average = average / times / 1000;
  print("### Average Time : ${average}");
}
