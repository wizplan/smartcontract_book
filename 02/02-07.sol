// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

contract SetOwnerContract {
    address owner; // 상태 변수
    constructor() { // 생성자 정의
        owner = msg.sender; // 상태 변수 owner에 msg.sender 할당
    }
}