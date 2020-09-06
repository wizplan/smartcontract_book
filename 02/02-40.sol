// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

contract SmartSpeaker {
    // public 제한자를 설정한 함수의 상태 변수 response는 자동으로 getter를 생성
    string public response;

    constructor() {
        response = "";
    }

    function listen(uint _number) public returns(string memory) {
        if (_number <= 100) {
            response = "small!";
        } else if (_number <= 1000) {
            response = "normal!!";
        } else if (_number <= 10000) {
            response = "large!!!";
        } else if (_number <= 100000) {
            response = "WOWOWO!!!!";
        } else {
            response = "unbelievable!!!!!";
        }

        return response;
    }
}