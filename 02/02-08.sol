bool a = true;
bool b = false;

// a가 true면 b를 평가하지 않으며, c는 true입니다.
bool c = a || b;

// b가 false면 a는 평가하지 않으며, c는 false입니다.
bool d = b && a;