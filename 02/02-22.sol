function isOwner() public view returns(bool) {
    return msg.sender == _owner; // _owner는 계약 소유자의 주소
}

modifier onlyOwner() {
    require(isOwner());
    _; // modifier 키워드를 사용한 함수 이름이 정의된 다른 함수를 실행
}

function _createZombie(string memory _name, uint _dna) public onlyOwner {
    .... // 좀비를 만드는 코드
}