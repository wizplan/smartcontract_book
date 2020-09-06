// uint 타입의 동적 배열7개가 있는 배열을 정의
uint[] memory a = new uint[](7);

// 동적 배열의 일곱 번째 요솟값으로 8을 설정
a[6] = 8;

// bytes 타입의 동적 배열을 정의
bytes memory b = new bytes(5);

// 동적 배열 b의 첫 번째 요솟값으로 '0'을 설정
b[0] = '0';

string memory s = 'keyword';

// string은 요소의 인덱스를 사용할 수 없음
// s[0] = '1';