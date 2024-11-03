class Solution {
  //List<int> nums1 =[]; //오름차순
  //List<int> nums2 = []; //오름차순
  //int m; //nums1의 요소의 개수
  //int n; //nums2의 요소의 개수
  //nums1과 nums2를 하나의 배열로 만들어라. 오름차순.
  //함수에서 반환X, nums1배열 안에 저장
  //nums1의 길이는 m+n

  //접근 1 : 어차피 오름차순이니까 for문을 인덱스로 돌려서, 더 큰 수를 넣으면 되려나?
  //-> 중첩이 너무 많아져서 중복값이 발생
  //접근 2 :  while로 풀어보자

  void merge(List<int> nums1, int m, List<int> nums2, int n) {
    int i = 0; // nums1 배열의 현재 인덱스
    int j = 0; // nums2 배열의 현재 인덱스
    int k = 0; // 결과를 저장할 위치 인덱스

    List<int> temp = List<int>.filled(m + n, 0); // 임시저장할 배열 : 정렬 결과 저장

    // nums1과 nums2를 비교하여 더 작은 값을 temp 배열에 넣음
    while (i < m && j < n) {
      if (nums1[i] < nums2[j]) {
        temp[k] = nums1[i];
        i++;
      } else if (nums1[i] == nums2[j]) {
        temp[k] = nums1[i];
        k++;
        temp[k] = nums2[j];
        i++;
        j++;
      } else {
        temp[k] = nums2[j];
        j++;
      }
      k++;
    }

    // 남은 요소를 temp 배열에 복사
    while (i < m) {
      temp[k] = nums1[i];
      i++;
      k++;
    }

    while (j < n) {
      temp[k] = nums2[j];
      j++;
      k++;
    }

    // temp 배열의 값을 nums1에 복사하여 반환하지 않고 nums1에 저장
    for (int x = 0; x < m + n; x++) {
      nums1[x] = temp[x];
    }
  }
}
