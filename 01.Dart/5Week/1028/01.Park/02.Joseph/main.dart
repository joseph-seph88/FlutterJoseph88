import "dart:math";
// [5,3,2]
// [
//   ["A", "A", "-1", "B", "B", "B", "B", "-1"],
//   ["A", "A", "-1", "B", "B", "B", "B", "-1"],
//   ["-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1"],
//   ["D", "D", "-1", "-1", "-1", "-1", "E", "-1"],
//   ["D", "D", "-1", "-1", "-1", "-1", "-1", "F"],
//   ["D", "D", "-1", "-1", "-1", "-1", "E", "-1"]
// ]
// 3

int solution(List<int> mats, List<List<String>> park) {
  int maxSize = 0;
  int rows = park.length;
  int cols = park[0].length;
  List<List<int>> binaryPark = List.generate(rows, (_) => List.filled(cols, 0));

  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      if (park[i][j] == "-1") {
        if (i == 0 || j == 0) {
          binaryPark[i][j] = 1;
        } else {
          binaryPark[i][j] = min(
              min(binaryPark[i - 1][j], binaryPark[i][j - 1]),
              binaryPark[i - 1][j - 1]) +
              1;
        }
        maxSize = max(maxSize, binaryPark[i][j]);
      }
    }
  }

  for (int mat in mats) {
    if (mat <= maxSize) return mat;
  }

  return -1;
}

void main() {
  List<int> mats = [5, 3, 2];
  List<List<String>> park = [
    ["A", "A", "-1", "B", "B", "B", "B", "-1"],
    ["A", "A", "-1", "B", "B", "B", "B", "-1"],
    ["-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1"],
    ["D", "D", "-1", "-1", "-1", "-1", "E", "-1"],
    ["D", "D", "-1", "-1", "-1", "-1", "-1", "F"],
    ["D", "D", "-1", "-1", "-1", "-1", "E", "-1"]
  ];

  int result = solution(mats, park);
  print(result);
}
