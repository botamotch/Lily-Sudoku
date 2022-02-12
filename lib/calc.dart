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
  List tmp_list = List.of(list);
  List indices = [];
  List nums = [];
  list.asMap().forEach((i, val) {
    if (val == 0) {
      indices.add(i);
    }
  });
  for (var i in indices) {
    nums.add(availableNums(tmp_list, i));
  }

  // print(indices);
  // print(nums);

  if (checkAnswer(tmp_list)) {
    for (var n = 0; n < 81; n += 1) {
      list[n] = tmp_list[n];
    }
    print('### answer found');
    return;
  }
  print('### answer not found');
}

void printNumber(list) {
  print("");
  for (var i = 0; i < 9; i += 1) {
    print(list.sublist(i * 9, (i + 1) * 9));
  }
}

// -----------------------------------------------------------------------------

void main() {
  List a = [0, 1, 2, 3];
  List b = [
    [5, 6, 7],
    [5, 8],
    [1, 3, 4]
  ];
  for (var i in b[0]) {
    for (var j in b[1]) {
      for (var k in b[2]) {
        print("> $i, $j, $k");
      }
    }
  }
  print("");

  // List<int> correctNumber = List.generate(81, (_) => 0);
  List<int> correctNumber = [];
  correctNumber += [4, 9, 3, 1, 0, 8, 2, 6, 0]; //  [4, 9, 3, 1, 5, 8, 2, 6, 7]
  correctNumber += [2, 5, 6, 3, 0, 7, 1, 8, 0]; //  [2, 5, 6, 3, 9, 7, 1, 8, 4]
  correctNumber += [1, 7, 8, 6, 0, 4, 5, 9, 0]; //  [1, 7, 8, 6, 2, 4, 5, 9, 3]
  correctNumber += [6, 4, 9, 2, 0, 1, 7, 5, 0]; //  [6, 4, 9, 2, 3, 1, 7, 5, 8]
  correctNumber += [7, 2, 1, 9, 0, 5, 3, 4, 0]; //  [7, 2, 1, 9, 8, 5, 3, 4, 6]
  correctNumber += [8, 3, 5, 7, 0, 6, 9, 1, 0]; //  [8, 3, 5, 7, 4, 6, 9, 1, 2]
  correctNumber += [5, 8, 2, 4, 0, 9, 6, 3, 0]; //  [5, 8, 2, 4, 7, 9, 6, 3, 1]
  correctNumber += [3, 1, 4, 5, 0, 2, 8, 7, 0]; //  [3, 1, 4, 5, 6, 2, 8, 7, 9]
  correctNumber += [9, 6, 7, 8, 0, 3, 4, 2, 0]; //  [9, 6, 7, 8, 1, 3, 4, 2, 5]
  setBlankNumber(correctNumber);

  // for (var i = 0; i < 1; i += 1) {
  //   correctNumber = List.generate(81, (_) => 0);
  //   setRandomNumber(correctNumber, [1, 2, 3]);
  //   setBlankNumber(correctNumber);
  // }

  // printNumber(correctNumber);
}
