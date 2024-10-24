void main() {
  List<List<int>> targets = [
    [4, 5],
    [4, 8],
    [10, 14],
    [11, 13],
    [5, 12],
    [3, 7],
    [1, 4]
  ];

  Solution solution = Solution();
  print(solution.solution(targets));
}

class Solution {
  int solution(List<List<int>> targets) {
    targets.sort((a, b) => a[1].compareTo(b[1]));

    int cur = 0;
    int answer = 0;

    for (List<int> target in targets) {
      if (cur <= target[0]) {
        cur = target[1];
        answer++;
      }
    }

    return answer;
  }
}
