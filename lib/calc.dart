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
// List _toSquareList(list)
//   [[0,  1,  2,  9, 10, 11, 18, 19, 20],
//   [ 3,  4,  5, 12, 13, 14, 21, 22, 23],
//   [ 6,  7,  8, 15, 16, 17, 24, 25, 26],
//   [27, 28, 29, 36, 37, 38, 45, 46, 47],
//   [30, 31, 32, 39, 40, 41, 48, 49, 50],
//   [33, 34, 35, 42, 43, 44, 51, 52, 53],
//   [54, 55, 56, 63, 64, 65, 72, 73, 74],
//   [57, 58, 59, 66, 67, 68, 75, 76, 77],
//   [60, 61, 62, 69, 70, 71, 78, 79, 80]]

List<int> correctNumber = List.generate(81, (_) => 0);
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

void printNumber() {
  for (var i = 0; i < 9; i += 1) {
    print(correctNumber.sublist(i * 9, (i + 1) * 9));
  }
}
